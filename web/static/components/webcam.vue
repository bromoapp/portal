<template>
    <div>
        <div>
            <video id="cam_video" autoplay="true"></video>
        </div>
        <canvas id="cam_canvas"></canvas>
    </div>
</template>

<script>
export default {
    mounted() {
        let canvasContext = null
        let camVideo = document.getElementById("cam_video")
        let camCanvas = document.getElementById("cam_canvas")

        let onSucceed = (stream) => {
            camVideo.srcObject = stream
        }
        let onFailed = (error) => {
            console.error(error)
        }

        if (camVideo && camCanvas) {
            canvasContext = camCanvas.getContext("2d")

            navigator.getUserMedia = (navigator.getUserMedia
                || navigator.webkitGetUserMedia || navigator.mozGetUserMedia
                || navigator.msGetUserMedia || navigator.oGetUserMedia)
            navigator.getUserMedia({ video: true }, onSucceed, onFailed)
        }
    }
}
</script>

<style>

</style>