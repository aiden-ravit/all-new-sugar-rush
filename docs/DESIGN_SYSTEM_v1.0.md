# 🎯 Sugar Rush 관리자 페이지 디자인 시스템 & 레이아웃 규칙 v1.0

> 아래 한 문서만 보면 누구나 그대로 구현할 수 있게, **아이콘만 쓰는 현재 구조**를 기준으로 **버튼 · 배지 · 컬러 · 레이아웃 규칙**을 전부 담은 최종 완성본입니다.

**요구사항**: 기본 폰트색 `#888888` 고정, 기존 색값 유지, 다크·라이트 테마 모두 포함, 재시도 버튼 호버는 "시안 배경 + 검정 텍스트", 아이콘 뒤 원형/좌측 컬러바 없음

---

## 🎯 적용 범위

* 패널 6개(3열 × 2행) **동일 크기**
* 각 패널 내부: **아이템 박스 3개**(컨텐츠 없으면 동일 높이의 빈 자리 유지)
* 아이템 1행 레이아웃: **왼쪽 아이콘(원형 배경 없음) / 가운데 텍스트(제목·설명) / 오른쪽 메타(배지·버튼·시간)**
* **멘션/최근 변경**: 사용자 배지 **EL/OT(2글자 고정폭)**, 사용자 색 적용
* **할 일/마감 임박**: 상태/우선순위 배지(아웃라인형)
* **오늘 발매 일정**: 타입 배지(앨범/트랙/마감, 아웃라인형)
* **실패 태스크**: 재시도 버튼(핫핑크 Solid → 호버 시 시안+검정)
* **패널 하단 핫핑크 링크**: 마지막 아이템 하단과 패널 하단 사이 **정중앙**

---

## 1) 디자인 토큰(전역 변수) — 다크·라이트 포함

> 이 블록을 글로벌 CSS의 `:root`에 붙여야 합니다. 라이트 모드는 `<html data-theme="light">`로, 기본은 다크로 쓰면 됩니다.

```css
:root{
  /* 타이포 & 공통 텍스트 */
  --font-base: Inter, Pretendard, system-ui, -apple-system, sans-serif;
  --text-base: #888888;   /* ✅ 기본 폰트색 고정(요구사항) */
  --text-strong: #B6B6B6; /* 카드 타이틀/강조 */
  --text-muted: #6F6F6F;  /* 보조(시간/부가) */

  /* 스페이싱(8px 그리드) */
  --sp-2: 8px;
  --sp-3: 12px;
  --sp-4: 16px;
  --sp-5: 20px;
  --sp-6: 24px;
  --sp-8: 32px;

  /* 패널 사이즈 고정(6개 동일) */
  --panel-h: 540px;          /* 필요 시 560/580 등으로 통일 조정 */

  /* 배경/윤곽/모서리/그림자 */
  --border-subtle: #252528;  /* 다크 기준, 라이트에서 오버라이드 */
  --radius-6: 12px;          /* 패널(카드) */
  --radius-4: 8px;           /* 아이템 박스/배지 */
  --shadow-1: 0 8px 24px rgba(0,0,0,.25);

  /* 브랜드 & 상태(공통) */
  --brand-pink: #FF3DAE;   /* 링크/핵심 버튼 */
  --hover-cyan: #17E1BC;   /* ✅ 재시도 버튼 호버 배경 */
  --danger-fg: #FF6B6B;    /* 긴급/높음 */
  --warn-fg:   #EBCB4E;    /* 주의/보통 */
  --ok-fg:     #17E1BC;    /* 정상/낮음 */

  /* 사용자(EL/OT) */
  --user-el: #A6FF00;
  --user-ot: #FF835C;

  /* 타입 배지 */
  --tag-album:    #EA6DC9;
  --tag-track:    #8BB4DF;
  --tag-deadline: #17E1BC;

  /* 아이템 3개 사이 간격("내부 박스 사이 위아래 간격") */
  --item-gap: var(--sp-3); /* 12px — 여기만 바꿔도 3개 간격만 늘어남 */

  /* 마지막 핫핑크 링크 중앙 배치용 하단 여백 총량 */
  --panel-bottom-gap: 56px; /* 패널 바닥~마지막 아이템 바닥 사이 총 여백 */
}

/* 다크 테마(기본 감성 유지) */
:root{
  --bg:        #0C0C0E;
  --surface-2: #101012;  /* 패널(카드) */
  --surface-1: #151517;  /* 아이템 박스 */
}

/* 라이트 테마(아이보리/크림/베이지) */
:root[data-theme="light"]{
  --bg:        #F7F3E9;  /* Ivory */
  --surface-2: #F3EBDD;  /* Cream */
  --surface-1: #FFF8EF;  /* Light-Cream */
  --border-subtle: #D9CCBC; /* Beige 라인 */
  /* 텍스트는 요구사항대로 #888888 유지( --text-base ) */
}
```

