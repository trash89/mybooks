<script context="module">
	export const prerender = true;
</script>

<script>
	let year = new Date().getFullYear();
</script>

<footer class="footer">
	© {year} by <a href="https://github.com/trash89/" target="_blank">trash89</a>. All rights
	reserved. Built with
	<a href="https://kit.svelte.dev/" target="_blank">Sveltekit</a>
</footer>

<style>
	.footer {
		position: fixed;
		bottom: 0;
		right: 0;
		width: 100%;
		height: 1.5rem;
		background: black;
		color: white;
		text-align: center;
	}
	.footer a {
		text-decoration: none;
		color: cyan;
	}
</style>
