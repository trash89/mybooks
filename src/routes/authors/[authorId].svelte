<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import { goto } from "$app/navigation";
  import { page } from "$app/stores";

  const { authorId } = $page.params;
  let firstName = "",
    lastName = "";
  const getAuthor = async (pAuthorId) => {
    try {
      let query = supabase.from("authors").select("*").eq("id", pAuthorId);
      const { data, error } = await query;
      if (!error) {
        if (data.length > 0) {
          firstName = data[0].firstName;
          lastName = data[0].lastName;
        } else {
          console.log("invalid authorId");
        }
      } else {
        console.log(error);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const handleCancel = () => {
    firstName = lastName = "";
    goto("/authors");
  };
  const handleSave = async () => {
    const { data, error } = await supabase.from("authors").update({ firstName: firstName, lastName: lastName }).match({ id: authorId });
    if (!error) {
      goto("/authors");
    } else {
    }
  };
  const handleDelete = async () => {
    const { data, error } = await supabase.from("authors").delete().match({ id: authorId });
    if (!error) {
      goto("/authors");
    } else {
    }
  };
  let ref;
  onMount(async () => {
    await getAuthor(authorId);
    ref.focus();
  });
</script>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">edit an author</p>
  <form>
    <div class="mb-3 mt-3">
      <label for="firstName">First Name :</label>
      <input type="text" class="form-control" bind:value={firstName} bind:this={ref} />
    </div>
    <div class="mb-3 mt-3">
      <label for="lastName">Last Name :</label>
      <input type="text" class="form-control" bind:value={lastName} />
    </div>
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Cancel" on:click={handleCancel}><i class="fa-solid fa-times" /></button>
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Delete" on:click={handleDelete} disabled={!firstName || !lastName}
      ><i class="fa fa-trash" /></button
    >
    <button type="button" class="btn btn-primary" data-bs-toggle="tooltip" title="Save" on:click={handleSave} disabled={!firstName || !lastName}
      ><i class="fa-solid fa-floppy-disk" /></button
    >
  </form>
</section>