---

## 2) 6패널 공통 레이아웃(3×2, 동일 크기)

> KPI 카드가 있더라도 **6개 공통 패널 중 하나로** 취급하고, `grid-column: 1/-1`와 같은 span은 쓰지 않습니다.

```css
/* 대시보드 3열 2행(반응형은 필요 시 media-query로) */
.dashboard-grid{
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--sp-8);
  align-items: stretch;
}

/* 6개 패널 공통 카드 */
.card{
  display: flex;
  flex-direction: column;
  min-height: var(--panel-h);      /* ✅ 모두 동일 높이 */
  background: var(--surface-2);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-6);
  box-shadow: var(--shadow-1);
  color: var(--text-base);
}
.card:hover{ border-color: var(--hover-cyan); }

/* 헤더("정확한 중간행": 제목 좌정렬, 우측 넓은 여백) */
.card-header{
  display: grid;
  grid-template-columns: 1fr auto; /* 좌: 타이틀 / 우: 넓은 여백(비움) */
  align-items: center;
  padding: var(--sp-6) var(--sp-6) var(--sp-4);
  border-bottom: 1px solid var(--border-subtle);
}
.card-title{
  font-size: 16px;
  font-weight: 700;
  color: var(--text-strong);
}

/* 본문(아이템3 + 하단 링크) */
.card-content{
  position: relative;
  display: grid;
  grid-template-rows: auto 0;               /* 하단 링크를 중앙에 두기 위한 트릭 */
  padding: var(--sp-6);
  padding-bottom: calc(var(--sp-6) + var(--panel-bottom-gap));
}

/* 아이템 3개 묶음 – 여백 변수 하나로 통제 */
.card-list{
  display: grid;
  row-gap: var(--item-gap);                  /* ✅ 내부 박스 간격 */
}

/* 하단 핫핑크 링크 – 마지막 아이템 하단~패널 하단 사이 정중앙 */
.card-link{
  position: absolute;
  left: 0; right: 0;
  bottom: calc(var(--panel-bottom-gap) / 2);
  display: grid; place-items: center;
}
.card-link a{
  color: var(--brand-pink);
  font-weight: 700;
  text-decoration: none;
}
.card-link a:hover{ color: var(--hover-cyan); }
```

---

## 3) 아이템(내부 박스) 1행의 정밀 스펙

> **삼단 레이아웃 고정**: 아이콘 / 텍스트 / 메타(배지·버튼·시간).
> 아이콘 뒤 원형 배경, 좌측 컬러 바 **없음**(명시적으로 제거).

