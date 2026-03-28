# 프로젝트 기본 구조

cleaning 스킬이 점검할 때 기준이 되는 표준 구조.
프로젝트마다 다를 수 있으니, 실제 프로젝트에 맞게 수정해서 쓴다.

```
project/
├── CLAUDE.md                  # 프로젝트 표지 (필수)
├── context/                   # 컨텍스트 관리 (필수)
│   ├── short_term.md          # 현재 세션 상태
│   ├── long_term.md           # 확정 결론, 방향
│   ├── exp_log.md             # 실험 기록
│   ├── archive/               # 이전 버전 보관 (절대 삭제 금지)
│   └── gpt-pro/               # GPT Pro 비동기 통신
│       ├── outbox/            # 보낼 프롬프트
│       ├── inbox/             # 받은 응답
│       └── archive/           # 처리 완료
├── scripts/                   # 현재 활성 스크립트만. 안 쓰면 legacy/로.
├── configs/                   # 설정 파일
├── libs/                      # 현재 활성 라이브러리만. 안 쓰면 legacy/로.
├── legacy/                    # scripts/, libs/에서 퇴역한 코드. 삭제 대신 여기로. 참조용 보존.
│   ├── scripts/               # 퇴역한 스크립트 (원래 위치 유지)
│   └── libs/                  # 퇴역한 라이브러리 (원래 위치 유지)
├── papers/                    # 논문 PDF + 요약
│   └── {paper-name}/
│       ├── original.pdf
│       └── summary.md
├── logs/                      # 실험 로그 (절대 삭제 금지)
│   └── archive/               # 오래된 로그 보관
├── data/                      # 데이터 (보통 gitignored)
└── results/                   # 결과물 (보통 gitignored)
```

## 각 폴더 규칙

| 폴더 | 삭제 가능 | 이동 가능 | 비고 |
|------|-----------|-----------|------|
| `context/` | X | archive만 | 맥락 소실 위험 |
| `context/archive/` | X | X | 영구 보존 |
| `logs/` | X | archive만 | 데이터 소실 위험 |
| `logs/archive/` | X | X | 영구 보존 |
| `papers/` | X | X | 논문 원본 보존 |
| `legacy/` | X | X | 참조용 보존 |
| `scripts/` | 사용자 승인 | O | 미사용 → legacy |
| `libs/` | 사용자 승인 | O | 미사용 → legacy |
| `data/`, `results/` | 사용자 승인 | O | gitignored 보통 |
| `__pycache__/`, `.pyc` | O | X | 자동 삭제 가능 |
