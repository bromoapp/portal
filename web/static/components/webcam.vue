<template>
    <div>
        <div id="cam-video-mask">
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
    border-radius: 120px;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
#cam-video {
    width: 480px;
    height: 480px;
    position: absolute;
    top: -120px;
    left: -120px;
}
#cam-canvas {
    width: 480px;
    height: 480px;
    display: none;
}
</style>