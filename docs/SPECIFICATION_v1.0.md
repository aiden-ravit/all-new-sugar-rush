# Sugar Rush 전용 앨범 관리 — 최종 통합 완성본 v1.0

**기준**: 2025‑08‑19 (Asia/Seoul) · **브랜드/아티스트**: Sugar Rush · **공개**: https://sugar-rush.team/ · **관리자**: https://admin.sugar-rush.team/

**외부 금칙**: 공개 웹/관리자 UI/문서/알림 등 외부 시청 가능 매체에는 "AI" 텍스트 비노출(위반 시 CI 게이트 실패). 내부 스키마에만 ai_type 등 키 사용.

## 0) 통합 원칙

Ultra Full MD 표준을 보존하면서, Sugar Rush 전용 팀·브랜딩·색채·권한·발매·수익·알림 요구를 개인화 레이어로 확장/오버라이드한다.

엔드투엔드 기준은 DoD·SLO/SLI·보안 게이트·런북에 일괄 반영한다.

## 1) 팀·브랜딩·권한(개인화 오버레이)

### 1-1. 멤버·기본 모드

- **멤버**: El(id=el), Otte(id=otte) – 두 명 모두 Full(Owner) 권한
- **민감 작업**: 수익지급/Secrets/정책은 Step‑up 요구
- **기본 테마**: El=다크, Otte=라이트(개인 설정에서 상호 전환 가능)

### 1-2. 컬러·아이덴티티 토큰

- **El**: Light #333434, Dark #CFCFD4
- **Otte**: Light #D7CBBF, Dark #FEFDF6
- **홈페이지**: 배경 #000000; 로고 메인 #FF2D96, 서브 #FF008C
- **썸네일 호버**: 앨범 대표 컬러로 로고 색 동시 전환(통일성·포인트)

### 1-3. 전역 아티스트 프로필

- 아티스트 사진(≥3000px), 소개(ko/en) 전역 공통값으로 관리
- "전체 반영 vs 신규만" 정책 선택 가능

## 2) 아키텍처 & 스택(표준 채택)

SvelteKit(SSR/PWA)+Tailwind, Workers+Hono(검증 Zod, OpenAPI3.1), D1→Postgres(Drizzle), R2/Images, KV/Edge 태그 캐시, Queues/Cron, Durable Objects+Yjs, OTel/RUM, Secrets/KMS.

## 3) 데이터 모델(표준 + 개인화 확장)

### 3-1. 표준 핵심(발췌)

albums, tracks, release_platform_links, assets(버전), rights_splits(=100), platform_payout_rules, platform_revenues, payout_requests, audit_logs 등.

**전곡 특수조건(내부 전용)**: tracks.ai_type='ai_composite' 고정 및 체크 제약.

### 3-2. 개인화 테이블(비침투 추가)

- `members(id,name,default_theme,light_color,dark_color)`
- `artist_profile(display_name,bio_ko,bio_en,photo_asset_id)`
- `branding(site_bg,logo_main,logo_sub)`
- `album_colors(album_id,color_hex,contrast_ok,delta_e_ok,approved_by,approved_at)` + color_history
- `expenses(구독/아트 등 지출, 영수증 증빙)`

→ 표준 스키마와 조인 없이 병행 참조 가능하도록 설계.

## 4) 디자인 시스템/UX

다크 기본·라이트·시스템 토글(토큰 서버/클라 동기화), aXe 0, 포커스 링≥1.5px, ARIA 완비.

**핵심 컴포넌트**: Card/TagChip/Combobox/Kanban/Timeline/DiffViewer/HLS Player/ColorBadge/CalendarBadge/MoneyBadge.

## 5) 입력·업로드·색채 게이트(개인화 포함)

### 이미지
- 정사각 1:1, ≥3000px, JPEG/PNG/WebP/AVIF, EXIF 제거, ≤10MB
- **대표 컬러 추출 규칙**: ΔE00≥12(최근 30개와 중복 금지), WCAG AA 대비≥4.5:1(블랙 배경), 브랜드 핑크/마젠타 제외
- **실패 시 대체안 3개 자동 제안** + 승인 기록(Color History 적재)

### 오디오
- WAV 16/24bit, 44.1/48kHz, ≤20분, ≤512MB

### 권리
- 분배 합=100% + 증빙 필수(미충족 시 예약/발매 차단)

### [신규 UX 명세 — 실패 판정/대체안]

**실패 사유 표시**: (1) 대비 미달, (2) ΔE 중복, (3) 브랜드 색 충돌, (4) 신뢰도<0.6

**모달에서 대체안 칩 3개 미리보기** 또는 수동 HEX 입력(실시간 대비/ΔE 평가) → 승인 시 approved_by/at 기록.

