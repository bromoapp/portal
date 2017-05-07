<template>
    <div class="webcam-video">
        <video id="webcam-window" 
            autoplay="true">
        </video>
    </div>
</template>

<script>
export default {}
</script>

<style>
.webcam-video {
    border-radius: 50%;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
video {
    width: 320px;
    height: 320px;
    position: absolute;
    top: -80px;
    left: -80px;
}
</style>