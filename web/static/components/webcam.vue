<template>
    <div>
        <div>
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
    width: 280px;
    height: 210px;
    border-radius: 5px;
    position: relative;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}

#cam_video {
    width: 280px;
    height: 210px;
    transition: 0.5s;
}

#cam_canvas {
    width: 280px;
    height: 210px;
    display: none;
}

#main {
    transition: margin-left margin-top .5s;
    padding: 20px;
}
</style>