import Vue from 'vue'
import PortalApp from "../components/portal_app.vue"

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
            Vue.component('portal-app', PortalApp)

            // And create the top-level view model:
            new Vue({
                el: '#portal-app-container',
                render(createElement) {
                    return createElement(PortalApp, {})
                }
            });
        }
    }
}
export default lobby