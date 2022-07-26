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

  const escapeCsvCell = (cell) => {
    if (cell == null) {
      return "";
    }
    const sc = cell.toString().trim();
    if (sc === "" || sc === '""') {
      return sc;
    }
    if (sc.includes('"') || sc.includes(",") || sc.includes("\n") || sc.includes("\r")) {
      return '"' + sc.replace(/"/g, '""') + '"';
    }
    return sc;
  };

  const makeCsvData = (columns, data) => {
    return data.reduce((csvString, rowItem) => {
      return csvString + columns.map(({ accessor }) => escapeCsvCell(accessor(rowItem))).join(",") + "\r\n";
    }, columns.map(({ name }) => escapeCsvCell(name)).join(",") + "\r\n");
  };

  const downloadAsCsv = (columns, data, filename) => {
    const csvData = makeCsvData(columns, data);
    const csvFile = new Blob([csvData], { type: "text/csv" });
    const downloadLink = document.createElement("a");

    downloadLink.display = "none";
    downloadLink.download = filename;
    downloadLink.href = window.URL.createObjectURL(csvFile);
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
  };

  const handleDownloadCsv = () => {
    const columns = [
      { accessor: (item) => item.firstName, name: "FirstName" },
      { accessor: (item) => item.lastName, name: "LastName" },
      { accessor: (item) => item.name, name: "Book Name" },
      { accessor: (item) => item.langue, name: "Langue" },
      { accessor: (item) => item.coll_name, name: "Collection" },
    ];

    downloadAsCsv(columns, tableData, "MyBooks");
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
  <div class="d-flex justify-content-between">
    <a href={`${route}/newRow`}><i class="fa-solid fa-plus" /></a>
    <button type="button" class="btn btn-outline-light text-dark flex-fill" data-bs-toggle="tooltip" title="Export to CSV" on:click={handleDownloadCsv}
      ><i class="fa-solid fa-file-csv" /></button
    >
  </div>
  <div class="table-responsive">
    <table class="table table-sm table-bordered table-hover">
      <thead>
        <tr>
          <th>Action</th>
          <th><input type="text" class="form-control" bind:value={searchAuthor} placeholder="%author%" /></th>
          <th><input type="text" class="form-control" bind:value={searchName} placeholder="%book%" /></th>
          <th><input type="text" class="form-control" bind:value={searchLangue} placeholder="%langue%" /></th>
          <th><input type="text" class="form-control" bind:value={searchCollection} placeholder="%collection%" /></th>
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
