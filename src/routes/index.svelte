<script>
	export const prerender = true;
	import { user } from "$lib/sessionStore";
	import { supabase } from "$lib/supabaseClient";
	import Auth from "../components/Auth.svelte";
	//	import Auth from "$lib/Auth.svelte";
	//	import Profile from "$lib/Profile.svelte";

	const localUser = supabase.auth.user();
	user.set(localUser);

	supabase.auth.onAuthStateChange((_, session) => {
		user.set(session.user);
	});
</script>

<div>
	{#if !$user}
		<Auth />
	{/if}
</div>
