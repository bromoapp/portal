<template>
    <div id="side_nav" class="sidenav bg-212121-s">
        <logout></logout>
        <server></server>
        <div>
            <div class="toolbar">
                <div class="toolbar-button">
                    <button title="Signout" id="btn_signout" class="btn bg-37474f-d" v-on:click="signout">
                        <i class="fa fa-sign-out"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Channels" id="btn_channels" class="btn bg-37474f-d" v-on:click="openChannels">
                        <i class="fa fa-window-restore"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Friends" id="btn_friends" class="btn bg-37474f-d" v-on:click="openFriends">
                        <i class="fa fa-users"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Chats" id="btn_chats" class="btn bg-37474f-d" v-on:click="openChats">
                        <i class="fa fa-comments-o"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Invitations" id="btn_inivitations" class="btn bg-37474f-d" v-on:click="openInvitations">
                        <i class="fa fa-envelope-o"></i>
                    </button>
                </div>
            </div>
            <button id="switch" class="btn bg-f50057-d sidenav-close" v-on:click="changeMode">
                <i class=""></i>
            </button>
        </div>
        <div id="video_cam" class="video-cam">
            <webcam></webcam>
        </div>
        <channels></channels>
        <friends></friends>
        <chats></chats>
        <invitations></invitations>
        <div id="side_nav_cover" class="sidenav-cover bg-212121-s"></div>
    </div>
</template>

<script>
import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Logout from "./logout.vue"
import Server from "./server.vue"
import Webcam from "./webcam.vue"
import Channels from "./channels.vue"
import Friends from "./friends.vue"
import Chats from "./chats.vue"
import Invitations from "./invitations.vue"

let btnSignout, btnChannels, btnFriends
let btnChats, btnInvitations
let closed = false

export default {
    components: {
        Logout,
        Server,
        Webcam,
        Channels,
        Friends,
        Chats,
        Invitations
    },
    data() {
        return {
            maxWidth: this.$parent.maxWidth,
            minWidth: this.$parent.minWidth,
            wsocket: this.$parent.wsocket,
            closeCmd: null
        }
    },
    methods: {
        signout() {
            btnSignout.blur()
            this.$events.$emit("sign_out")
        },
        openChannels() {
            btnChannels.blur()
            if (this.closeCmd != "close_channels") {
                this._closePanel()
                this.$events.$emit("open_channels")
                this.closeCmd = "close_channels"
            }
        },
        openFriends() {
            btnFriends.blur()
            if (this.closeCmd != "close_friends") {
                this._closePanel()
                this.$events.$emit("open_friends")
                this.closeCmd = "close_friends"
            }
        },
        openChats() {
            btnChats.blur()
            if (this.closeCmd != "close_chats") {
                this._closePanel()
                this.$events.$emit("open_chats")
                this.closeCmd = "close_chats"
            }
        },
        openInvitations() {
            btnInvitations.blur()
            if (this.closeCmd != "close_invitations") {
                this._closePanel()
                this.$events.$emit("open_invitations")
                this.closeCmd = "close_invitations"
            }
        },
        changeMode() {
            if (closed) {
                this._open()
            } else {
                this._close()
            }
        },
        _close() {
            document.getElementById("side_nav_cover").style.width = this.maxWidth + "px"
            setTimeout(() => {
                document.getElementById("switch").classList.add("fa", "fa-chevron-right")
                document.getElementById("switch").classList.remove("fa-chevron-left")
                document.getElementById("switch").blur()
                document.getElementById("side_nav").style.width = this.minWidth + "px"
                document.getElementById("side_nav_cover").style.width = this.minWidth + "px"
            }, 300)

            closed = true
        },
        _open() {
            document.getElementById("side_nav").style.width = this.maxWidth + "px"
            document.getElementById("side_nav_cover").style.width = this.maxWidth + "px"
            setTimeout(() => {
                document.getElementById("switch").classList.add("fa", "fa-chevron-left")
                document.getElementById("switch").classList.remove("fa-chevron-right")
                document.getElementById("switch").blur()
                document.getElementById("side_nav_cover").style.width = "0px"
            }, 300);

            closed = false
        },
        _closePanel() {
            if (this.closeCmd) {
                this.$events.$emit(this.closeCmd)
            }
        }
    },
    mounted() {
        btnSignout = document.getElementById("btn_signout")
        btnChannels = document.getElementById("btn_channels")
        btnFriends = document.getElementById("btn_friends")
        btnChats = document.getElementById("btn_chats")
        btnInvitations = document.getElementById("btn_inivitations")

        setTimeout(() => {
            this._open()
            setTimeout(() => {
                this.openChats()
            }, 500)
        }, 100)
    }
}
</script>

<style>

</style>
