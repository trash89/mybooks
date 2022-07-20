<script context="module">
  export const prerender = true;
  import { user } from "$lib/sessionStore";
  import Auth from "../components/Auth.svelte";
</script>

<nav class="navbar">
  <div class="nav-container">
    <div class="nav-center">
      <a href="/">Home</a>
      <a href="/collections">Collections</a>
      <a href="/authors">Authors</a>
      <a href="/books">Books</a>
      <a href="/whishlist">Whishlist</a>
      {#if $user}
        <a href="/logout">Logout</a>
      {:else}
        <Auth />
      {/if}
    </div>
  </div>
</nav>
