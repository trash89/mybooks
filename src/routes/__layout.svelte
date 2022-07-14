<script context="module">
	export const prerender = true;
</script>

<script>
	import Header from "$lib/Footer.svelte";
	import Footer from "$lib/Footer.svelte";
</script>

<Header />
<slot />
<Footer />
