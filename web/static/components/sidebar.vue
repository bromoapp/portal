<template>
    <div id="sidebar" class="sidebar bg-212121-s">
        <logout></logout>
        <div>
            <div class="sidebar-toolbar"><!--
                <div class="inline">
                    <button class="btn bg-37474f-d" title="Channels" id="btn_channels" v-on:click="openChannels">
                        <i class="fa fa-window-restore"></i>
                    </button>
                </div>-->
                <div class="inline">
                    <button class="btn bg-37474f-d" title="Friends" id="btn_friends" v-on:click="openFriends">
                        <i class="fa fa-user"></i>
                    </button>
                </div>
                <div class="inline">
                    <button class="btn bg-37474f-d" title="Groups" id="btn_groups" v-on:click="openGroups">
                        <i class="fa fa-users"></i>
                    </button>
                </div>
                <div class="inline">
                    <button class="btn bg-37474f-d" title="Chats" id="btn_chats" v-on:click="openChats">
                        <i class="fa fa-comments-o"></i>
                    </button>
                </div>
                <div class="inline">
                    <button class="btn bg-37474f-d" title="Notifications" id="btn_inivitations" v-on:click="openInvitations">
                        <i class="fa fa-envelope-o"></i>
                    </button>
                </div>
            </div>
            <button id="switch" class="btn bg-f50057-d sidebar-close-btn" v-on:click="openMenu">
            </button>
        </div>
        <div id="video_cam" class="video-cam">
            <webcam></webcam>
        </div>
        <invitations></invitations>
        <channels></channels>
        <friends></friends>
        <groups></groups>
        <chats></chats>
        <div id="sidebar_cover" class="sidebar-cover bg-212121-s"></div>
    </div>
</template>

<script>
import Chats from "./chats.vue"
import Logout from "./logout.vue"
import Webcam from "./webcam.vue"
import Groups from "./groups.vue"
import Friends from "./friends.vue"
import Channels from "./channels.vue"
import Invitations from "./invitations.vue"

let btnSignout, btnChannels, btnFriends
let btnChats, btnInvitations, btnGroups

export default {
    components: {
        Chats,
        Logout,
        Webcam,
        Groups,
        Friends,
        Channels,
        Invitations,
    },
    data() {
        return {
            maxWidth: this.$parent.maxWidth,
            minWidth: this.$parent.minWidth,
            closeCmd: null,
            closed: false,
        }
    },
    created() {
        this.$events.$on(this.Event.MINIMIZE, () => this._close())
        this.$events.$on(this.Event.START_CHAT, (friend) => { this.openChats(friend) })
        this.$events.$on(this.Event.START_GCHAT, (group) => { this.openGChats(group) })
        this.$events.$on(this.Event.HIGHLIGHT_CHATS_BTN, () => this._switchChatsBtn(true))
        this.$events.$on(this.Event.HIGHLIGHT_INVITS_BTN, () => this._switchInvitsBtn(true))
    },
    methods: {
        _switchInvitsBtn(mode) {
            let btn = document.getElementById("btn_inivitations")
            if (mode) {
                btn.classList.remove("bg-37474f-d")
                btn.classList.add("bg-highlight-d")
            } else {
                btn.classList.remove("bg-highlight-d")
                btn.classList.add("bg-37474f-d")
            }
        },
        _switchChatsBtn(mode) {
            let btn = document.getElementById("btn_chats")
            if (mode) {
                btn.classList.remove("bg-37474f-d")
                btn.classList.add("bg-highlight-d")
            } else {
                btn.classList.remove("bg-highlight-d")
                btn.classList.add("bg-37474f-d")
            }
        },
        _close() {
            this.$events.$emit(this.Event.PULL_WINDOW)
            document.getElementById("sidebar_cover").style.width = this.maxWidth + "px"
            setTimeout(() => {
                document.getElementById("switch").classList.add("fa", "fa-chevron-right")
                document.getElementById("switch").classList.remove("fa-bars")
                document.getElementById("switch").blur()
                document.getElementById("sidebar").style.width = this.minWidth + "px"
                document.getElementById("sidebar_cover").style.width = this.minWidth + "px"
            }, 300)

            this.closed = true
        },
        _open() {
            this.$events.$emit(this.Event.PUSH_WINDOW)
            document.getElementById("sidebar").style.width = this.maxWidth + "px"
            document.getElementById("sidebar_cover").style.width = this.maxWidth + "px"
            setTimeout(() => {
                document.getElementById("switch").classList.add("fa", "fa-bars")
                document.getElementById("switch").classList.remove("fa-chevron-right")
                document.getElementById("switch").blur()
                document.getElementById("sidebar_cover").style.width = "0px"
            }, 300);

            this.closed = false
        },
        _closeSubPanel() {
            if (this.closeCmd) {
                this.$events.$emit(this.closeCmd)
                this.$events.$emit(this.Event.CLOSE_FLOAT_PANEL)
            }
        },
        openChannels() {
            btnChannels.blur()
            if (this.closeCmd != this.Event.CLOSE_CHANNELS) {
                this._closeSubPanel()
                this.$events.$emit(this.Event.OPEN_CHANNELS)
                this.closeCmd = this.Event.CLOSE_CHANNELS
            }
        },
        openGroups() {
            btnGroups.blur()
            if (this.closeCmd != this.Event.CLOSE_GROUPS) {
                this._closeSubPanel()
                this.$events.$emit(this.Event.OPEN_GROUPS)
                this.closeCmd = this.Event.CLOSE_GROUPS
            }
        },
        openFriends() {
            btnFriends.blur()
            if (this.closeCmd != this.Event.CLOSE_FRIENDS) {
                this._closeSubPanel()
                this.$events.$emit(this.Event.OPEN_FRIENDS)
                this.closeCmd = this.Event.CLOSE_FRIENDS
            }
        },
        openChats(friend) {
            btnChats.blur()
            if (this.closeCmd != this.Event.CLOSE_CHATS) {
                this._switchChatsBtn(false)
                this._closeSubPanel()
                this.$events.$emit(this.Event.OPEN_CHATS, friend)
                this.closeCmd = this.Event.CLOSE_CHATS
            }
        },
        openGChats(group) {
            btnChats.blur()
            if (this.closeCmd != this.Event.CLOSE_CHATS) {
                this._switchChatsBtn(false)
                this._closeSubPanel()
                this.$events.$emit(this.Event.OPEN_GCHATS, group)
                this.closeCmd = this.Event.CLOSE_CHATS
            }
        },
        openInvitations() {
            btnInvitations.blur()
            if (this.closeCmd != this.Event.CLOSE_INVITATIONS) {
                this._switchInvitsBtn(false)
                this._closeSubPanel()
                this.$events.$emit(this.Event.OPEN_INVITATIONS)
                this.closeCmd = this.Event.CLOSE_INVITATIONS
            }
        },
        changeMode() {
            if (this.closed) {
                this._open()
            } else {
                this._close()
            }
        },
        openMenu() {
            document.getElementById("switch").blur()
            if (!this.closed) {
                this.$events.$emit(this.Event.SWITCH_MENU)
            } else {
                this._open()
            }
        }
    },
    mounted() {
        btnChats = document.getElementById("btn_chats")
        btnGroups = document.getElementById("btn_groups")
        btnFriends = document.getElementById("btn_friends")
        btnChannels = document.getElementById("btn_channels")
        btnInvitations = document.getElementById("btn_inivitations")

        setTimeout(() => {
            this._open()
            setTimeout(() => {
                // Open default panel
                this.openChats()
            }, 200)
        }, 100)
    }
}
</script>

<style>

</style>
