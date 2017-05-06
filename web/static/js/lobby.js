import Vue from 'vue'
import SelfCam from "../components/self_cam.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_ui()
            this.init_conn(socket, element)
        }
    },
    init_ui() {
        // Create the main component
        Vue.component('self_cam', SelfCam)

        // And create the top-level view model:
        new Vue({
            el: '#lobby-container',
            render(createElement) {
                return createElement(SelfCam, {})
            }
        });
    },
    init_conn(socket, element) {
        socket.connect()
        let username = element.getAttribute("data-username")
        let lobbyChannel = socket.channel("lobby:" + username)
        lobbyChannel.join()
    }
}
export default lobby