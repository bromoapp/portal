<template>
    <div>
        <video id="cam-video" autoplay="true"></video>
        <canvas id="cam-canvas"></canvas>
        <img id="cam-image">
    </div>
</template>

<script>
export default {}
</script>

<style>
#cam-video {
    width: 320px;
    height: 240px;
    display: none;
}
#cam-canvas {
    width: 320px;
    height: 240px;
    display: none;
}
#cam-image {
    width: 320px;
    height: 240px;
}
</style>