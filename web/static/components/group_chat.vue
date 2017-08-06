<template>
    <div v-if="panel_visible"></div>
</template>
<script>
export default {
    data() {
        return {
            currGroup: null,
            height: "350px",
            maxWidth: "250px",
            panel_visible: false
        }
    },
}
</script>

<style>
  
</style>
