<script context="module">
  export const prerender = true;
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
