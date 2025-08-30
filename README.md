# All New Sugar Rush

Cloudflare Worker + SvelteKit + D1 기반 프로젝트입니다.

## 기술 스택

- Cloudflare Workers
- SvelteKit (프론트엔드 프레임워크)
- Cloudflare D1 (데이터베이스)
- Tailwind CSS (스타일링)
- Node.js 호환성

## 설정

### 필수 요구사항

- Node.js 18+
- Wrangler CLI

### 설치

```bash
# 의존성 설치
npm install
```

### 환경 설정

1. Cloudflare 계정에 로그인:
```bash
npx wrangler login
```

2. D1 데이터베이스는 이미 생성되어 있습니다 (`all-new-sugar-rush`)

## 개발

```bash
# 로컬 개발 서버 실행
npm run dev

# 프로덕션 빌드
npm run build

# 프로덕션 배포 (main 브랜치)
npm run deploy
```

## 데이터베이스

```bash
# 스키마 실행
npm run db:generate

# 마이그레이션 적용
npm run db:migrate
```

## 라우트

- `/` - 메인 페이지
- `/health` - 헬스 체크

## 환경 변수

- `DB` - D1 데이터베이스 바인딩
