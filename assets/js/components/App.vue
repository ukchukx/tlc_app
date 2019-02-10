<template>
  <div id="app">
    <header>
      <h1>Phoenix Vue</h1>
    </header>
    <main>
      <hello/>
    </main>
  </div>
</template>

<script>
import Hello from './Hello';
export default {
    name: 'app',
    components: {
      Hello
    }
};
</script>

<style lang="scss">
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}
main {
  margin-top: 60px;
}
</style>
