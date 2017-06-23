import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import ServerConn from "../components/server_conn.vue"
import MainWindow from "../components/main_window.vue"
import Sidebar from "../components/sidebar.vue"
import Popup from "../components/popup.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_server_conn(socket, element)
            this.init_popup()
            this.init_sideBar()
            this.init_mainWindow()
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
    init_sideBar() {
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
    },
    init_mainWindow() {
        Vue.component("main-window", MainWindow)
        new Vue({
            el: "#main_div",
            data() {
                return {
                    maxLeftMargin: 282,
                    minLeftMargin: 50
                }
            },
            render(createElement) {
                return createElement(MainWindow, {})
            }
        })
    }
}
export default lobby