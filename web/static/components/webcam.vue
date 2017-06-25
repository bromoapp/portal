<template>
    <div>
        <div>
            <video id="cam_video" autoplay="true"></video>
            <div class="overlay-buttons">
                <a title="Settings" href="javascript:" class="cl-f50057-d">
                    <i class="fa fa-gear"></i>
                </a>
                <a title="Video" href="javascript:" class="cl-f50057-d">
                    <i class="fa fa-video-camera"></i>
                </a>
                <a title="Sound" href="javascript:" class="cl-f50057-d">
                    <i class="fa fa-microphone"></i>
                </a>
            </div>
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
.overlay-buttons {
    position: absolute;
    display: block;
    width: 100%;
    text-align: left;
    margin-left: 8px;
    top: 225px;
}

.overlay-buttons a {
    border-style: solid;
    border-width: 1px;
    border-radius: 3px;
    font-size: 18px;
    padding: 5px;
}
</style>