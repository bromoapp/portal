<template>
    <div v-if="panel_visible">
        <div id="friend_detail_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="float-panel-form">
                <div style="background: black; width: 100%">
                    <div class="friend-image">
                        <img src="/images/profile.png">
                    </div>
                </div>
                <div class="friend-details">
                    <div><span style="font-weight: bold" id="friend_name"></span></div>
                    <div style="font-size: 10px; margin-bottom: 5px;">
                        <span id="friend_uname"></span>
                    </div>
                    <div style="font-size: 10px; ">45 mins ago</div>
                    <div class="friend-status">
                        <p id="friend_status"></p>
                    </div>
                </div>
                <div style="text-align: center">
                    <div v-if="currFriend && currFriend.online">
                        <button id="btn_start_chat" class="btn bg-263238-d" v-on:click="startChat">Start Chat</button>
                    </div>
                    <div v-else>
                        <button id="btn_send_msg" class="btn bg-263238-d" v-on:click="sendMessage">Send Message</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="friend_detail_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            currFriend: null,
            height: "360px",
            maxWidth: "250px",
            panel_visible: false
        }
    },
    created() {
        this.$events.$on(this.Event.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.Event.SWITCH_FRIEND_DETAIL, (friend) => { this._switchFriendDetail(friend) })
    },
    methods: {
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _switchFriendDetail(friend) {
            if (this.panel_visible) {
                if (this.currFriend == friend) {
                    this._close()
                } else {
                    this.currFriend = friend
                    this._showDetails()
                }
            } else {
                this.currFriend = friend
                this._open()
            }
        },
        _close() {
            this.currFriend = null
            this.panel_visible = false
        },
        _open() {
            this.$events.$emit(this.Event.CLOSE_FLOAT_PANEL)
            this.panel_visible = true
            setTimeout(() => {
                this._showDetails()

                let panel = document.getElementById("friend_detail_panel_window")
                let cover = document.getElementById("friend_detail_panel_cover")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
            }, 300)
        },
        _showDetails() {
            document.getElementById("friend_name").innerHTML = this.currFriend.name
            document.getElementById("friend_uname").innerHTML = this.currFriend.username
            document.getElementById("friend_status").innerHTML = "Hi, this is my status and the only status that deserve tobe appreciate by anyone here :P"
        },
        startChat() {
            document.getElementById("btn_start_chat").blur()
            this.$events.$emit(this.Event.START_CHAT, this.currFriend)
        },
        sendMessage() {
            document.getElementById("btn_send_msg").blur()
            this.$events.$emit(this.Event.START_CHAT, this.currFriend)
        }
    }
}
</script>

<style>

</style>
