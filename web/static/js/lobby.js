import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Webcam from "../components/webcam.vue"
import Logout from "../components/logout.vue"
import Sidenav from "../components/sidenav.vue"

let sideNavApp
let proxyChannelPrefix = "user_proxy:"
let roomChannelPrefix = "user_room:"
let proxyChannel = null
let roomChannel = null
let sharedChannels = []

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_conn(socket, element)
            this.init_logout()
            this.init_sidenav()
        }
    },
    init_conn(socket, element) {
        socket.connect()
        let username = element.getAttribute("data-username")

        proxyChannel = socket.channel(proxyChannelPrefix + username)
        proxyChannel.on("user_updates", updates => this.onUpdatesAvail(updates))
        proxyChannel.join()
            .receive("ok", () => { console.log("Succeed to join proxy ch") })
            .receive("error", () => { console.log("Failed to join proxy ch") })

        roomChannel = socket.channel(roomChannelPrefix + username)
        roomChannel.join()
            .receive("ok", () => { console.log("Succeed to join room ch") })
            .receive("error", () => { console.log("Failed to join room ch") })

        sharedChannels.push(roomChannel)
    },
    init_logout() {
        Vue.component("logout", Logout)
        new Vue({
            el: "#logout_container",
            render(createElement) {
                return createElement(Logout, {})
            },
            mounted() {
                let form = document.getElementById("logout_form")
                let btn = document.getElementById("logout_btn")
                let onClicked = () => {
                    if (proxyChannel) {
                        proxyChannel.leave()
                    }
                    for (let ch of sharedChannels) {
                        ch.leave()
                    }
                    form.submit()
                }
                btn.addEventListener("click", onClicked)
            }
        })
    },
    init_sidenav() {
        Vue.component("sidenav", Sidenav)
        sideNavApp = new Vue({
            el: "#sidenav_container",
            data() {
                return {
                    maxWidth: 282,
                    minWidth: 50,
                }
            },
            render(createElement) {
                return createElement(Sidenav, {})
            },
            methods: {
                onFriendsListUpdates(friends) {
                    this.$events.$emit("on_friends_list_updates", friends)
                }
            }
        })
    },
    onUpdatesAvail(updates) {
        sideNavApp.onFriendsListUpdates(updates.friends)
    }
}
export default lobby