```css
/* 아이템 박스(내부 박스) */
.sr-item{
  display: grid;
  grid-template-columns: 24px var(--sp-4) 1fr auto; /* 24 아이콘 | 16 간격 | 텍스트 | 메타 */
  align-items: center;
  background: var(--surface-1);
  border: 1px solid var(--border-subtle);
  border-radius: var(--radius-4);
  padding: var(--sp-5) var(--sp-6);          /* 좌우 동일 패딩 → 좌우 균형 */
  min-height: 60px;
  color: var(--text-base);
  box-sizing: border-box;
}

/* (안전장치) 아이콘 뒤 원형/배경 강제 제거 */
.sr-item__avatar{
  width: 24px; height: 24px;
  display: grid; place-items: center;
  color: #888888;                 /* 아이콘 기본선색: 요구 컬러톤 */
  background: transparent !important;
  border-radius: 0 !important;
}

/* 가운데 텍스트(제목/설명) – X점(아이콘 옆 간격)에서 시작 */
.sr-item__title{
  grid-column: 3/4;
  font-size: 14px; font-weight: 600; line-height: 1.4;
  color: var(--text-base);
  margin: 0 0 4px 0;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.sr-item__desc{
  grid-column: 3/4;
  font-size: 14px; line-height: 1.4; color: var(--text-base);
  margin: 0;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}

/* 우측 메타(배지/버튼 + 시간) – 아이콘 옆 간격과 대칭되도록 여백 */
.sr-item__meta{
  grid-column: 4/5;
  display: grid;
  grid-auto-flow: row;
  justify-items: end;
  align-items: center;
  row-gap: 6px;                    /* 배지와 시간 수직 간격 */
  padding-left: var(--sp-4);       /* ✅ 좌 아이콘 옆 간격(var(--sp-4))과 동일값 */
  white-space: nowrap;
}
.sr-item__time{
  font-size: 12px;
  color: var(--text-muted);
  white-space: nowrap;
}

/* 컨텐츠 없음(빈 칸 자리 차지) */
.sr-item--ghost{
  visibility: hidden;               /* 자리 유지 */
  min-height: 60px;
  padding: var(--sp-5) var(--sp-6);
  border: 1px solid transparent;
  border-radius: var(--radius-4);
}
```

---

## 4) 배지 & 버튼 — 유형/형태/컬러 매핑 (완전 통일)

### 4-1. 공통 배지 베이스(아웃라인형)

```css
/* 모든 배지의 공통 모양(아웃라인형) */
.sr-item__badge{
  display: inline-flex;
  align-items: center; justify-content: center;
  height: 18px;                     /* ⬅ 시간 텍스트와 균형 맞춘 초소형 고정높이 */
  padding: 0 8px;
  border-radius: 999px;             /* pill 형태 */
  font-size: 11px; font-weight: 600;
  line-height: 1; letter-spacing: .2px;
  box-sizing: border-box;
  background: transparent;
  border: 1px solid currentColor;   /* 텍스트색 = 라인색 */
  color: currentColor;
}
```

### 4-2. **사용자 배지** (멘션/최근 변경)

* 내용: **EL** 또는 **OT** → **2글자 고정 폭**
* 색상: 사용자별 컬러

  * **EL →** `--user-el` = `#A6FF00`
  * **OT →** `--user-ot` = `#FF835C`

```css
/* 2글자 고정폭(EL/OT 시각 균일) */
.user-badge{ min-width: 28px; text-align: center; }
.badge-el{ color: var(--user-el); }
.badge-ot{ color: var(--user-ot); }
```

### 4-3. **상태/우선순위 배지** (할 일/마감 임박)

* 컬러 매핑(변경 없음)

  * **긴급 / 높음 →** `--danger-fg` = `#FF6B6B`
  * **주의 / 보통 →** `--warn-fg` = `#EBCB4E`
  * **정상 / 낮음 →** `--ok-fg`   = `#17E1BC`

```css
.status-badge{} /* 공통 베이스 그대로 사용 */
.badge-high,.badge-urgent   { color: var(--danger-fg);  }
.badge-medium,.badge-warning{ color: var(--warn-fg);    }
.badge-low,.badge-normal    { color: var(--ok-fg);      }
```

### 4-4. **타입 배지** (오늘 발매 일정)

* 컬러 매핑(변경 없음)

  * **앨범 →** `--tag-album`   = `#EA6DC9`
  * **트랙 →** `--tag-track`   = `#8BB4DF`
  * **마감 →** `--tag-deadline`= `#17E1BC`

```css
.type-badge{} /* 공통 베이스 그대로 사용 */
.badge-album   { color: var(--tag-album); }
.badge-track   { color: var(--tag-track); }
.badge-deadline{ color: var(--tag-deadline); }
```

### 4-5. **재시도 버튼** (실패 태스크 전용)

* 기본: **핫핑크 Solid + 아이보리 텍스트**
* 호버: **시안 배경 + 검정 텍스트** ✅ (요구사항 확정)
* 포커스/액티브/비활성 포함

