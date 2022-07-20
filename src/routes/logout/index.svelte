<script>
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { supabase } from "$lib/supabaseClient";
  export const prerender = true;

  const callLogout = async () => {
    const { error } = await supabase.auth.signOut();
    if (!error) {
      goto("/");
    }
  };

  onMount(async () => {
    await callLogout();
  });
</script>
