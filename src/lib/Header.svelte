<script context="module">
  export const prerender = true;
  import { page } from "$app/stores";
  import { user } from "$lib/sessionStore";
  import logo from "$lib/assets/logo-192x192.png";
</script>

<nav class="navbar navbar-expand-sm justify-content-center bg-primary navbar-dark">
  <div class="container-fluid">
    <a href="/" class={$page.url.pathname === "/" ? "navbar-brand active" : "navbar-brand"}
      ><img src={logo} alt="My Books" style="width:40px;" class="rounded-pill" /></a
    >
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#collapsibleNavbar">
      <span class="navbar-toggler-icon" />
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class={$page.url.pathname === "/collections" ? "nav-link active" : "nav-link"} href="/collections">Collections</a>
        </li>
        <li class="nav-item">
          <a class={$page.url.pathname === "/authors" ? "nav-link active" : "nav-link"} href="/authors">Authors</a>
        </li>
        <li class="nav-item">
          <a class={$page.url.pathname === "/books" ? "nav-link active" : "nav-link"} href="/books">Books</a>
        </li>
      </ul>
    </div>
    {#if $user}
      <div class="d-flex ">
        <div class="nav-item dropdown ">
          <a class="nav-link dropdown-toggle bg-primary text-white" href="/logout" role="button" data-bs-toggle="dropdown">{$user.email}</a>
          <ul class="dropdown-menu">
            <li><a class={$page.url.pathname === "/logout" ? "dropdown-item active" : "dropdown-item"} href="/logout">Logout</a></li>
          </ul>
        </div>
      </div>
    {/if}
  </div>
</nav>
