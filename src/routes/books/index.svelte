<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";

  let tableData = [];
  let searchName, searchLangue, searchAuthor, searchCollection;
  const route = "/books";
  const getAllRows = async (pName, pLangue, pAuthor, pCollection) => {
    let query = supabase
      .from("v_books")
      .select('id,name,langue,"firstName","lastName",coll_name')
      .order("lastName", { ascending: true })
      .order("firstName", { ascending: true })
      .order("name", { ascending: true });
    if (pName) {
      query = query.like("name", `%${pName}%`);
    }
    if (pLangue) {
      query = query.like("langue", `%${pLangue}%`);
    }
    if (pAuthor) {
      query = query.like("lastName", `%${pAuthor}%`);
    }
    if (pCollection) {
      query = query.like("coll_name", `%${pCollection}%`);
    }

    const { data, error } = await query;
    if (!error) {
      tableData = data;
    }
  };

  onMount(async () => {
    await getAllRows();
  });
  $: getAllRows(searchName, searchLangue, searchAuthor, searchCollection);
</script>

<svelte:head>
  <title>Books list</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">books</p>
  <a href={`${route}/newRow`}><i class="fa-solid fa-plus" /></a>
  <div class="table-responsive">
    <table class="table table-sm table-bordered table-hover">
      <thead>
        <tr>
          <th>Action</th>
          <th
            ><label for="searchAuthor" class="form-label">Author</label><input type="text" class="form-control" bind:value={searchAuthor} placeholder="%" /></th
          >
          <th><label for="searchName" class="form-label">Name</label><input type="text" class="form-control" bind:value={searchName} placeholder="%" /></th>
          <th
            ><label for="searchLangue" class="form-label">Langue</label><input type="text" class="form-control" bind:value={searchLangue} placeholder="%" /></th
          >
          <th
            ><label for="searchCollection" class="form-label">Collection</label><input
              type="text"
              class="form-control"
              bind:value={searchCollection}
              placeholder="%"
            /></th
          >
        </tr>
      </thead>
      <tbody>
        {#each tableData as data (data.id)}
          <tr key={data.id}>
            <td>
              <a href={`${route}/${data.id}`}><i class="fa-solid fa-pen" /></a>
            </td>
            <td>
              {data.lastName},{data.firstName}
            </td>
            <td>
              {data.name}
            </td>
            <td>
              {data.langue}
            </td>
            <td>
              {data.coll_name || ""}
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</section>
