<template>
    <div id="sidebar" class="sidebar bg-212121-s">
        <logout></logout>
        <div>
            <div class="toolbar">
                <div class="inline">
                    <button title="Signout" id="btn_signout" class="btn bg-37474f-d" v-on:click="signout">
                        <i class="fa fa-sign-out"></i>
                    </button>
                </div>
                <div class="inline">
                    <button title="Channels" id="btn_channels" class="btn bg-37474f-d" v-on:click="openChannels">
                        <i class="fa fa-window-restore"></i>
                    </button>
                </div>
                <div class="inline">
                    <button title="Friends" id="btn_friends" class="btn bg-37474f-d" v-on:click="openFriends">
                        <i class="fa fa-users"></i>
                    </button>
                </div>
                <div class="inline">
                    <button title="Chats" id="btn_chats" class="btn bg-37474f-d" v-on:click="openChats">
                        <i class="fa fa-comments-o"></i>
                    </button>
                </div>
                <div class="inline">
                    <button title="Invitations" id="btn_inivitations" class="btn bg-37474f-d" v-on:click="openInvitations">
                        <i class="fa fa-envelope-o"></i>
                    </button>
                </div>
            </div>
            <button id="switch" class="btn bg-f50057-d sidebar-close" v-on:click="changeMode">
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
        <div id="sidebar_cover" class="sidebar-cover bg-212121-s"></div>
    </div>
</template>

<script>
import Logout from "./logout.vue"
import Webcam from "./webcam.vue"
import Channels from "./channels.vue"
import Friends from "./friends.vue"
import Chats from "./chats.vue"
import Invitations from "./invitations.vue"

let btnSignout, btnChannels, btnFriends
let btnChats, btnInvitations

export default {
    components: {
        Logout,
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
            closeCmd: null,
            closed: false
        }
    },
    methods: {
        signout() {
            btnSignout.blur()
            let obj = {
                msg: "Do you really want to exit?",
                onYes: "sign_out"
            }
            this.$events.$emit("pop_question", obj)
        },
        openChannels() {
            btnChannels.blur()
            if (this.closeCmd != "close_channels") {
                this._closeSubPanel()
                this.$events.$emit("open_channels")
                this.closeCmd = "close_channels"
            }
        },
        openFriends() {
            btnFriends.blur()
            if (this.closeCmd != "close_friends") {
                this._closeSubPanel()
                this.$events.$emit("open_friends")
                this.closeCmd = "close_friends"
            }
        },
        openChats() {
            btnChats.blur()
            if (this.closeCmd != "close_chats") {
                this._closeSubPanel()
                this.$events.$emit("open_chats")
                this.closeCmd = "close_chats"
            }
        },
        openInvitations() {
            btnInvitations.blur()
            if (this.closeCmd != "close_invitations") {
                this._closeSubPanel()
                this.$events.$emit("open_invitations")
                this.closeCmd = "close_invitations"
            }
        },
        changeMode() {
            if (this.closed) {
                this._open()
            } else {
                this._close()
            }
        },
        _close() {
            this.$events.$emit("pull_window")
            document.getElementById("sidebar_cover").style.width = this.maxWidth + "px"
            setTimeout(() => {
                document.getElementById("switch").classList.add("fa", "fa-chevron-right")
                document.getElementById("switch").classList.remove("fa-chevron-left")
                document.getElementById("switch").blur()
                document.getElementById("sidebar").style.width = this.minWidth + "px"
                document.getElementById("sidebar_cover").style.width = this.minWidth + "px"
            }, 300)

            this.closed = true
        },
        _open() {
            this.$events.$emit("push_window")
            document.getElementById("sidebar").style.width = this.maxWidth + "px"
            document.getElementById("sidebar_cover").style.width = this.maxWidth + "px"
            setTimeout(() => {
                document.getElementById("switch").classList.add("fa", "fa-chevron-left")
                document.getElementById("switch").classList.remove("fa-chevron-right")
                document.getElementById("switch").blur()
                document.getElementById("sidebar_cover").style.width = "0px"
            }, 300);

            this.closed = false
        },
        _closeSubPanel() {
            if (this.closeCmd) {
                this.$events.$emit(this.closeCmd)
                this.$events.$emit("close_float_panel")
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
                this.openFriends()
            }, 500)
        }, 100)
    }
}
</script>

<style>

</style>
