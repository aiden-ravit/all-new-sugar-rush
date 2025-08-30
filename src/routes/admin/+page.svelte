<script>
	import { onMount } from 'svelte';
	import { Plus, Download, BarChart3, CheckSquare, Clock, XCircle, History, Calendar, Disc3, Music, FileText, MessageSquare } from 'lucide-svelte';
	import Card from '$lib/components/Card.svelte';
	
	// 최근 변경 카드 높이 동기화
	let rcEl;
	let resizeObserver;
	
	// 대시보드 데이터
	const todoItems = [
		{ id: 1, title: '새 앨범 검토', priority: 'high', dueDate: '2024-01-20' },
		{ id: 2, title: '트랙 메타데이터 업데이트', priority: 'medium', dueDate: '2024-01-22' },
		{ id: 3, title: '수익 보고서 작성', priority: 'low', dueDate: '2024-01-25' }
	];
	
	const mentions = [
		{ id: 1, user: 'El', type: '앨범 업로드', message: '새 앨범 업로드 완료', time: '2시간 전' },
		{ id: 2, user: 'Otte', type: '트랙 검증', message: '트랙 검증 요청', time: '4시간 전' },
		{ id: 3, user: 'El', type: '데이터 확인', message: '수익 데이터 확인 필요', time: '6시간 전' }
	];
	
	const deadlineItems = [
		{ id: 1, title: 'Sugar Rush Vol.2 발매', deadline: '2024-01-18', status: 'urgent' },
		{ id: 2, title: '라이센스 갱신', deadline: '2024-01-20', status: 'warning' },
		{ id: 3, title: '분기별 보고서', deadline: '2024-01-25', status: 'normal' }
	];
	
	const failedTasks = [
		{ id: 1, title: '트랙 업로드 실패', error: '파일 형식 오류', time: '1시간 전' },
		{ id: 2, title: '데이터 동기화 실패', error: '네트워크 연결 오류', time: '3시간 전' },
		{ id: 3, title: '백업 실패', error: '저장 공간 부족', time: '5시간 전' }
	];
	
	const recentChanges = [
		{ id: 1, type: '앨범 추가', description: 'Summer Vibes 앨범 등록', user: 'El', time: '30분 전' },
		{ id: 2, type: '트랙 수정', description: 'Midnight Groove 메타데이터 업데이트', user: 'Otte', time: '1시간 전' },
		{ id: 3, type: '사용자 권한', description: '새 관리자 계정 생성', user: 'El', time: '2시간 전' }
	];
	
	const todaySchedule = [
		{ id: 1, title: '앨범 Sweet Dreams', schedule: 'D-1 (내일 발매)', type: 'album' },
		{ id: 2, title: '트랙 Summer Vibes', schedule: '오늘 오후 3시 발매', type: 'track' },
		{ id: 3, title: '증빙 서류 제출 마감', schedule: 'D-2', type: 'deadline' }
	];
	
	const kpiData = {
		revenue: { current: 12500000, previous: 11800000, growth: 5.9 },
		uploadRate: { current: 87, previous: 82, growth: 6.1 },
		linkStatus: { active: 156, inactive: 12, total: 168 }
	};
	
	// 상태별 색상 함수
	function getPriorityColor(priority) {
		switch (priority) {
			case 'high': return 'var(--danger-fg)';
			case 'medium': return 'var(--warn-fg)';
			case 'low': return 'var(--ok-fg)';
			default: return 'var(--text-secondary)';
		}
	}
	
	function getStatusColor(status) {
		switch (status) {
			case 'urgent': return 'var(--danger-fg)';
			case 'warning': return 'var(--warn-fg)';
			case 'normal': return 'var(--ok-fg)';
			default: return 'var(--text-secondary)';
		}
	}
	
	// 사용자별 색상 함수
	function getUserColor(user) {
		switch (user) {
			case 'El': return '#A6FF00'; // El의 색상
			case 'Otte': return '#FF835C'; // Otte의 색상
			default: return 'var(--text-secondary)';
		}
	}
	
	// 리스트를 3칸으로 맞추는 유틸리티
	const take3 = (arr) => {
		const head = arr.slice(0, 3);
		const pad = Array(Math.max(0, 3 - head.length)).fill(null);
		return [...head, ...pad];
	};
	
	// 최근 변경 카드 높이 동기화
	onMount(() => {
		if (rcEl) {
			resizeObserver = new ResizeObserver((entries) => {
				for (const entry of entries) {
					const height = entry.contentRect.height;
					document.documentElement.style.setProperty('--rc-h', height + 'px');
				}
			});
			resizeObserver.observe(rcEl);
		}
		
		return () => {
			if (resizeObserver) {
				resizeObserver.disconnect();
			}
		};
	});
