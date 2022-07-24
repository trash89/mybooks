<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import { goto } from "$app/navigation";
  import { page } from "$app/stores";

  const { paramId } = $page.params;
  const route = "/collections";
  let isError = false;
  let errorText = "";

  let paramIdNum = 0;
  let name = "";
  const getRow = async (pParamId) => {
    const { data, error } = await supabase.from("collections").select("*").eq("id", pParamId);
    if (!error) {
      if (data.length > 0) {
        name = data[0].name;
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
    name = errorText = "";
    isError = false;
    goto(route);
  };

  const handleSave = async () => {
    const { error } = await supabase.from("collections").update({ name: name.toLocaleLowerCase() }).match({ id: paramIdNum });
    if (!error) {
      goto(route);
      return;
    } else {
      isError = true;
      errorText = error.message;
    }
  };
  const handleDelete = async () => {
    const { error } = await supabase.from("collections").delete().match({ id: paramIdNum });
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
    await getRow(paramIdNum);
    ref.focus();
  });
  $: if (name) {
    isError = false;
    errorText = "";
  }
</script>

<svelte:head>
  <title>Edit a Collection</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">edit a collection</p>
  <form>
    <div class="mb-3 mt-3">
      <label for="name" class="form-label">Name :</label>
      <input type="text" class="form-control" bind:value={name} bind:this={ref} />
    </div>
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Cancel" on:click={handleCancel}><i class="fa-solid fa-times" /></button>
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Delete" on:click={handleDelete} disabled={!name || isError}
      ><i class="fa-solid fa-trash" /></button
    >
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
