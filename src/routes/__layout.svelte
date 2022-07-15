<script context="module">
	export const prerender = true;
	import Header from "$lib/Header.svelte";
	import Footer from "$lib/Footer.svelte";
</script>

<Header />
<slot />
<Footer />
