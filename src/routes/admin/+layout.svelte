<script>
	import '../../app.css';
	import { 
		Menu, 
		Search, 
		Bell, 
		Eclipse,
		LayoutGrid,
		Disc3,
		Music,
		Upload,
		Users,
		Rocket,
		DollarSign,
		Calendar,
		MessageSquare,
		Shield,
		Settings
	} from 'lucide-svelte';
	
	let currentUser = 'El';
	let currentTheme = 'dark';
	let sidebarOpen = false;
	
	function toggleTheme() {
		currentTheme = currentTheme === 'dark' ? 'light' : 'dark';
		document.documentElement.setAttribute('data-theme', currentTheme);
	}
	
	function toggleSidebar() {
		sidebarOpen = !sidebarOpen;
	}
	
	function switchUser() {
		currentUser = currentUser === 'El' ? 'Otte' : 'El';
	}
</script>

<svelte:head>
	<title>관리자 - Sugar Rush</title>
</svelte:head>

<div class="admin-layout" class:sidebar-open={sidebarOpen}>
	<!-- 사이드바 -->
	<aside class="sidebar">
		<!-- Sugar Rush 로고 -->
		<div class="sidebar-logo">
			<img src="https://data.sugar-rush.team/images/logo-new.svg" alt="Sugar Rush" class="logo-image" />
		</div>
		
		<!-- 네비게이션 메뉴 -->
		<nav class="sidebar-nav">
			<a href="/admin" class="nav-item active">
				<LayoutGrid size={20} />
				<span>대시보드</span>
			</a>
			<a href="/admin/albums" class="nav-item">
				<Disc3 size={20} />
				<span>앨범 관리</span>
			</a>
			<a href="/admin/tracks" class="nav-item">
				<Music size={20} />
				<span>트랙 관리</span>
			</a>
			<a href="/admin/upload" class="nav-item">
				<Upload size={20} />
				<span>업로드·검증 센터</span>
			</a>
			<a href="/admin/collaboration" class="nav-item">
				<Users size={20} />
				<span>제작·협업 보드</span>
			</a>
			<a href="/admin/releases" class="nav-item">
				<Rocket size={20} />
				<span>발매 관리</span>
			</a>
			<a href="/admin/revenue" class="nav-item">
				<DollarSign size={20} />
				<span>수익 관리</span>
			</a>
			<a href="/admin/calendar" class="nav-item">
				<Calendar size={20} />
				<span>일정·캘린더</span>
			</a>
			<a href="/admin/feedback" class="nav-item">
				<MessageSquare size={20} />
				<span>피드백·알림 센터</span>
			</a>
			<a href="/admin/security" class="nav-item">
				<Shield size={20} />
				<span>보안·운영 관리</span>
			</a>
			<a href="/admin/settings" class="nav-item">
				<Settings size={20} />
				<span>설정</span>
			</a>
		</nav>
	</aside>
	
	<!-- 메인 콘텐츠 영역 -->
	<main class="main-content">
		<!-- 상단바 -->
		<header class="top-bar">
			<!-- 왼쪽: 메인 제목 -->
			<div class="top-bar-left">
				<h1 class="main-title">대시보드</h1>
			</div>
			
			<!-- 오른쪽: 검색, 알림, 테마 토글 -->
			<div class="top-bar-right">
				<!-- 검색창 -->
				<div class="search-container">
					<div class="search-box">
						<Search size={16} class="search-icon" />
						<input 
							type="text" 
							placeholder="검색어를 입력하세요" 
							class="search-input"
						/>
					</div>
				</div>
				
				<!-- 알림 버튼 -->
				<button class="top-bar-btn notification-btn">
					<Bell size={20} />
					<div class="notification-dot"></div>
				</button>
				
				<!-- 테마 토글 버튼 -->
				<button class="top-bar-btn theme-btn" on:click={toggleTheme}>
					<Eclipse size={20} />
				</button>
			</div>
		</header>
		
		<!-- 메인 콘텐츠와 우측 사이드바 -->
		<div class="content-wrapper">
			<!-- 페이지 콘텐츠 -->
			<div class="page-content">
				<slot />
			</div>
			
			<!-- 우측 사이드바 -->
			<aside class="right-sidebar">
				<!-- 피드백 섹션 -->
				<div class="sidebar-section">
					<h3 class="sidebar-title">피드백</h3>
					<div class="sidebar-list">
						<div class="sidebar-item">
							<span class="item-text">새로운 앨범 업로드 완료</span>
							<span class="item-time">2분 전</span>
						</div>
						<div class="sidebar-item">
							<span class="item-text">트랙 검증 완료</span>
							<span class="item-time">15분 전</span>
						</div>
					</div>
				</div>
				
				<!-- 최근 활동 섹션 -->
				<div class="sidebar-section">
					<h3 class="sidebar-title">최근 활동</h3>
					<div class="sidebar-list">
						<div class="sidebar-item">
							<span class="item-text">앨범 "Sugar Rush Vol.1" 편집</span>
							<span class="item-time">1시간 전</span>
						</div>
						<div class="sidebar-item">
							<span class="item-text">트랙 "Sweet Dreams" 업로드</span>
							<span class="item-time">3시간 전</span>
						</div>
					</div>
				</div>
				
				<!-- 시스템 로그 섹션 -->
				<div class="sidebar-section">
					<h3 class="sidebar-title">시스템 로그</h3>
					<div class="sidebar-list">
						<div class="sidebar-item">
							<span class="item-text">API 연결 성공</span>
							<span class="item-time">5분 전</span>
						</div>
						<div class="sidebar-item">
							<span class="item-text">데이터베이스 백업 완료</span>
							<span class="item-time">1시간 전</span>
						</div>
					</div>
				</div>
			</aside>
		</div>
	</main>
