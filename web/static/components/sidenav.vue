<template>
    <div id="side_nav" class="sidenav">
        <div>
            <div class="toolbar">
                <div class="toolbar-button">
                    <button title="Signout" id="btn_signout" class="btn btn-primary" v-on:click="signout">
                        <i class="fa fa-sign-out"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Settings" id="btn_settings" class="btn btn-primary" v-on:click="openSettings">
                        <i class="fa fa-gear"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Search" id="btn_search" class="btn btn-primary" v-on:click="openSearch">
                        <i class="fa fa-search"></i>
                    </button>
                </div>
                <div class="toolbar-button">
                    <button title="Messages" id="btn_messages" class="btn btn-primary" v-on:click="openInvitations">
                        <i class="fa fa-envelope-o"></i>
                    </button>
                </div>
            </div>
            <button id="switch" class="btn btn-danger closebtn" v-on:click="changeMode">
                <i class=""></i>
            </button>
        </div>
        <div id="video_cam" class="video-cam">
            <webcam></webcam>
        </div>
        <navgroup></navgroup>
        <div id="side_nav_cover" class="sidenav-cover"></div>
    </div>
</template>

<script>
import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Webcam from "./webcam.vue"
import Navgroup from "./navgroup.vue"

let btnSignout, btnSettings, btnSearch, btnMessages
let closed = false

export default {
    components: {
        Webcam,
        Navgroup
    },
    data() {
        return {
            maxWidth: this.$parent.maxWidth,
            minWidth: this.$parent.minWidth
        }
    },
    methods: {
        changeMode() {
            if (closed) {
                this._open()
            } else {
                this._close()
            }
        },
        signout() {
            btnSignout.blur()
            this.$events.$emit("sign_out")
        },
        openSettings() {
            btnSettings.blur()
            this.$events.$emit("open_settings")
        },
        openSearch() {
            btnSearch.blur()
            this.$events.$emit("open_search")
        },
        openInvitations() {
            btnMessages.blur()
            this.$events.$emit("open_invitations")
        },
        _close() {
            document.getElementById("side_nav").style.width = this.minWidth + "px"
            document.getElementById("side_nav_cover").style.width = this.minWidth + "px"
            setTimeout(function () {
                document.getElementById("switch").classList.add("fa", "fa-chevron-right")
                document.getElementById("switch").classList.remove("fa-chevron-left")
                document.getElementById("switch").blur()
            }, 250)

            closed = true
        },
        _open() {
            document.getElementById("side_nav").style.width = this.maxWidth + "px"
            document.getElementById("side_nav_cover").style.width = "0px"
            setTimeout(function () {
                document.getElementById("switch").classList.add("fa", "fa-chevron-left")
                document.getElementById("switch").classList.remove("fa-chevron-right")
                document.getElementById("switch").blur()
            }, 250);

            closed = false
        }
    },
    mounted() {
        btnSignout = document.getElementById("btn_signout")
        btnSettings = document.getElementById("btn_settings")
        btnSearch = document.getElementById("btn_search")
        btnMessages = document.getElementById("btn_messages")
        this._open()
    }
}
</script>

<style>

</style>
