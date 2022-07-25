<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import { goto } from "$app/navigation";
  import { page } from "$app/stores";

  const { paramId } = $page.params;
  const route = "/books";
  let isError = false;
  let errorText = "";

  let paramIdNum = 0;
  let firstName = "",
    lastName = "",
    name = "",
    langue = "",
    comment = "",
    author_id = null,
    coll_id = null;
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
  const getRow = async (pParamId) => {
    const { data, error } = await supabase.from("v_books").select("*").eq("id", pParamId);
    if (!error) {
      if (data.length > 0) {
        firstName = data[0].firstName;
        lastName = data[0].lastName;
        name = data[0].name;
        author_id = data[0].author_id;
        coll_id = data[0].coll_id;
        langue = data[0].langue;
        comment = data[0].comment;
      } else {
        isError = true;
        errorText = `invalid parameter ${pParamId}`;
      }
    } else {
      isError = true;
      errorText = error.message;
    }
  };
  const handleCancel = () => {
    firstName = lastName = name = langue = comment = errorText = "";
    author_id = coll_id = null;
    isError = false;
    goto(route);
  };

  const handleSave = async () => {
    const { error } = await supabase
      .from("books")
      .update({
        name: name.toLocaleLowerCase(),
        langue: langue.toLocaleLowerCase(),
        author_id: author_id,
        comment: comment.toLocaleLowerCase(),
        coll_id: coll_id,
      })
      .match({ id: paramIdNum });
    if (!error) {
      goto(route);
      return;
    } else {
      isError = true;
      errorText = error.message;
    }
  };
  const handleDelete = async () => {
    const { error } = await supabase.from("books").delete().match({ id: paramIdNum });
    if (!error) {
      goto(route);
      return;
    } else {
      isError = true;
      errorText = error.message;
    }
  };
  let ref;
  onMount(async () => {
    paramIdNum = parseInt(paramId);
    if (isNaN(paramIdNum)) {
      isError = true;
      errorText = `invalid parameter ${paramId}`;
      return;
    }
    await getAllAuthors();
    await getAllCollections();
    await getRow(paramIdNum);
    ref.focus();
  });
  $: if (name || langue || author_id || comment) {
    isError = false;
    errorText = "";
  }
</script>

<svelte:head>
  <title>Edit a Book</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">edit a book</p>
  <form>
    <div class="mb-3 mt-3">
      <label for="author_id" class="form-label">Author :</label>
      <select bind:value={author_id} bind:this={ref} id="author_id" name="author_id" required>
        {#each authorsData as data (data.id)}
          <option value={data.id}>{data.lastName},{data.firstName} </option>
        {/each}
      </select>
    </div>
    <div class="mb-3 mt-3">
      <label for="name" class="form-label">Book Name :</label>
      <input type="text" class="form-control" bind:value={name} required />
    </div>
    <div class="mb-3 mt-3">
      <label for="langue" class="form-label">Langue :</label>
      <input type="text" class="form-control" bind:value={langue} required />
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
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Delete" on:click={handleDelete} disabled={!firstName || !lastName || isError}
      ><i class="fa-solid fa-trash" /></button
    >
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Save" on:click={handleSave} disabled={!firstName || !lastName || isError}
      ><i class="fa-solid fa-floppy-disk" /></button
    >
    {#if isError}
      <div class="alert alert-warning">
        <strong>Error:</strong>{errorText}
      </div>
    {/if}
  </form>
</section>
