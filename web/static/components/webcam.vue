<template>
    <div>
        <div>
            <video id="cam_video" autoplay="true"></video>
            <div class="overlay-buttons">
                <a title="Settings" href="javascript:" class="cl-f50057-d" v-on:click="openSettings">
                    <i class="fa fa-gear"></i>
                </a>
                <a title="Video" href="javascript:" class="cl-f50057-d" v-on:click="switchVideo">
                    <i class="fa fa-video-camera"></i>
                </a>
                <a title="Sound" href="javascript:" class="cl-f50057-d" v-on:click="switchSound">
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
    },
    methods: {
        openSettings() {
            this.$events.$emit("switch_settings")
        },
        switchVideo() { },
        switchSound() { }
    }
}
</script>

<style>

</style>