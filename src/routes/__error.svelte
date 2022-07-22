<script context="module">
  export const prerender = true;
  import nf from "$lib/assets/not-found.svg";
</script>

<div>
  <img src={nf} alt="not found" />
  <h3>Ohh! Page Not Found</h3>
  <p>We can't seem to find the page you're looking for</p>
</div>

<style>
  div {
    min-height: 100vh;
    text-align: center;
    align-items: center;
    justify-content: center;
  }
  img {
    width: 90vw;
    max-width: 300px;
    margin-bottom: 2rem;
  }
  h3 {
    margin-bottom: 0.5rem;
  }
  p {
    margin-top: 0;
    margin-bottom: 0.5rem;
    color: black;
  }
</style>
