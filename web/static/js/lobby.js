import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Sidenav from "../components/sidenav.vue"
import Popup from "../components/popup.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_sidenav(socket, element)
        }
    },
    init_sidenav(socket, element) {
        let username = element.getAttribute("data-username")
        Vue.component("sidenav", Sidenav)
        new Vue({
            el: "#leftside_bar",
            data() {
                return {
                    maxWidth: 282,
                    minWidth: 50,
                    user: username,
                    wsocket: socket,
                }
            },
            render(createElement) {
                return createElement(Sidenav, {})
            }
        })
    }
}
export default lobby