<script context="module">
  export const prerender = true;
  import "$lib/assets/fontawesome-free-6.1.1-web/css/all.min.css";
  import "$lib/assets/normalize.css";
  import "$lib/assets/global.css";

  import Header from "$lib/Header.svelte";
  import Footer from "$lib/Footer.svelte";
  import { user } from "$lib/sessionStore";
  import { supabase } from "$lib/supabaseClient";
  import Auth from "../components/Auth.svelte";

  const localUser = supabase.auth.user();
  user.set(localUser);

  supabase.auth.onAuthStateChange((_, session) => {
    user.set(session?.user);
  });
</script>

{#if $user}
  <Header />
  <slot />
  <Footer />
{:else}
  <Auth />
{/if}
