<script context="module">
	export const prerender = true;
	import { user } from "$lib/sessionStore";
	import { supabase } from "$lib/supabaseClient";

	import { goto } from "$app/navigation";
	const handleLogout = async () => {
		const { error } = await supabase.auth.signOut();
		if (!error) {
			goto("/");
		}
	};
</script>

<nav>
	<a href="/">Home</a>
	<a href="/collections">Collections</a>
	<a href="/authors">Authors</a>
	<a href="/books">Books</a>
	<a href="/whishlist">Whishlist</a>
	{#if $user}
		<a href="/logout" on:click={handleLogout}>Logout</a>
	{/if}
</nav>
