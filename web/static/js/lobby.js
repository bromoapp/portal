import Vue from 'vue'
import Webcam from "../components/webcam.vue"
import Other from "../components/other.vue"

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
            data() {
                return {
                    userMedia : navigator.getUserMedia 
                    || navigator.webkitGetUserMedia || navigator.mozGetUserMedia 
                    || navigator.msGetUserMedia || navigator.oGetUserMedia
                }
            },
            render(createElement) {
                return createElement(Webcam, {})
            },
            mounted() {
                let webcamWindow = document.getElementById("webcam-window")
                if (this.userMedia && webcamWindow) {
                    let onSucceed = (stream) => {
                        webcamWindow.srcObject = stream;
                    }
                    let onFailed = (error) => {
                        console.error(error)
                    }
                    navigator.getUserMedia({video: true}, onSucceed, onFailed)
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