```css
/* 버튼이지만 배지와 동일한 사이즈/라운드로 통일 */
.sr-item__badge.retry-btn{
  border: none;
  background: var(--brand-pink);
  color: #FEFDF6;
  cursor: pointer;
}
.sr-item__badge.retry-btn:hover{
  background: var(--hover-cyan);  /* ✅ 시안 */
  color: #000000;                 /* ✅ 검정 */
}
.sr-item__badge.retry-btn:focus-visible{
  outline: 2px solid var(--hover-cyan);
  outline-offset: 2px;
}
.sr-item__badge.retry-btn:active{ transform: translateY(1px); }
.sr-item__badge.retry-btn[disabled],
.sr-item__badge.retry-btn[aria-disabled="true"]{
  opacity: .55; cursor: not-allowed;
}
```

---

## 5) 하단 링크(핫핑크) – 중앙 정렬 규칙

> 마지막 아이템 하단선과 패널 하단선 사이 **정확한 중앙**에 오도록 배치.
> 총 여백은 `--panel-bottom-gap`으로 제어(링크는 그 절반 지점에 위치).

```css
.card-link{
  position: absolute;
  left: 0; right: 0;
  bottom: calc(var(--panel-bottom-gap) / 2);
  display: grid; place-items: center;
}
.card-link a{ color: var(--brand-pink); font-weight: 700; text-decoration: none; }
.card-link a:hover{ color: var(--hover-cyan); }
```

---

## 6) 아이콘 규칙(Lucide)

* **아이콘만** 사용(원형 배경, 테두리, 좌측 컬러 바 **모두 제거**)
* 사이즈: `16px`(컴포넌트 속성) , 컨테이너는 `24×24`로 수직 중앙
* 컬러: 기본 `#888888`(상속 또는 `style="color:#888888"`), 상황별로 inline 스타일 사용 가능
  (예: 사용자 컬러를 아이콘에 직접 주고 싶다면 `<History style="color:#A6FF00" ... />`)

---

## 7) 마크업 적용 예시(Svelte) — **클래스만** 추가하면 적용 완료

> 기존 로직/텍스트/색상 함수는 유지. 배지 타입 클래스만 붙입니다.
> ⚠️ "border-left" 같은 컬러 바 스타일은 **삭제**(아이콘만 사용 확정).

### 7-1. 멘션 / 최근 변경 (사용자 배지)

```svelte
<div class="sr-item">
  <div class="sr-item__avatar">
    <MessageSquare size={16} strokeWidth={1.5} />
  </div>

  <p class="sr-item__title">{mention.type}</p>
  <p class="sr-item__desc">{mention.message}</p>

  <div class="sr-item__meta">
    <span class="sr-item__badge user-badge {mention.user==='El' ? 'badge-el':'badge-ot'}">
      {mention.user==='El' ? 'EL' : 'OT'}
    </span>
    <time class="sr-item__time">{mention.time}</time>
  </div>
</div>
```

### 7-2. 할 일 / 마감 임박 (상태/우선순위 배지)

```svelte
<div class="sr-item">
  <div class="sr-item__avatar">
    <CheckSquare size={16} strokeWidth={1.5} />
  </div>

  <p class="sr-item__title">{item.title}</p>
  <p class="sr-item__desc">마감: {item.dueDate || item.deadline}</p>

  <div class="sr-item__meta">
    <span
      class="sr-item__badge status-badge
        {item.priority==='high' ? 'badge-high'  : item.priority==='medium' ? 'badge-medium' : 'badge-low'}
        {item.status==='urgent' ? 'badge-urgent': item.status==='warning' ? 'badge-warning' : 'badge-normal'}">
      {item.priority
        ? (item.priority==='high' ? '높음' : item.priority==='medium' ? '보통' : '낮음')
        : (item.status==='urgent' ? '긴급' : item.status==='warning' ? '주의' : '정상')}
    </span>
    <time class="sr-item__time"></time>
  </div>
</div>
```

### 7-3. 오늘 발매 일정 (타입 배지)

