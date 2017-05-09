<template>
    <div>
        <div id="cam_video_mask">
            <video id="cam_video" autoplay="true"></video>
        </div>
        <canvas id="cam_canvas"></canvas>
    </div>
</template>

<script>
export default {}
</script>

<style>
#cam_video_mask {
    width: 240px;
    height: 240px;
    border-radius: 120px;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
#cam_video {
    width: 480px;
    height: 480px;
    position: absolute;
    top: -120px;
    left: -120px;
}
#cam_canvas {
    width: 480px;
    height: 480px;
    display: none;
}
</style>