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
    height: 180px;
    border-radius: 15px;
    position: relative;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
#cam_video {
    width: 240px;
    height: 180px;
}
#cam_canvas {
    width: 240px;
    height: 180px;
    display: none;
}
</style>