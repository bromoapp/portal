<template>
    <div>
        <div>
            <video id="cam_video" autoplay="true"></video>
        </div>
    </div>
</template>

<script>
export default {
    mounted() {
        let camVideo = document.getElementById("cam_video")

        let onSucceed = (stream) => {
            camVideo.srcObject = stream
        }
        let onFailed = (error) => {
            console.error(error)
        }

        if (camVideo) {
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