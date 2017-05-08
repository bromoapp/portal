<template>
    <div>
        <div id="cam-image-mask">
            <video id="cam-video" autoplay="true"></video>
        </div>
        <canvas id="cam-canvas"></canvas>
    </div>
</template>

<script>
export default {}
</script>

<style>
#cam-video-mask {
    width: 240px;
    height: 240px;
    border-radius: 50%;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
#cam-video {
    width: 320px;
    height: 320px;
}
#cam-canvas {
    width: 320px;
    height: 320px;
    display: none;
}
</style>