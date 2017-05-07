<template>
    <div>
        <video id="cam-video" autoplay="true"></video>
        <canvas id="cam-canvas"></canvas>
        <div id="cam-image-mask">
            <img id="cam-image">
        </div>
    </div>
</template>

<script>
export default {}
</script>

<style>
#cam-video {
    width: 320px;
    height: 320px;
    display: none;
}
#cam-canvas {
    width: 320px;
    height: 320px;
    display: none;
}
#cam-image-mask {
    width: 240px;
    height: 240px;
    border-radius: 50%;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
#cam-image {
    width: 320px;
    height: 320px;
}
</style>