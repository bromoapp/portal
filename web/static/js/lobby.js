import Vue from 'vue'
import Webcam from "../components/webcam.vue"
import Other from "../components/other.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            let channel = this.init_conn(socket, element)
            if (channel) {
                this.init_webcam(channel)
                this.init_other()
                this.init_logout(channel)
            }
        }
    },
    init_conn(socket, element) {
        socket.connect()
        let username = element.getAttribute("data-username")
        let lobbyChannel = socket.channel("lobby:" + username)
        lobbyChannel.join()
        return lobbyChannel
    },
    init_webcam(channel) {
        Vue.component("webcam", Webcam)
        new Vue({
            el: '#webcam-container',
            render(createElement) {
                return createElement(Webcam, {})
            },
            mounted() {
                var delay = 100
                if (navigator.userAgent.toLowerCase().indexOf("chrome") > -1) {
                    delay = 40
                    console.info(">>> using chrome")
                } else {
                    console.info(">>> using non chrome!")
                }
                let canvasContext = null
                let camVideo = document.getElementById("cam-video")
                let camCanvas = document.getElementById("cam-canvas")
                let camImage = document.getElementById("cam-image")

                let onSucceed = (stream) => {
                    camVideo.srcObject = stream
                    
                    setInterval(() => {
                        canvasContext.drawImage(camVideo, 0, 0, 240, 120)
                        let data = camCanvas.toDataURL("image/png")
                        camImage.setAttribute("src", data)
                    }, delay)
                }
                let onFailed = (error) => {
                    console.error(error)
                }

                if (camVideo && camCanvas) {
                    canvasContext = camCanvas.getContext("2d")

                    navigator.getUserMedia = (navigator.getUserMedia 
                    || navigator.webkitGetUserMedia || navigator.mozGetUserMedia 
                    || navigator.msGetUserMedia || navigator.oGetUserMedia)
                    navigator.getUserMedia({video: true}, onSucceed, onFailed)
                }
            }
        })
    },
    init_logout(channel) {
        
    },
    init_other() {
        Vue.component("other", Other)
        new Vue({
            el: '#other-container',
            render(createElement) {
                return createElement(Other, {})
            }
        })
    }
}
export default lobby