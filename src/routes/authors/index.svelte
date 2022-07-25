<script>
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";

  let tableData = [];
  let searchFirstname, searchLastname;
  const route = "/authors";
  const getAllRows = async (pFirstname, pLastname) => {
    try {
      let query = supabase.from("authors").select("*").order("lastName", { ascending: true }).order("firstName", { ascending: true });
      if (pFirstname) {
        query = query.like("firstName", `%${pFirstname}%`);
      }
      if (pLastname) {
        query = query.like("lastName", `%${pLastname}%`);
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
  $: getAllRows(searchFirstname, searchLastname);
</script>

<svelte:head>
  <title>Authors list</title>
</svelte:head>

<section class="container p-2 my-2 border border-primary rounded-3">
  <p class="h4 text-capitalize">authors</p>
  <a href={`${route}/newRow`}><i class="fa-solid fa-plus" /></a>
  <div class="table-responsive">
    <table class="table table-bordered table-hover table-sm">
      <thead>
        <tr>
          <th>Action</th>
          <th
            ><label for="firstName" class="form-label">First Name</label><input
              type="text"
              class="form-control"
              bind:value={searchFirstname}
              placeholder="%"
            /></th
          >
          <th
            ><label for="lastName" class="form-label">Last Name</label><input
              type="text"
              class="form-control"
              bind:value={searchLastname}
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
              {data.firstName}
            </td>
            <td>
              {data.lastName}
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</section>
