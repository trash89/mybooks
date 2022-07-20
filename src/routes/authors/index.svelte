<script>
  import { supabase } from "$lib/supabaseClient";

  const user = supabase.auth.user();
  console.log("user=", user);
  let { data, error } = supabase.from("authors").select("*");
  console.log("data=", data);
</script>

<h1>authors</h1>
{#await data}
  <p>waiting</p>
{:then authors}
  {#each authors.data as author (author.id)}
    {author.firstName}
    {author.lastName}
  {:else}
    <p>no data</p>
  {/each}
{:catch error}
  <p style="color: red">{error.message}</p>
{/await}
