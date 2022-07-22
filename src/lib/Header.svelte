<script context="module">
  export const prerender = true;
  import { page } from "$app/stores";
  import { user } from "$lib/sessionStore";
  import Auth from "../components/Auth.svelte";
</script>

<nav class="navbar navbar-expand-sm bg-primary navbar-dark">
  <div class="container-fluid">
    <ul class="navbar-nav">
      <li class="nav-item">
        <a href="/" class={$page.url.pathname === "/" ? "nav-link active" : "nav-link"}>Home</a>
      </li>
      <li class="nav-item">
        <a class={$page.url.pathname === "/collections" ? "nav-link active" : "nav-link"} href="/collections">Collections</a>
      </li>
      <li class="nav-item">
        <a class={$page.url.pathname === "/authors" ? "nav-link active" : "nav-link"} href="/authors">Authors</a>
      </li>
      <li class="nav-item">
        <a class={$page.url.pathname === "/books" ? "nav-link active" : "nav-link"} href="/books">Books</a>
      </li>
      <li class="nav-item">
        <a class={$page.url.pathname === "/whishlist" ? "nav-link active" : "nav-link"} href="/whishlist">Whishlist</a>
      </li>
      {#if $user}
        <li class="nav-item">
          <a class={$page.url.pathname === "/logout" ? "nav-link active" : "nav-link"} href="/logout">Logout</a>
        </li>
      {:else}
        <Auth />
      {/if}
    </ul>
  </div>
</nav>
