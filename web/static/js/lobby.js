import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Webcam from "../components/webcam.vue"
import Logout from "../components/logout.vue"
import Sidenav from "../components/sidenav.vue"
import Settings from "../components/settings.vue"
import Search from "../components/search.vue"
import Messages from "../components/messages.vue"

let sideNavApp, signOutForm
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
            this.init_popups()
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
        signOutForm = new Vue({
            el: "#logout_container",
            render(createElement) {
                return createElement(Logout, {})
            },
            data() {
                return {
                    form: null
                }
            },
            mounted() {
                this.form = document.getElementById("logout_form")
            },
            methods: {
                signOut() {
                    if (proxyChannel) {
                        proxyChannel.leave()
                    }
                    for (let ch of sharedChannels) {
                        ch.leave()
                    }
                    this.form.submit()
                }
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
            },
            created() {
                this.$events.$on("sign_out", () => {
                    signOutForm.signOut()
                })
            }
        })
    },
    init_popups() {
        Vue.component("settings", Settings)
        new Vue({
            el: "#settings_container",
            render(createElement) {
                return createElement(Settings, {})
            },
        })
        Vue.component("search", Search)
        new Vue({
            el: "#search_container",
            render(createElement) {
                return createElement(Search, {})
            },
        })
        Vue.component("messages", Messages)
        new Vue({
            el: "#messages_container",
            render(createElement) {
                return createElement(Messages, {})
            },
        })
    },
    onUpdatesAvail(updates) {
        sideNavApp.onFriendsListUpdates(updates.friends)
    }
}
export default lobby