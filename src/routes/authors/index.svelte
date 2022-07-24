<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";

  let authors = [];
  let searchFirstname, searchLastname;
  const getAllAuthors = async (pFirstname, pLastname) => {
    try {
      let query = supabase.from("authors").select("*").order("lastName", { ascending: true }).order("firstName", { ascending: true });
      if (pFirstname) {
        query = query.like("firstName", `%${pFirstname}%`);
      }
      if (pLastname) {
        query = query.like("lastName", `%${pLastname}%`);
      }
      const { data } = await query;
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

<svelte:head>
  <title>Author's list</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">authors</p>
  <a href="/authors/newAuthor"><i class="fa-solid fa-plus" /></a>
  <table class="table table-responsive table-bordered table-hover">
    <thead>
      <tr>
        <th>Action</th>
        <th>Firstname <input type="text" class="form-control" bind:value={searchFirstname} placeholder="%" /></th>
        <th>Lastname <input type="text" class="form-control" bind:value={searchLastname} placeholder="%" /></th>
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
</section>
