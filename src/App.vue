<template>
  <img alt="Vue logo" src="./assets/logo.png">
  <div class="app">
    <GameCanvas></GameCanvas>
  </div>
</template>

<script>
import GameCanvas from "@/components/GameCanvas.vue";

export default {
  name: 'App',
  components: {
    GameCanvas
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
