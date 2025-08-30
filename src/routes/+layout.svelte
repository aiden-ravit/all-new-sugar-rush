<script lang="ts">
	import '../app.css';
	
	let { children } = $props();
</script>

<svelte:head>
	<title>All New Sugar Rush</title>
</svelte:head>

{@render children?.()}
