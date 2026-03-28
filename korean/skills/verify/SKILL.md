---
name: verify
description: 수식 검증 — 논문 수식과 코드 구현 일치 여부. /check 수학 부분 단독 실행.
user-invocable: true
argument-hint: 파일 경로 또는 설명
tools: Bash, Read, Glob, Grep, Agent
---

# /verify — 수식 검증

논문 수식과 코드가 정말 일치하는지 검증한다. `/check`의 수학 검증만 단독 실행.
전체 점검이 필요하면 `/check`를 써라.

## 사용법

```
/verify <파일경로 또는 설명>
```

---

## Phase 1: 준비

1. **대상 코드 읽기.** 전체 구조, 핵심 수식이 구현된 부분 파악.
2. **논문 확인.** `papers/`에서 관련 summary 읽기. 없으면 사용자에게 어떤 논문 기준인지 물어봐라.
3. **변수 매핑 테이블 만들기.** 논문 notation ↔ 코드 변수명. 이거 없이 검증하면 반드시 빠뜨린다.

```
| 논문 | 코드 | 설명 |
|------|------|------|
| π_θ  | policy | policy network |
| A_t  | advantage | GAE advantage |
| ...  | ...  | ... |
```

---

## Phase 2: 분할 + 병렬 검증

코드를 수식 단위로 쪼개서 에이전트 여러 개한테 동시에 보내라. 한 에이전트가 전체를 보지 마라.

### 점검 항목

| 우선순위 | 항목 | 찾는 것 | 예시 |
|----------|------|---------|------|
| CRITICAL | 부호 오류 | gradient ascent vs descent | `loss = ratio * adv` (틀림) → `loss = -ratio * adv` (맞음) |
| CRITICAL | 빠진 항 | 논문에 있는데 코드에 없는 term | entropy bonus 빠짐, clipping 빠짐 |
| CRITICAL | detach 누락 | target에서 gradient가 새는 곳 | `V(s').detach()` 빠짐 |
| CRITICAL | 코드 ≠ 주장 | 문서에 쓴 것과 실제 코드가 다름 | "PPO clip" 쓴다면서 실제론 vanilla PG |
| HIGH | mean vs sum | batch size에 따라 결과 달라짐 | loss를 mean 안 하고 sum으로 계산 |
| HIGH | broadcasting | 차원 자동 확장으로 의도 다른 계산 | (N,1) * (N,) → 의도와 다른 shape |
| HIGH | discount/GAE | γ, λ 적용 순서, 방향 | 미래→현재 역순 안 하고 정순 계산 |
| HIGH | ablation 무결성 | 컴포넌트 제거 시 나머지가 정상 동작하는가 | entropy bonus 빼면 loss 계산이 깨지는 구조 |
| MEDIUM | 수치 불안정 | 위험한 연산 | `log(0)`, `exp(700)`, `x / 0` |
| MEDIUM | dtype | 정밀도 혼용 | float32 텐서에 float64 연산 섞임 |
| MEDIUM | 정규화 일관성 | obs/reward 정규화가 train과 eval에서 동일한가 | train에서 normalize하고 eval에서 안 함 |

### 검증 방법

- **논문 수식과 코드 한 줄씩 대조.** 매핑 테이블 기준으로.
- **작은 입력으로 손계산 vs 코드 출력 비교.** 2-3개 샘플로 숫자가 맞는지 직접 확인.
- **gradient 흐름 추적.** `.detach()`, `with torch.no_grad()`, `.requires_grad` 위치 확인.
- **edge case 테스트.** advantage=0, ratio=1, reward=0 같은 경계값에서 동작 확인.

---

## Phase 3: 교차 검증 + 보고

1. 에이전트 결과 비교. 불일치 = 가장 중요한 신호.
2. 보고 양식:

```
## 수식 검증 보고: {파일명}

### 변수 매핑
| 논문 | 코드 | 일치 |
|------|------|------|
| ... | ... | ✓/✗ |

### 발견 사항
| 심각도 | 위치 | 논문 수식 | 코드 동작 | 수정안 |
|--------|------|-----------|-----------|--------|
| ... | file:line | ... | ... | ... |

결과: PASS / WARN / FAIL
```

---

## 상태 보고

- **PASS** — 모든 수식 일치 확인.
- **WARN** — minor 이슈 (수치 안정성 등). 목록 명시.
- **FAIL** — critical 수학 오류 발견. 위치와 수정안 명시.
- **BLOCKED** — 논문 없거나 수식 모호해서 검증 불가. 사유 명시.
