<script>
  import { user } from "$lib/sessionStore";
  import { supabase } from "$lib/supabaseClient";
  import { goto } from "$app/navigation";
  import { onMount } from "svelte";
  let name = "";
  let isError = false;
  let errorText = "";
  const route = "/collections";
  const handleCancel = () => {
    name = "";
    isError = false;
    errorText = "";
    goto(route);
  };

  const handleSave = async () => {
    isError = false;
    errorText = "";
    const { error } = await supabase.from("collections").insert([{ name: name.toLocaleLowerCase(), user_id: $user.id }]);
    if (!error) {
      goto(route);
    } else {
      isError = true;
      errorText = error.message;
    }
  };
  $: if (name) {
    isError = false;
    errorText = "";
  }
  let ref;
  onMount(() => {
    ref.focus();
  });
</script>

<svelte:head>
  <title>Enter a New Collection</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">enter a new collection</p>
  <form>
    <div class="mb-3 mt-3">
      <label for="name" class="form-label">Name :</label>
      <input type="text" class="form-control" bind:value={name} bind:this={ref} />
    </div>
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Cancel" on:click={handleCancel}><i class="fa-solid fa-times" /></button>
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Save" on:click={handleSave} disabled={!name || isError}
      ><i class="fa-solid fa-floppy-disk" /></button
    >
    {#if isError}
      <div class="alert alert-warning">
        <strong>Error:</strong>{errorText}
      </div>
    {/if}
  </form>
</section>
