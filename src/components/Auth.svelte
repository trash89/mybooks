<script>
	import { goto } from "$app/navigation";
	import globalStore from "../lib/globalStore";
	import { user } from "$lib/sessionStore";
	import { supabase } from "$lib/supabaseClient";

	let email = "";
	let password = "";
	let isMember = true;
	//add alert
	$: isEmpty = !email || !password || $globalStore.alert;
	//toggle member
	function toggleMember() {
		isMember = !isMember;
	}
	// handle submit
	async function handleSubmit() {
		// add alert
		globalStore.toggleItem("alert", true, "loading data...please wait!");
		if (isMember) {
			const {
				user: existingUser,
				session,
				error,
			} = await supabase.auth.signIn({ email, password });
			if (error) throw error;
			user.set(existingUser);
		} else {
			const { user: createdUser, session, error } = await supabase.auth.signUp({ email, password });
			if (error) throw error;
			user.set(createdUser);
		}
		if ($user) {
			globalStore.toggleItem("alert", true, "welcome to shopping madness my friend!");
			goto("/books");
			globalStore.toggleItem("alert", false);
			// add alert
			return;
		}
		globalStore.toggleItem("alert", true, "there was an error! please try again", true);
		// add alert
	}
</script>

<section class="form">
	<h2 class="section-title">
		{#if isMember}sign in{:else}register{/if}
	</h2>
	<form class="login-form" on:submit|preventDefault={handleSubmit}>
		<!--single input-->
		<div class="form-control">
			<label for="email">email</label>
			<input type="email" id="email" bind:value={email} />
		</div>
		<!--end of single input-->
		<!--single input-->
		<div class="form-control">
			<label for="password">password</label>
			<input type="password" id="password" bind:value={password} />
		</div>
		{#if isEmpty}
			<p class="form-empty">please fill out all form fields</p>
		{/if}
		<button
			type="submit"
			class="btn btn-block btn-primary"
			disabled={isEmpty}
			class:disabled={isEmpty}>submit</button
		>
		<p class="register-link">
			{#if isMember}
				need to register
			{:else}
				already a member
			{/if}
			<button type="button" on:click={toggleMember}>click here</button>
		</p>
	</form>
</section>
