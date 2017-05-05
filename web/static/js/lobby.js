import Vue from 'vue'
import PortalApp from "../components/lobby.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            socket.connect()
            let username = element.getAttribute("data-username")
            let lobbyChannel = socket.channel("lobby:" + username)
            lobbyChannel.join()

            // Create the main component
            Vue.component('lobby', PortalApp)

            // And create the top-level view model:
            new Vue({
                el: '#lobby-container',
                render(createElement) {
                    return createElement(PortalApp, {})
                }
            });
        }
    }
}
export default lobby