</div>

<style>
	.admin-layout {
		display: flex;
		height: 100vh;
		background: var(--bg);
		color: var(--text-base);
		font-family: var(--font-base);
	}
	
	/* 사이드바 - 검정 배경, 라인 없음 */
	.sidebar {
		width: 280px;
		background: var(--bg);
		display: flex;
		flex-direction: column;
		flex-shrink: 0;
		position: fixed;
		height: 100vh;
		left: 0;
		top: 0;
		z-index: 100;
	}
	
	/* Sugar Rush 로고 - 새로운 로고, 색상 이미 적용됨 */
	.sidebar-logo {
		padding: 32px 24px 24px;
		text-align: center;
	}
	
	.logo-image {
		height: 32px;
		width: auto;
		max-width: 100%;
	}
	
	/* 네비게이션 */
	.sidebar-nav {
		flex: 1;
		padding: 24px 0;
		overflow-y: auto;
	}
	
	.nav-item {
		display: flex;
		align-items: center;
		gap: 16px;
		padding: 16px 24px;
		color: var(--text-base);
		text-decoration: none;
		transition: all 0.2s ease;
		border-left: 3px solid transparent;
	}
	
	.nav-item:hover {
		background: var(--surface-1);
		color: var(--text-strong);
	}
	
	.nav-item.active {
		background: var(--surface-1);
		color: var(--brand-pink);
		border-left-color: var(--brand-pink);
	}
	
	.nav-item span {
		font-size: 14px;
		font-weight: 500;
	}
	
	/* 메인 콘텐츠 */
	.main-content {
		flex: 1;
		margin-left: 280px;
		display: flex;
		flex-direction: column;
		min-width: 0;
	}
	
	/* 상단바 - 하나의 큰 덩어리, 단차 없음 */
	.top-bar {
		height: 80px;
		background: var(--bg);
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 0 32px;
		position: sticky;
		top: 0;
		z-index: 50;
	}
	
	/* 상단바 왼쪽: 메인 제목 */
	.top-bar-left {
		flex: 1;
		display: flex;
		align-items: center;
	}
	
	.main-title {
		font-size: 20px;
		font-weight: 600;
		color: var(--brand-pink);
		margin: 0;
		font-family: 'Pretendard', sans-serif;
		letter-spacing: -0.3px;
	}
	
	/* 상단바 오른쪽: 검색, 알림, 테마 - 우측 사이드바와 정확히 정렬 */
	.top-bar-right {
		display: flex;
		align-items: center;
		gap: 12px;
		background: var(--surface-2);
		border-left: 1px solid var(--border-subtle);
		padding: 20px;
		height: 100%;
		margin-right: -32px;
		width: 280px;
		justify-content: flex-end;
	}
	
	/* 검색 컨테이너 */
	.search-container {
		position: relative;
	}
	
	.search-box {
		display: flex;
		align-items: center;
		background: var(--surface-1);
		border: 1px solid var(--brand-pink);
		border-radius: 8px;
		padding: 8px 12px;
		width: 160px;
		transition: all 0.2s ease;
	}
	
	.search-box:hover {
		border-color: var(--hover-cyan);
	}
	
	/* 검색 아이콘 - 기본 핫핑크, 호버 시 시안 */
	.search-icon {
		color: var(--brand-pink);
		margin-right: 16px;
		transition: color 0.2s ease;
	}
	
	.search-box:hover .search-icon {
		color: var(--hover-cyan);
	}
	
	.search-input {
		flex: 1;
		background: none;
		border: none;
		color: var(--text-base);
		font-size: 14px;
		outline: none;
		width: 100%;
	}
	
	.search-input::placeholder {
		color: var(--text-muted);
	}
	
	/* 상단바 버튼들 - 첫 번째 이미지와 동일한 크기 */
	.top-bar-btn {
		background: none;
		border: none;
		color: var(--text-base);
		cursor: pointer;
		padding: 6px;
		border-radius: 6px;
		transition: all 0.2s ease;
		position: relative;
		display: flex;
		align-items: center;
		justify-content: center;
	}
	
	.top-bar-btn:hover {
		background: var(--surface-1);
		color: var(--text-strong);
	}
	
	/* 알림 점 - 첫 번째 이미지와 동일한 크기 */
	.notification-dot {
		position: absolute;
		top: 4px;
		right: 4px;
		width: 6px;
		height: 6px;
		background: var(--brand-pink);
		border-radius: 50%;
		opacity: 1;
		transition: opacity 0.2s ease;
	}
	
	.notification-dot.hidden {
		opacity: 0;
	}
	
	/* 콘텐츠 래퍼 */
	.content-wrapper {
		display: flex;
		flex: 1;
		gap: 0;
	}
	
	/* 페이지 콘텐츠 */
	.page-content {
		flex: 1;
		padding: 32px;
		overflow-y: auto;
		min-width: 0;
	}
	
	/* 우측 사이드바 - 상단바 우측과 정확히 정렬 */
	.right-sidebar {
		width: 280px;
		background: var(--surface-2);
		border-left: 1px solid var(--border-subtle);
		padding: 20px;
		overflow-y: auto;
		flex-shrink: 0;
	}
	
	.sidebar-section {
		margin-bottom: 24px;
	}
	
	.sidebar-section:last-child {
		margin-bottom: 0;
	}
	
	.sidebar-title {
		font-size: 14px;
		font-weight: 600;
		color: var(--text-strong);
		margin: 0 0 12px 0;
	}
	
	.sidebar-list {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}
	
	.sidebar-item {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		padding: 10px;
		background: var(--surface-1);
		border-radius: 6px;
		border: 1px solid var(--border-subtle);
	}
	
	.item-text {
		font-size: 13px;
		color: var(--text-base);
		line-height: 1.4;
		flex: 1;
		margin-right: 12px;
	}
	
	.item-time {
		font-size: 11px;
		color: var(--text-muted);
		flex-shrink: 0;
	}
	
	/* 반응형 */
	@media (max-width: 1200px) {
		.sidebar {
			transform: translateX(-100%);
			transition: transform 0.3s ease;
		}
		
		.sidebar-open .sidebar {
			transform: translateX(0);
		}
		
		.main-content {
			margin-left: 0;
		}
		
		.top-bar {
			padding: 0 24px;
		}
		
		.top-bar-right {
			margin-right: -24px;
			width: 260px;
		}
		
		.search-box {
			width: 140px;
		}
		
		.right-sidebar {
			width: 260px;
		}
	}
	
	@media (max-width: 768px) {
		.top-bar {
			padding: 0 16px;
			height: 64px;
		}
		
		.main-title {
			font-size: 18px;
		}
		
		.top-bar-right {
			margin-right: -16px;
			padding: 16px;
			gap: 10px;
			width: auto;
		}
		
		.search-box {
			width: 120px;
		}
		
		.content-wrapper {
			flex-direction: column;
			gap: 0;
		}
		
		.page-content {
			padding: 24px 16px;
		}
		
		.right-sidebar {
			width: 100%;
			border-left: none;
			border-top: 1px solid var(--border-subtle);
			padding: 20px 16px;
		}
	}
</style>
