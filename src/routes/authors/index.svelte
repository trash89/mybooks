<script>
  import { onMount } from "svelte";
  import { user } from "$lib/sessionStore";
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

<table>
  <thead>
    <tr>
      <th>Search</th>
      <th><input bind:value={searchFirstname} /></th>
      <th><input bind:value={searchLastname} /></th>
    </tr>
    <tr>
      <th>Action</th>
      <th>Firstname </th>
      <th>Lastname</th>
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