## 6) 협업(실시간/Yjs·버전)

룸≤100, 50ops/s, 배칭30ms, awareness 250ms, 레이트리밋/쿼터/스냅샷/GC, Spike Guard. @멘션·태스크(상태/담당/마감), 이력 잠금/감사.

## 7) 발매·일정(뮤직스프레이 수동 신청 + 자동 감지)

### 발매 신청
- 뮤직스프레이 수동 등록
- 플랫폼 링크는 공개 검색/검증으로 자동 확인(Apple→YouTube→Melon→Flo→Vibe 순, HEAD/GET)
- 실패 시 백오프(1m→5m→15m→1h), 수동 오버라이드 지원
- **발매 확정+링크 활성 시 완전 노출, 예정은 비선택 노출(카운트다운)**

### 일정
- 발매일 자동 등록·변경 이력 보존, D‑7/D‑1/D‑day 알림 + PWA 푸시/Chat 카드

### [신규 실패 플로우 — 링크체커]
**상태**: PENDING_CHECK→CHECKING→[ACTIVE|RETRY_SCHEDULED|MANUAL_REQUIRED]

**토스트**: "멜론 타임아웃(3001). 15분 후 재시도" / "YouTube 인증 제한(3002). 1h 후 재시도 또는 수동 확정"

**에러 포맷**: RFC9457 Problem+JSON(code=3xxx, retry_after 포함).

## 8) 검색/추천

TS(ko/en)+pg_trgm+pgvector. 랭킹 가중: 정확+10 > 접두+6 > 부분+3 > 태그+2 > 최신+1. 실시간 150ms 디바운스, 정확/유사/추천 3구획 UI.

## 9) 미디어 파이프라인

Presign(5–10MB 청크/동시3), MIME+확장자 이중 검증, ClamAV. 이미지 WebP/AVIF, 4배 업스케일, ΔE/대비 배지, R2 버전 롤백. 오디오 HLS(30–60s), 서명 URL.

## 10) 관리자 UX(개인화 반영)

**대시보드**: 내 할 일/멘션/⏳/실패 태스크/최근 변경

**편집 폼**: Combobox 오토컴플리트, 금칙어 검사, 컬러 후보3 + 대비/ΔE, Suno 내부 파라미터(비노출) 기록, 버전 타임라인+Diff, 가사 Yjs, HLS 프리뷰, 링크체커 패널, 피드백 스레드, 도움말.

## 11) 홈페이지 UX(브랜딩 반영)

블랙 카드(2–6열), 썸네일: 앨범명/테마색/트랙수/한줄 소개/발매일/플랫폼 버튼. 상세: 히어로(커버+컬러), 소개, 트랙(가사 토글), HLS 프리뷰, 링크, 추천. **표시 토글/예약 노출 지원**.

## 12) 수익·지출(엑셀 수동 업로드 포함)

### 원천→임계→지급 흐름
CSV/API 임포트→platform_revenues 적재→platform_payout_rules 임계 평가→READY→REQUESTED→APPROVED(2인)→PAID(+증빙 첨부). Calendar 반영, Time Travel 재현.

### 엑셀 수동 업로드
(일자/사이트/곡/재생수/금액[USD/KRW]) → 트랙/앨범 자동 매칭·중복/형식/통화 일관성 검증.

**오류 예시**: 
- [Row 12] 금액 형식 오류 "12,3O0" → "12300" 교정 제안
- [Row 34] 통화 불일치
- [Row 56] 트랙 매칭 후보 선택

**업로드 요약**: 성공/경고/오류 집계, 오류행 CSV 다운로드, "자동 교정 후 재검증" 옵션.

**통계**: 일/월, 사이트/앨범/곡별 시계열·분포 그래프.

**지출(expenses)**: Suno 구독료·기타 비용, 영수증 증빙(OCR 보조).

**기본 분배**: 50:50(변경 시 이력+상호 동의 서명).

## 13) 보안/법무/라이선스

### 인증/세션
HTTPOnly/SameSite, TOTP 2FA, Argon2id, CSRF, CSP/HSTS/Referrer/Permissions‑Policy, 업로드 AV 스캔/메타 제거/서명 URL.

### 감사
append‑only + 서명, 민감 변경 2인 승인, Break‑glass 로그.

### 금칙어 게이트
외부 노출 문자열에 "AI" 검출 시 CI 실패.

### 라이선스
MIT/Apache2 허용, GPL 불가(SBOM 스캔로 검증).

### [신규 — 금칙어 예외 처리]

**플로우**: AUTHOR→예외신청→APPROVER1(내부)→APPROVER2(내부/파트너)→머지

**승인 화면**: 사유/범위/기간/대체문구 검토/리스크 체크

