<script>
  import { onMount } from "svelte";
  import { user } from "$lib/sessionStore";
  import { supabase } from "$lib/supabaseClient";

  let authors = [];
  const getAllAuthors = async () => {
    try {
      let { data, error } = await supabase.from("authors").select("*");
      authors = data;
    } catch (err) {
      console.log(err);
    }
  };

  onMount(async () => {
    await getAllAuthors();
  });
  //$: console.log($user);
</script>

<h1>authors</h1>
<a href="/authors/newAuthor"><i class="fa-solid fa-plus" /></a>
<i class="fa-solid fa-trash" />
<i class="fa-solid fa-check" />
<ul>
  {#each authors as author (author.id)}
    <li key={author.id}><a href={`/authors/${author.id}`}><i class="fa-solid fa-pen" /></a> {author.firstName} {author.lastName}</li>
  {/each}
</ul>
