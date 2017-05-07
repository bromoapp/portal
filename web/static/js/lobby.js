import Vue from 'vue'
import SelfCam from "../components/self_cam.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_conn(socket, element)
        }
    },
    init_conn(socket, element) {
        socket.connect()
        let username = element.getAttribute("data-username")
        let lobbyChannel = socket.channel("lobby:" + username)
        lobbyChannel.join()
    }
}
export default lobby