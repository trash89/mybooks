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
    lastName = "";
  const getRow = async (pParamId) => {
    const { data, error } = await supabase.from("v_books_comments").select("*").eq("id", pParamId);
    if (!error) {
      if (data.length > 0) {
        firstName = data[0].firstName;
        lastName = data[0].lastName;
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
    firstName = lastName = errorText = "";
    isError = false;
    goto(route);
  };

  const handleSave = async () => {
    const { error } = await supabase
      .from("authors")
      .update({ firstName: firstName.toLocaleLowerCase(), lastName: lastName.toLocaleLowerCase() })
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
    const { error } = await supabase.from("authors").delete().match({ id: paramIdNum });
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
  $: if (firstName || lastName) {
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
      <label for="firstName" class="form-label">First Name :</label>
      <input type="text" class="form-control" bind:value={firstName} bind:this={ref} />
    </div>
    <div class="mb-3 mt-3">
      <label for="lastName" class="form-label">Last Name :</label>
      <input type="text" class="form-control" bind:value={lastName} />
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
