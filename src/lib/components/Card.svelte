<script>
	export let title;
	export let link;
</script>

<div class="card">
	<div class="card-header">
		<h3 class="card-title">{title}</h3>
	</div>
	<div class="card-content">
		<slot />
		{#if link}
			<div class="card-link">
				<a href={link.url}>{link.label} →</a>
			</div>
		{/if}
	</div>
</div>

<style>
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
		margin: 0;
	}
	
	.card-content {
		padding: 20px 24px;
		flex: 1;
		display: flex;
		flex-direction: column;
	}
	
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
</style>
