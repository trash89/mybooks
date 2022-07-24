<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";

  let tableData = [];
  let searchName;
  const route = "/collections";
  const getAllRows = async (pName) => {
    try {
      let query = supabase.from("collections").select("*").order("name", { ascending: true });
      if (pName) {
        query = query.like("name", `%${pName}%`);
      }
      const { data } = await query;
      tableData = data;
    } catch (err) {
      console.log(err);
    }
  };

  onMount(async () => {
    await getAllRows();
  });
  $: getAllRows(searchName);
</script>

<svelte:head>
  <title>Collections list</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">collections</p>
  <a href={`${route}/newRow`}><i class="fa-solid fa-plus" /></a>
  <table class="table table-responsive table-bordered table-hover">
    <thead>
      <tr>
        <th>Action</th>
        <th><label for="name" class="form-label">Name</label><input type="text" class="form-control" bind:value={searchName} placeholder="%" /></th>
      </tr>
    </thead>
    <tbody>
      {#each tableData as data (data.id)}
        <tr key={data.id}>
          <td>
            <a href={`${route}/${data.id}`}><i class="fa-solid fa-pen" /></a>
          </td>
          <td>
            {data.name}
          </td>
        </tr>
      {/each}
    </tbody>
  </table>
</section>
