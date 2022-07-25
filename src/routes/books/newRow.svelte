<script>
  import { user } from "$lib/sessionStore";
  import { supabase } from "$lib/supabaseClient";
  import { goto } from "$app/navigation";
  import { onMount } from "svelte";
  let name = "",
    langue = "",
    comment = "",
    author_id = null,
    coll_id = null;
  let isError = false;
  let errorText = "";
  const route = "/books";
  let authorsData = [],
    collectionsData = [];
  const getAllAuthors = async () => {
    const { data, error } = await supabase.from("authors").select("*").order("lastName", { ascending: true }).order("firstName", { ascending: true });
    if (!error && data.length > 0) {
      authorsData = data;
    }
  };
  const getAllCollections = async () => {
    const { data, error } = await supabase.from("collections").select("*").order("name", { ascending: true });
    if (!error && data.length > 0) {
      collectionsData = data;
    }
  };

  const handleCancel = () => {
    name = langue = "";
    author_id = coll_id = 0;
    isError = false;
    errorText = "";
    goto(route);
  };
  const handleSave = async () => {
    isError = false;
    errorText = "";
    const { error } = await supabase.from("books").insert([
      {
        author_id: author_id,
        name: name.toLocaleLowerCase(),
        langue: langue.toLocaleLowerCase(),
        comment: comment.toLocaleLowerCase(),
        coll_id: coll_id,
        user_id: $user.id,
      },
    ]);
    if (!error) {
      goto(route);
    } else {
      isError = true;
      errorText = error.message;
    }
  };
  $: if (name || langue || author_id || coll_id) {
    isError = false;
    errorText = "";
  }
  let ref;
  onMount(async () => {
    await getAllAuthors();
    await getAllCollections();
    ref.focus();
  });
</script>

<svelte:head>
  <title>Enter a New Book</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">enter a new book</p>
  <form>
    <div class="mb-3 mt-3">
      <label for="author_id" class="form-label">Author :</label>
      <select bind:value={author_id} id="author_id" name="author_id" required>
        {#each authorsData as data (data.id)}
          <option value={data.id}>{data.lastName},{data.firstName} </option>
        {/each}
      </select>
    </div>
    <div class="mb-3 mt-3">
      <label for="name" class="form-label">Book Name :</label>
      <input type="text" class="form-control" bind:value={name} bind:this={ref} />
    </div>
    <div class="mb-3 mt-3">
      <label for="langue" class="form-label">Langue :</label>
      <input type="text" class="form-control" bind:value={langue} />
    </div>
    <div class="mb-3 mt-3">
      <label for="comment" class="form-label">Comment :</label>
      <textarea class="form-control" bind:value={comment} />
    </div>
    <div class="mb-3 mt-3">
      <label for="coll_id" class="form-label">Collection :</label>
      <select bind:value={coll_id} id="coll_id" name="coll_id">
        <option value="-1" selected />
        {#each collectionsData as data (data.id)}
          <option value={data.id}>{data.name}</option>
        {/each}
      </select>
    </div>

    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Cancel" on:click={handleCancel}><i class="fa-solid fa-times" /></button>
    <button
      type="button"
      class="btn btn-primary"
      data-bs-toggle="tooltip"
      title="Save"
      on:click={handleSave}
      disabled={!name || !langue || !author_id || isError}><i class="fa-solid fa-floppy-disk" /></button
    >
    {#if isError}
      <div class="alert alert-warning">
        <strong>Error:</strong>{errorText}
      </div>
    {/if}
  </form>
</section>
