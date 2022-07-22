<script>
  import { user } from "$lib/sessionStore";
  import { supabase } from "$lib/supabaseClient";
  import { goto } from "$app/navigation";
  let firstName, lastName, user_id;
  const handleCancel = () => {
    firstName = lastName = "";
    goto("/authors");
  };
  const handleSave = async () => {
    const { data, error } = await supabase.from("authors").insert([{ firstName: firstName, lastName: lastName, user_id: $user.id }]);
    if (!error) {
      goto("/authors");
    } else {
    }
  };
</script>

<h1>new author</h1>
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
  <button type="button" class="btn btn-primary" on:click={handleSave} disabled={!firstName || !lastName}><i class="fa-solid fa-floppy-disk" /></button>
</form>
