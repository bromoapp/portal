import Vue from 'vue'
import Webcam from "../components/webcam.vue"
import Other from "../components/other.vue"

let webcamWindow = null
let onVideoSucceed = (stream) => {
    webcamWindow.srcObject = stream;
}
let onVideoFailed = (error) => {
    console.error(error)
}

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_webcam()
            this.init_other()
            this.init_conn(socket, element)
        }
    },
    init_webcam() {
        Vue.component("webcam", Webcam)
        new Vue({
            el: '#webcam-container',
            render(createElement) {
                return createElement(Webcam, {})
            },
            mounted() {
                webcamWindow = document.getElementById("webcam-window")
                if (webcamWindow) {
                    navigator.getUserMedia = (navigator.getUserMedia 
                    || navigator.webkitGetUserMedia || navigator.mozGetUserMedia 
                    || navigator.msGetUserMedia || navigator.oGetUserMedia)
                    navigator.getUserMedia({video: true}, onVideoSucceed, onVideoFailed)
                }
            }
        })
    },
    init_other() {
        Vue.component("other", Other)
        new Vue({
            el: '#other-container',
            render(createElement) {
                return createElement(Other, {})
            }
        })
    },
    init_conn(socket, element) {
        socket.connect()
        let username = element.getAttribute("data-username")
        let lobbyChannel = socket.channel("lobby:" + username)
        lobbyChannel.join()
    }
}
export default lobby