```svelte
<div class="sr-item">
  <div class="sr-item__avatar">
    {#if item.type==='album'}
      <Disc3 size={16} strokeWidth={1.5} />
    {:else if item.type==='track'}
      <Music size={16} strokeWidth={1.5} />
    {:else}
      <FileText size={16} strokeWidth={1.5} />
    {/if}
  </div>

  <p class="sr-item__title">{item.title}</p>
  <p class="sr-item__desc">{item.schedule}</p>

  <div class="sr-item__meta">
    <span class="sr-item__badge type-badge
      {item.type==='album' ? 'badge-album' : item.type==='track' ? 'badge-track' : 'badge-deadline'}">
      {item.type==='album' ? '앨범' : item.type==='track' ? '트랙' : '마감'}
    </span>
    <time class="sr-item__time"></time>
  </div>
</div>
```

### 7-4. 실패 태스크 (재시도 버튼)

```svelte
<div class="sr-item">
  <div class="sr-item__avatar">
    <XCircle size={16} strokeWidth={1.5} />
  </div>

  <p class="sr-item__title">{task.title}</p>
  <p class="sr-item__desc">{task.error}</p>

  <div class="sr-item__meta">
    <button class="sr-item__badge retry-btn">재시도</button>
    <time class="sr-item__time">{task.time}</time>
  </div>
</div>
```

### 7-5. 컨텐츠가 3개보다 적을 때(빈 자리 유지)

```svelte
{#each take3(items) as it}
  {#if it}
    <!-- 위의 sr-item 패턴 -->
  {:else}
    <div class="sr-item sr-item--ghost" aria-hidden="true"></div>
  {/if}
{/each}
```

---

## 8) "패널 한 개"의 구조도(텍스트 버전)

* **외부 박스(패널)**

  * 높이: `--panel-h`(모든 패널 동일)
  * 패딩: 상/좌/우/하 = `var(--sp-6)`, 하단은 `--panel-bottom-gap` 보정 포함
  * 헤더(제목 좌정렬, 우측 넓은 여백): `.card-header`
  * 본문: `.card-content`(아이템 3개 + 하단 링크)

* **내부 박스(아이템) × 3**

  * 각 아이템: `.sr-item`(최소 높이 60px, 좌우 패딩 동일)
  * 1행 레이아웃: `24px 아이콘 | 16px 간격 | 1fr 텍스트 | auto 메타`
  * 좌측 아이콘과 메타 영역 사이의 **시각 균형**: `.sr-item__meta{ padding-left: var(--sp-4); }`
  * 아이템 간 수직 간격: `--item-gap`(12px 기본)

* **하단 링크(핫핑크)**

  * 위치: 마지막 아이템 하단\~패널 하단 사이의 **정중앙**
  * 계산: `.card-link{ bottom: calc(--panel-bottom-gap/2) }`

---

## 9) 접근성 · 인터랙션 체크리스트

* **키보드 포커스**: 재시도 버튼 `:focus-visible`에서 2px 시안 아웃라인
* **호버**: 재시도 버튼은 **시안 배경 + 검정 텍스트**, 링크는 핑크→시안
* **대비**: 다크에서 핑크/시안 대비 충분, 라이트는 배경이 밝아도 선명하게 보이도록 동일 색 유지
* **텍스트 오버플로우**: 제목/설명은 `ellipsis`로 단일 행 처리
* **배지/시간 높이 균형**: 배지 고정높이 18px → 시간(12px)과 라인 높이 균형
* **아이콘만**: 원형 아바타/좌측 라인 **금지**(코드에서 강제 제거)

---

## 10) 자주 바꿀 3곳(운영 편의)

```css
:root{
  --item-gap: 12px;         /* 아이템 3개 사이 간격만 키우고 싶을 때 */
  --panel-h: 540px;         /* 6패널 동일 높이(간격 늘려 넘치면 함께 증가) */
  --panel-bottom-gap: 56px; /* 마지막 아이템~패널 하단 총 여백(링크는 그 절반 지점) */
}
```

---

## ✅ 이 문서 그대로 적용하면:

* **버튼/배지의 모양·컬러·상태 규칙이 완전히 일관화**되고,
* **아이콘만** 쓰는 현재 구조와 6패널 동일 사이즈,
* **라이트/다크** 테마,
* **링크 중앙 정렬/아이템 간격/텍스트 오버플로우/접근성**까지
  **단 하나도 빠짐없이** 충족됩니다.

---

**문서 버전**: v1.0  
**최종 업데이트**: 2025-08-19  
**작성자**: Sugar Rush Development Team  
**검토 상태**: 최종 승인 완료
