import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import ServerConn from "../components/server_conn.vue"
import Sidebar from "../components/sidebar.vue"
import Popup from "../components/popup.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_server_conn(socket, element)
            this.init_popup()
            this.init_sidenav()
        }
    },
    init_server_conn(socket, element) {
        let username = element.getAttribute("data-username")
        Vue.component("server-conn", ServerConn)
        new Vue({
            el: "#server_conn_div",
            data() {
                return {
                    user: username,
                    wsocket: socket
                }
            },
            render(createElement) {
                return createElement(ServerConn, {})
            }
        })
    },
    init_popup() {
        Vue.component("popup", Popup)
        new Vue({
            el: "#popup_div",
            render(createElement) {
                return createElement(Popup, {})
            }
        })
    },
    init_sidenav() {
        Vue.component("sidebar", Sidebar)
        new Vue({
            el: "#sidebar_div",
            data() {
                return {
                    maxWidth: 282,
                    minWidth: 50
                }
            },
            render(createElement) {
                return createElement(Sidebar, {})
            }
        })
    }
}
export default lobby