</script>

<div class="dashboard">
	<section class="py-8">
		<!-- 페이지 헤더 -->
		<div class="page-header">
			<div>
				<h1 class="page-title">대시보드</h1>
				<p class="page-subtitle">Sugar Rush 관리 시스템 현황</p>
			</div>
			<div class="header-actions">
				<button class="btn btn-primary">
					<span class="btn-icon">
						<Plus size={16} strokeWidth={1.5} />
					</span>
					새 앨범 등록
				</button>
				<button class="btn btn-ghost">
					<span class="btn-icon">
						<Download size={16} strokeWidth={1.5} />
					</span>
					보고서 다운로드
				</button>
			</div>
		</div>

		<!-- 카드 그리드 -->
		<div class="dashboard-grid min-w-0">
			<!-- 할 일 카드 -->
			<Card title="할 일" link={{ url: "/admin/calendar", label: "모든 할 일 보기" }}>
				{#each take3(todoItems) as item}
					{#if item}
						<div class="sr-item">
							<div class="sr-item__avatar">
								<CheckSquare size={16} strokeWidth={1.5} />
							</div>
							<p class="sr-item__title">{item.title}</p>
							<p class="sr-item__desc">마감: {item.dueDate}</p>
							<div class="sr-item__meta">
								<span class="sr-item__badge" style="color: {getPriorityColor(item.priority)};">
									{item.priority === 'high' ? '높음' : item.priority === 'medium' ? '보통' : '낮음'}
								</span>
								<time class="sr-item__time"></time>
							</div>
						</div>
					{:else}
						<div class="sr-item sr-item--ghost" aria-hidden="true"></div>
					{/if}
				{/each}
			</Card>

			<!-- 멘션 카드 -->
			<Card title="멘션" link={{ url: "/admin/feedback", label: "모든 멘션 보기" }}>
				{#each take3(mentions) as mention}
					{#if mention}
						<div class="sr-item" style="border-left: 3px solid {getUserColor(mention.user)};">
							<div class="sr-item__avatar">
								<MessageSquare size={16} strokeWidth={1.5} />
							</div>
							<p class="sr-item__title">{mention.type}</p>
							<p class="sr-item__desc">{mention.message}</p>
							<div class="sr-item__meta">
								<span class="sr-item__badge" style="color: {getUserColor(mention.user)};">
									{mention.user === 'El' ? 'EL' : 'OT'}
								</span>
								<time class="sr-item__time">{mention.time}</time>
							</div>
						</div>
					{:else}
						<div class="sr-item sr-item--ghost" aria-hidden="true"></div>
					{/if}
				{/each}
			</Card>

			<!-- 마감 임박 -->
			<Card title="마감 임박" link={{ url: "/admin/calendar", label: "일정 관리" }}>
				{#each take3(deadlineItems) as item}
					{#if item}
						<div class="sr-item">
							<div class="sr-item__avatar">
								<Clock size={16} strokeWidth={1.5} />
							</div>
							<p class="sr-item__title">{item.title}</p>
							<p class="sr-item__desc">마감: {item.deadline}</p>
							<div class="sr-item__meta">
								<span class="sr-item__badge" style="color: {getStatusColor(item.status)};">
									{item.status === 'urgent' ? '긴급' : item.status === 'warning' ? '주의' : '정상'}
								</span>
								<time class="sr-item__time"></time>
							</div>
						</div>
					{:else}
						<div class="sr-item sr-item--ghost" aria-hidden="true"></div>
					{/if}
				{/each}
			</Card>

			<!-- 실패 태스크 -->
			<Card title="실패 태스크" link={{ url: "/admin/feedback", label: "모든 오류 보기" }}>
				{#each take3(failedTasks) as task}
					{#if task}
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
					{:else}
						<div class="sr-item sr-item--ghost" aria-hidden="true"></div>
					{/if}
				{/each}
			</Card>

			<!-- 최근 변경 -->
			<div id="panel-recent" bind:this={rcEl}>
				<Card title="최근 변경" link={{ url: "/admin/feedback", label: "변경 이력 보기" }}>
					{#each take3(recentChanges) as change}
						{#if change}
							<div class="sr-item" style="border-left: 3px solid {getUserColor(change.user)};">
								<div class="sr-item__avatar">
									<History size={16} strokeWidth={1.5} />
								</div>
								<p class="sr-item__title">{change.type}</p>
								<p class="sr-item__desc">{change.description}</p>
								<div class="sr-item__meta">
									<span class="sr-item__badge" style="color: {getUserColor(change.user)};">
										{change.user === 'El' ? 'EL' : 'OT'}
									</span>
									<time class="sr-item__time">{change.time}</time>
								</div>
							</div>
						{:else}
							<div class="sr-item sr-item--ghost" aria-hidden="true"></div>
						{/if}
					{/each}
				</Card>
			</div>

			<!-- 오늘 발매 일정 -->
			<Card title="오늘 발매 일정" link={{ url: "/admin/calendar", label: "일정 관리" }}>
				{#each take3(todaySchedule) as item}
					{#if item}
						<div class="sr-item">
							<div class="sr-item__avatar">
								{#if item.type === 'album'}
									<Disc3 size={16} strokeWidth={1.5} />
								{:else if item.type === 'track'}
									<Music size={16} strokeWidth={1.5} />
								{:else}
									<FileText size={16} strokeWidth={1.5} />
								{/if}
							</div>
							<p class="sr-item__title">{item.title}</p>
							<p class="sr-item__desc">{item.schedule}</p>
							<div class="sr-item__meta">
								<span class="sr-item__badge" style="
									color: {
										item.type === 'album' ? '#EA6DC9' : 
										item.type === 'track' ? '#8BB4DF' : 
										'#17E1BC'
									};
								">
									{item.type === 'album' ? '앨범' : item.type === 'track' ? '트랙' : '마감'}
								</span>
								<time class="sr-item__time"></time>
							</div>
						</div>
					{:else}
						<div class="sr-item sr-item--ghost" aria-hidden="true"></div>
					{/if}
				{/each}
			</Card>

			<!-- KPI 요약 그래프 (수익, 업로드율, 링크상태) -->
			<div class="card kpi-card">
				<div class="card-header">
					<h3 class="card-title">KPI 요약 그래프 (수익, 업로드율, 링크상태)</h3>
				</div>
				<div class="card-content">
					<div class="kpi-grid">
						<!-- 수익 KPI -->
						<div class="kpi-item">
							<div class="kpi-value">{(kpiData.revenue.current / 1000000).toFixed(1)}M</div>
							<p class="kpi-label">월 수익</p>
							<div class="kpi-growth">
								<span class="growth-text" style="color: {kpiData.revenue.growth >= 0 ? 'var(--ok-fg)' : 'var(--danger-fg)'}">
									{kpiData.revenue.growth >= 0 ? '+' : ''}{kpiData.revenue.growth}%
								</span>
								<span class="growth-icon" style="color: {kpiData.revenue.growth >= 0 ? 'var(--ok-fg)' : 'var(--danger-fg)'}">
									{kpiData.revenue.growth >= 0 ? '↗' : '↘'}
								</span>
							</div>
						</div>

						<!-- 업로드율 KPI -->
						<div class="kpi-item">
							<div class="kpi-value">{kpiData.uploadRate.current}%</div>
							<p class="kpi-label">업로드율</p>
							<div class="kpi-growth">
								<span class="growth-text" style="color: {kpiData.uploadRate.growth >= 0 ? 'var(--ok-fg)' : 'var(--danger-fg)'}">
									{kpiData.uploadRate.growth >= 0 ? '+' : ''}{kpiData.uploadRate.growth}%
								</span>
								<span class="growth-icon" style="color: {kpiData.uploadRate.growth >= 0 ? 'var(--ok-fg)' : 'var(--danger-fg)'}">
									{kpiData.uploadRate.growth >= 0 ? '↗' : '↘'}
								</span>
							</div>
						</div>

						<!-- 링크상태 KPI -->
						<div class="kpi-item">
							<div class="kpi-value">{kpiData.linkStatus.active}</div>
							<p class="kpi-label">활성 링크</p>
							<div class="kpi-total">
								총 {kpiData.linkStatus.total}개 중
							</div>
						</div>
					</div>

					<!-- 간단한 차트 영역 (플레이스홀더) -->
					<div class="chart-placeholder">
						<div class="chart-icon">
							<BarChart3 size={48} strokeWidth={1.5} />
						</div>
						<p class="chart-title">차트 영역</p>
						<p class="chart-description">수익, 업로드율, 링크상태의 시계열 데이터가 여기에 표시됩니다</p>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<style>
	/* 대시보드 스타일 */
	.dashboard {
		width: 100%;
	}
	
	/* 페이지 헤더 */
	.page-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 32px;
	}
	
	.page-title {
		font-size: 24px;
		font-weight: 700;
		color: #888888;
		line-height: 1.3;
		margin-bottom: 8px;
	}
	
	.page-subtitle {
		font-size: 14px;
		color: #888888;
		line-height: 1.4;
	}
	
	.header-actions {
		display: flex;
		gap: 16px;
	}
	
	/* 버튼 스타일 */
	.btn {
		display: flex;
		align-items: center;
		gap: 8px;
		border-radius: 10px;
		padding: 12px 16px;
		height: 40px;
		cursor: pointer;
		border: none;
		font-weight: 600;
		font-size: 14px;
		transition: all 0.2s ease;
	}
	
	.btn-icon {
		font-size: 16px;
	}
	
	.btn-primary {
		background: var(--brand-pink);
		color: #FEFDF6;
	}
	
	.btn-primary:hover {
		background: var(--hover-cyan);
		color: #000000;
	}
	
	.btn-ghost {
		background: transparent;
		color: #666666;
		border: 1px solid var(--border-subtle);
	}
	
	.btn-ghost:hover {
		color: var(--hover-cyan);
		border-color: var(--hover-cyan);
	}
	
	/* 카드 스타일 */
	.card {
		background: var(--surface-2);
		border: 1px solid var(--border-subtle);
		border-radius: 12px;
		transition: all 0.2s ease;
		display: flex;
		flex-direction: column;
	}
	
	.card:hover {
		border-color: var(--hover-cyan);
	}
	
	.card-header {
		padding: 20px 24px 16px;
		border-bottom: 1px solid var(--border-subtle);
	}
	
	.card-title {
		font-size: 16px;
		font-weight: 600;
		color: #888888;
		line-height: 1.4;
	}
	
	.card-content {
		padding: 20px 24px;
	}
	
	/* 리스트 공통 스타일 */
	.task-list, .mention-list, .deadline-list, .failed-list, .change-list, .schedule-list {
		display: flex;
		flex-direction: column;
		gap: 12px;
		margin-bottom: 20px;
	}
	
	.priority-chip, .status-chip {
		font-size: 11px;
		font-weight: 600;
		padding: 4px 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.1);
	}
	
	/* 멘션 스타일 */
	.mention-item {
		display: flex;
		align-items: flex-start;
		gap: 12px;
		padding: 12px;
		background: var(--surface-1);
		border: 1px solid var(--border-subtle);
		border-radius: 8px;
	}
	
	.mention-avatar {
		width: 32px;
		height: 32px;
		border-radius: 50%;
		background: var(--brand-pink);
		color: #666666;
		display: flex;
		align-items: center;
		justify-content: center;
		font-weight: 600;
		font-size: 14px;
		flex-shrink: 0;
	}
	
	.mention-content {
		flex: 1;
	}
	
	.mention-user {
		font-size: 14px;
		font-weight: 600;
		color: var(--text-primary);
		margin-bottom: 4px;
	}
	
	.mention-message {
		font-size: 14px;
		color: #888888;
		margin-bottom: 4px;
		line-height: 1.4;
	}
	
	.mention-time {
		font-size: 12px;
		color: #888888;
	}
	
	/* 재시도 버튼 스타일 - 크기 유지 */
	.sr-item__badge.retry-btn {
		background: var(--brand-pink) !important;
		color: #FEFDF6 !important;
		border: none;
		cursor: pointer;
		transition: all 0.2s ease;
		padding: 2px 4px !important;
		border-radius: 4px;
		font-size: 11px;
		font-weight: 600;
		min-width: auto !important;
		max-width: none !important;
		width: fit-content !important;
		height: 18px !important;
		display: inline-flex !important;
		align-items: center;
		justify-content: center;
		box-sizing: border-box;
		line-height: 1px;
	}
	
	.sr-item__badge.retry-btn:hover {
		background: var(--hover-cyan) !important;
		color: #000000 !important;
	}
	
	/* 최근 변경 스타일 */
	.change-item {
		display: flex;
		align-items: flex-start;
		gap: 12px;
		padding: 12px;
		background: var(--surface-1);
		border: 1px solid var(--border-subtle);
		border-radius: 8px;
		min-height: 60px;
	}
	
	.change-avatar {
		width: 32px;
		height: 32px;
		border-radius: 50%;
		background: var(--warn-fg);
		color: #666666;
		display: flex;
		align-items: center;
		justify-content: center;
		font-weight: 600;
		font-size: 14px;
		flex-shrink: 0;
	}
	
	.change-content {
		flex: 1;
	}
	
	.change-type {
		font-size: 14px;
		font-weight: 600;
		color: #888888;
		margin-bottom: 4px;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		max-width: 200px;
	}
	
	.change-description {
		font-size: 14px;
		color: #888888;
		margin-bottom: 8px;
		line-height: 1.4;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		max-width: 200px;
	}
	
	.change-meta {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	
	.change-user, .change-time {
		font-size: 12px;
		color: #888888;
	}
	
	/* KPI 스타일 */
	.kpi-card {
		grid-column: 1 / -1;
	}
	
	.kpi-grid {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 24px;
		margin-bottom: 24px;
	}
	
	.kpi-item {
		text-align: center;
		padding: 20px;
		background: var(--surface-1);
		border: 1px solid var(--border-subtle);
		border-radius: 8px;
	}
	
	.kpi-value {
		font-size: 28px;
		font-weight: 700;
		color: var(--brand-pink);
		margin-bottom: 8px;
		line-height: 1.3;
	}
	
	.kpi-label {
		font-size: 14px;
		color: #888888;
		margin-bottom: 12px;
	}
	
	.kpi-growth {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 4px;
	}
	
	.growth-text {
		font-size: 14px;
		font-weight: 600;
	}
	
	.growth-icon {
		font-size: 16px;
		font-weight: 700;
	}
	
	.kpi-total {
		font-size: 14px;
		color: #888888;
	}
	
	/* 차트 플레이스홀더 */
	.chart-placeholder {
		text-align: center;
		padding: 40px;
		background: var(--surface-1);
		border: 1px solid var(--border-subtle);
		border-radius: 8px;
		border-style: dashed;
	}
	
	.chart-icon {
		display: flex;
		justify-content: center;
		align-items: center;
		margin-bottom: 16px;
		color: var(--brand-pink);
	}
	
	.chart-title {
		font-size: 18px;
		font-weight: 600;
		color: #888888;
		margin-bottom: 8px;
	}
	
	.chart-description {
		font-size: 14px;
		color: #888888;
		line-height: 1.4;
	}
	
	/* 스케줄 타입 칩 스타일 */
	.schedule-type-chip {
		font-size: 11px;
		font-weight: 600;
		padding: 4px 8px;
		border-radius: 12px;
		white-space: nowrap;
		text-align: center;
		min-width: 40px;
		background: var(--surface-2);
		border: 1px solid currentColor;
	}
	
	/* 링크 스타일 */
	.card-link {
		text-align: center;
		margin-top: auto;
	}
	
	.card-link a {
		color: var(--brand-pink);
		text-decoration: none;
		font-size: 14px;
		font-weight: 600;
		transition: all 0.2s ease;
	}
	
	.card-link a:hover {
		color: var(--hover-cyan);
	}
	
	/* 반응형 */
	@media (max-width: 1200px) {
		.kpi-grid {
			grid-template-columns: repeat(2, 1fr);
		}
	}
	
	@media (max-width: 768px) {
		.page-header {
			flex-direction: column;
			align-items: flex-start;
			gap: 16px;
		}
		
		.header-actions {
			width: 100%;
			justify-content: stretch;
		}
		
		.btn {
			flex: 1;
		}
		
		.kpi-grid {
			grid-template-columns: 1fr;
		}
	}
</style>
