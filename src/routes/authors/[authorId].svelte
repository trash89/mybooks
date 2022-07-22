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

  onMount(async () => {
    await getAuthor(authorId);
  });
</script>

<h1>edit author</h1>
<form>
  <div class="mb-3 mt-3">
    <label for="firstName">First Name :</label>
    <input type="text" class="form-control" bind:value={firstName} />
  </div>
  <div class="mb-3 mt-3">
    <label for="lastName">Last Name :</label>
    <input type="text" class="form-control" bind:value={lastName} />
  </div>
  <button type="button" class="btn btn-primary" on:click={handleCancel}><i class="fa-solid fa-times" /></button>
  <button type="button" class="btn btn-primary" on:click={handleDelete}><i class="fa fa-trash" /></button>
  <button type="button" class="btn btn-primary" on:click={handleSave} disabled={!firstName || !lastName}><i class="fa-solid fa-floppy-disk" /></button>
</form>
