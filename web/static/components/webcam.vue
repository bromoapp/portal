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
    width: 250px;
    height: 250px;
    border-radius: 125px;
    -webkit-mask-image: -webkit-radial-gradient(circle, white 100%, black 100%);
}
video {
    width: 500px;
    height: 500px;
    position: absolute;
    top: -125px;
    left: -125px;
}
</style>