**만료**: 7일/1일 전 리마인더, 만료 시 자동 롤백 또는 연장 카드 생성

**로그 포맷**: append‑only+서명, diff 참조, 기간/범위/승인자/사유 저장

## 14) 알림/운영(노이즈 제어 포함)

Google Chat Cards v2(threadKey, Severity 칩 🔴🟠🟢, ⏳카운트다운), 버튼(Docs/Sheets/Calendar/Runbook/CLI), OAuth 최소 스코프.

**Noise Reduction(15m suppress)**: 동일 엔터티·유형은 15분 윈도우 최대 1건. 초과는 묶음 카드("+7건"). PWA 푸시도 공유 윈도우. 회로 OPEN(5m 실패율 30%↑) 시 개별 경고 억제하고 1건 요약만 발송.

## 15) API·리밋·에러(Problem+JSON)

사용자/IP 60/min, 오토컴플리트 15/min, 업로드 동시 3.

에러는 RFC9457 Problem+JSON + 에러코드 사전(1xxx 입력/2xxx 권리/3xxx 유통·수익/4xxx 미디어/5xxx 협업/6xxx 외부연산/7xxx 인프라/9xxx 기타).

## 16) 성능/품질·SLO/SLI

검색 p95<400ms(히트 150ms), 저장 성공≥99.95%, 큐 p95<60s, HLS 성공≥99.0%(지연 p95<5m), 외부연산 성공≥97%(p95<3s/회로≤5%), Chat p95<30s/Reply 누락≤0.5%, 수익 import→집계 p95<10m/임계 p95<1m/출금 TAT 중앙값≤3d.

## 17) 테스트/배포/런북

유닛≥80%, 통합/스모크, aXe/Lighthouse, SAST/DAST, SBOM. Dev→Stg 자동, Prod 2인 승인, Step‑up(민감·고액), 1‑click 롤백, 카나리 1–5%+가드레일/킬스위치. E2E: 콜드보정/정책충돌/ROI 버전/수익 READY→PAID.

## 18) 홈페이지 노출 규칙(요약)

- **발매 예정**: 비선택 노출(카운트다운)
- **발매 확정+링크 활성**: 완전 노출
- **모든 값**: 수동/예약 노출 가능

## 19) 질문지 매핑(개인화 체크 완료)

- 팀/역할/Full 권한/브랜딩/로고·컬러 가이드 – **확정**
- 2FA, IP정책(Anywhere + 이상징후 알림), 백업/DR(스냅샷15m/RPO15m/RTO2h/7일 보존) – **확정**
- 앨범 필수 필드·협업 메타·Suno 내부 파라미터·원곡/버전·이력 – **확정**
- 프로세스 단계 고정+커스터마이즈/2인 기록/피드백 태스크 – **확정**
- 발매/홈 연동·테마컬러 자동 추출(중복 금지) – **확정**
- 수익: 최소 출금/정산 주기/증빙 100%/분배 50:50 – **확정**
- 일정/캘린더(자동 등록/카운트다운/개인 통합) – **확정**
- 보안/코드 정책(Argon2id/CSP/HSTS/CSRF), 라이선스(MIT/Apache 허용·GPL 불가) – **확정**

## 20) 로드맵·스프린트(개인화 반영)

### 월1–2(P0)
DB/ORM(개인화 테이블 포함), 업로드/검증, 컬러 추출 게이트, 검색 3구획, 예약·링크체커, 관리자 기본 테마, Suno 내부필드, 금칙어 게이트

### 월3–4(P1)
HLS, Yjs, Chat+Calendar, 엑셀 업로드→합산, 지출/그래프, KPI 대시보드 1차

### 월5–6(P2)
추천 A/B, 증빙 OCR 보조, Time Travel 뷰, 푸시 최적화, 라이선스 대시보드

## 부록) 코드/스니펫(발췌)

### 링크체커 API
```typescript
POST /api/link-check { platform, url } → 200|RetryableError
```

### HLS
```bash
ffmpeg -i in.wav -codec:a aac -b:a 256k -f hls -hls_time 60 out.m3u8
```

### Drizzle
```bash
drizzle-kit generate && drizzle-kit migrate
```

### 수익 Ready 조회
```bash
sugar-cli payout --ready --min=100000
```

## 결론

Ultra Full 표준을 근간으로, Sugar Rush의 팀·브랜딩·발매/홈 연동·수익/엑셀 업로드·알림 노이즈 제어·금칙어 예외·대표색 대체안 등 현장 UX/운영 세부를 완전 통합했습니다.

---

**문서 버전**: v1.0  
**최종 업데이트**: 2025-08-19  
**작성자**: Sugar Rush Development Team  
**검토 상태**: 최종 승인 완료
