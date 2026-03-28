---
name: optimize
description: 성능 최적화 — 병목 찾고 고치기. 측정 먼저. /check 성능 부분 단독 실행.
user-invocable: true
argument-hint: 파일 경로 또는 설명
tools: Bash, Read, Glob, Grep, Agent
---

# /optimize — 성능 최적화

병목을 찾고 고친다. **측정 먼저, 추측 금지.** `/check`의 성능 체크만 단독 실행.
전체 점검이 필요하면 `/check`를 써라.

## 사용법

```
/optimize <파일경로 또는 설명>
```

---

## Phase 1: 측정

수정 전에 반드시 현재 성능을 숫자로 측정한다. "느려 보인다"는 근거가 아니다.

1. **전체 시간 측정.** 한 step/epoch 얼마나 걸리는지.
2. **구간별 시간 측정.** 데이터 로딩, forward, backward, 환경 step 등 구간별로 쪼개서.
3. **GPU 사용률 확인.** `nvidia-smi` — utilization, memory.
4. **CPU 사용률 확인.** `uptime`, `htop` — 병목이 CPU인지 GPU인지.

```bash
# 예시: 구간별 시간 측정
import time
t0 = time.time(); env.step(); t_env = time.time() - t0
t0 = time.time(); loss.backward(); t_backward = time.time() - t0
```

---

## Phase 2: 분할 + 병렬 분석

코드를 파이프라인 단계별로 쪼개서 에이전트 여러 개한테 동시에 보내라.

### 점검 항목

| 우선순위 | 항목 | 찾는 것 | 예시 |
|----------|------|---------|------|
| HIGH | 불필요한 복사 | 루프 안에서 반복되는 `.clone()`, `.cpu()↔.cuda()` | 매 step `.cpu().numpy()` 후 다시 `.cuda()` |
| HIGH | 루프 안 텐서 생성 | 매 step 새로 만드는 텐서 | `torch.zeros()` 루프 안에서 반복 |
| HIGH | CPU-GPU 핑퐁 | device 사이 불필요한 이동 | reward 계산을 CPU에서 하고 다시 GPU로 |
| HIGH | 환경 병목 | env.step이 전체 시간의 대부분 | vectorized env 안 쓰고 for loop |
| HIGH | 데이터 로딩 | I/O가 학습을 기다리게 함 | num_workers=0, pin_memory 안 씀 |
| MEDIUM | 벡터화 가능 | for 루프를 텐서 연산으로 바꿀 수 있는 곳 | GAE를 python loop으로 계산 |
| MEDIUM | 메모리 누수 | 리스트에 텐서 계속 쌓기 | episode history를 detach 안 하고 쌓기 |
| MEDIUM | 병렬화 미활용 | 서버 자원을 다 안 쓰고 있음 | 단일 프로세스로 multi-seed 순차 실행 |
| MEDIUM | mixed precision 미활용 | float32로만 학습 | `torch.cuda.amp` 안 쓰고 있음 |
| LOW | 미사용 계산 | 계산하지만 결과를 안 쓰는 코드 | debug용 로깅이 production에서도 돌아감 |

### 병목 패턴

| 측정 결과 | 원인 | 수정 방향 |
|-----------|------|-----------|
| env step > 80% | 환경이 병목 | vectorize env, 병렬화 |
| CPU-GPU transfer > 30% | 데이터 이동 병목 | GPU에 유지, 이동 최소화 |
| GPU util < 30% | GPU 놀고 있음 | batch size 늘리기, async |
| backward > 50% | 모델/loss 복잡 | gradient checkpointing, 모델 경량화 |
| data loading > 20% | I/O 병목 | num_workers, pin_memory, prefetch |
| single GPU, multi available | 자원 낭비 | DataParallel 또는 multi-process |

---

## Phase 3: 수정 + 재측정

1. **한 번에 하나만 고쳐라.** 여러 개 동시에 바꾸면 뭐 때문에 빨라졌는지 모른다.
2. **고친 후 반드시 재측정.** Phase 1과 동일한 방법으로.
3. **개선 수치 보고.** before → after, 몇 % 개선.

---

## Phase 4: 보고

```
## 성능 최적화 보고: {파일명}

### 측정 (before)
| 구간 | 시간 | 비율 |
|------|------|------|
| env step | 0.8s | 80% ← 병목 |
| forward | 0.05s | 5% |
| backward | 0.1s | 10% |
| etc | 0.05s | 5% |

### 발견 사항
| 심각도 | 위치 | 문제 | 수정안 |
|--------|------|------|--------|
| HIGH | file:line | 설명 | 제안 |

### 측정 (after)
| 구간 | before | after | 개선 |
|------|--------|-------|------|
| env step | 0.8s | 0.2s | -75% |

결과: DONE / WARN / NO_ISSUE
```

---

## 상태 보고

- **DONE** — 병목 발견, 수정, 재측정으로 개선 확인. 숫자로 증명.
- **WARN** — 병목 발견했지만 구조적이라 간단히 못 고침. 보고만.
- **NO_ISSUE** — 측정 결과 병목 없음. 현재 성능 수치 명시.
- **BLOCKED** — 측정 불가 (서버 접근 안 됨 등). 사유 명시.
