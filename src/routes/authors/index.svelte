<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";

  let authors = [];
  let searchFirstname, searchLastname;
  const getAllAuthors = async (pFirstname, pLastname) => {
    try {
      let query = supabase.from("authors").select("*");
      if (pFirstname) {
        query = query.like("firstName", `%${pFirstname}%`);
      }
      if (pLastname) {
        query = query.like("lastName", `%${pLastname}%`);
      }
      const { data, error } = await query;
      authors = data;
    } catch (err) {
      console.log(err);
    }
  };

  onMount(async () => {
    await getAllAuthors();
  });
  $: getAllAuthors(searchFirstname, searchLastname);
</script>

<h1>authors</h1>
<a href="/authors/newAuthor"><i class="fa-solid fa-plus" /></a>

<table class="table table-bordered table-hover table-responsive-sm">
  <thead>
    <tr>
      <th>Action</th>
      <th>Firstname <input type="text" bind:value={searchFirstname} placeholder="%" /></th>
      <th>Lastname <input type="text" bind:value={searchLastname} placeholder="%" /></th>
    </tr>
  </thead>
  <tbody>
    {#each authors as author (author.id)}
      <tr key={author.id}>
        <td>
          <a href={`/authors/${author.id}`}><i class="fa-solid fa-pen" /></a>
        </td>
        <td>
          {author.firstName}
        </td>
        <td>
          {author.lastName}
        </td>
      </tr>
    {/each}
  </tbody>
</table>
