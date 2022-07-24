<script>
  import { goto } from "$app/navigation";
  //import globalStore from "../lib/globalStore";
  import { user } from "$lib/sessionStore";
  import { supabase } from "$lib/supabaseClient";
  import logo from "$lib/assets/logo-192x192.png";
  import { onMount } from "svelte";

  let email = "",
    password = "";
  let isMember = true;
  let err;

  //add alert
  $: isEmpty = !email || !password;
  //|| $globalStore.alert;
  //toggle member
  function toggleMember() {
    isMember = !isMember;
  }
  // handle submit
  async function handleSubmit() {
    // add alert
    //globalStore.toggleItem("alert", true, "loading data...please wait!");
    if (isMember) {
      const { user: existingUser, error } = await supabase.auth.signIn({ email, password });
      if (error) {
        err = error;
        console.log(err);
        //throw error;
      }
      user.set(existingUser);
    } else {
      const { user: createdUser, error } = await supabase.auth.signUp({ email, password });
      if (error) {
        err = error;
        //throw error
      }
      user.set(createdUser);
    }
    if ($user) {
      //globalStore.toggleItem("alert", true, "welcome to shopping madness my friend!");
      goto("/books");
      //globalStore.toggleItem("alert", false);
      // add alert
      return;
    }
    //globalStore.toggleItem("alert", true, "there was an error! please try again", true);
    // add alert
  }
  let ref;
  onMount(() => {
    ref.focus();
  });
</script>

<svelte:head>
  <title>My Books Authentication</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <div class="d-flex justify-content-left align-items-center">
    <img src={logo} alt="MyBooks" width="100px" height="100px" />
    <p class="h1 text-capitalize">My Books</p>
  </div>

  <p class="h2 text-center text-capitalize">
    {#if isMember}sign in{:else}register{/if}
  </p>
  <form on:submit|preventDefault={handleSubmit}>
    <!--single input-->
    <div class="mb-3 mt-3">
      <label for="email" class="form-label">Email:</label>
      <input type="email" class="form-control" id="email" bind:value={email} bind:this={ref} />
    </div>
    <!--end of single input-->
    <!--single input-->
    <div class="mb-3 mt-3">
      <label for="password" class="form-label">Password:</label>
      <input type="password" class="form-control" id="password" bind:value={password} />
    </div>
    {#if isEmpty}
      <div class="alert alert-warning text-capitalize">please fill out all form fields</div>
    {/if}
    <div class="d-flex justify-content-center">
      <button type="submit" class="btn btn-primary text-capitalize" disabled={isEmpty} class:disabled={isEmpty}>
        {#if isMember}
          login
        {:else}
          register
        {/if}
      </button>
    </div>
    <div class="text-center text-capitalize">
      {#if isMember}
        need to register?
      {:else}
        already a member?
      {/if}
      <button type="button" class="btn btn-link text-capitalize" on:click={toggleMember}>click here</button>
    </div>
    {#if err}
      <div class="alert alert-danger">{err?.message}</div>
    {/if}
  </form>
</section>
