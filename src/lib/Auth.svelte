<script>
	import { supabase } from "$lib/supabaseClient";

	let loading = false;
	let email;
	let password;

	const handleLogin = async () => {
		try {
			loading = true;
			const { user, session, error } = await supabase.auth.signUp({ email, password });
			if (error) throw error;
			console.log(user, session);
		} catch (error) {
			alert(error.error_description || error.message);
		} finally {
			loading = false;
		}
	};
</script>

<form class="row flex flex-center" on:submit|preventDefault={handleLogin}>
	<div class="col-6 form-widget">
		<h1 class="header">My Books</h1>
		<div>
			<input class="inputField" type="email" placeholder="Your email" bind:value={email} />
			<input class="inputField" type="password" placeholder="Your password" bind:value={password} />
		</div>
		<div>
			<input
				type="submit"
				class="button block"
				value={loading ? "Loading" : "SignIn"}
				disabled={loading}
			/>
		</div>
	</div>
</form>
