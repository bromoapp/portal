import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Webcam from "../components/webcam.vue"
import Logout from "../components/logout.vue"
import Sidenav from "../components/sidenav.vue"

let sideNavApp
let privateChannelPrefix = "private:"
let privateChannel = null
let sharedChannels = []
let sidenavMaxWidth = 282
let sidenavMinWidth = 52

let rooms = [
        {name: "80s Music"}, 
        {name: "Rock Balads"}, 
        {name: "Trance Music"}, 
        {name: "Chess Grand Master"}
    ]

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
        privateChannel = socket.channel(privateChannelPrefix + username)
        privateChannel.on("user_updates", updates => this.onUpdatesAvail(updates))
        privateChannel.join()
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
                    if (privateChannel) {
                        privateChannel.leave()
                    }
                    for (ch in sharedChannels) {
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
                    rooms: rooms
                }
            },
            render(createElement) {
                return createElement(Sidenav, {})
            },
            methods: {
                onUpdatesAvail(updates) {
                    this.$events.$emit("on_updates_avail", updates)
                }
            },
            mounted() {
                document.getElementById("side_nav").style.width = sidenavMaxWidth + "px"
                let delay = 40
                let canvasContext = null
                let camVideo = document.getElementById("cam_video")
                let camCanvas = document.getElementById("cam_canvas")

                let onSucceed = (stream) => {
                    camVideo.srcObject = stream
                    if (sharedChannels.length > 0) {
                        console.log(">>> BROADCASTING...")
                        setInterval(() => {
                            canvasContext.drawImage(camVideo, 0, 0, 240, 120)
                            let data = camCanvas.toDataURL("image/png")
                            for (channel in sharedChannels) {
                                channel.push("stream:video", JSON.stringify(data))
                            }
                        }, delay)
                    }
                }
                let onFailed = (error) => {
                    console.error(error)
                }

                if (camVideo && camCanvas) {
                    canvasContext = camCanvas.getContext("2d")

                    navigator.getUserMedia = (navigator.getUserMedia 
                    || navigator.webkitGetUserMedia || navigator.mozGetUserMedia 
                    || navigator.msGetUserMedia || navigator.oGetUserMedia)
                    navigator.getUserMedia({video: true}, onSucceed, onFailed)
                }
            }
        })
    },
    onUpdatesAvail(updates) {
        sideNavApp.onUpdatesAvail(updates)
    }
}
export default lobby