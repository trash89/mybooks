<script>
  import { page } from "$app/stores";
  const { authorId } = $page.params;
  $: console.log(authorId);
</script>

<h1>edit author</h1>
<h4>{authorId}</h4>
