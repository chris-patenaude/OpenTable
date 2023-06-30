<template>
  <img alt="Vue logo" src="./assets/logo.png">
  <div >
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

