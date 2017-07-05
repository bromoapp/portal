<template>
    <div v-if="panel_visible">
        <div id="friend_detail_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 8px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="friend-profile">
                <div style="background: black; width: 100%">
                    <div class="friend-image">
                        <img src="/images/profile.png">
                    </div>
                </div>
                <div class="friend-details">
                    <div>
                        <label id="friend_name"></label>
                    </div>
                    <div style="font-size: 10px; ">45 mins ago</div>
                    <div class="friend-status">
                        <p id="friend_status"></p>
                    </div>
                </div>
                <div style="text-align: center">
                    <div id="offline_friend_buttons">
                        <button id="btn_send_msg" class="btn bg-263238-d" v-on:click="sendMessage">Send Message</button>
                    </div>
                    <div id="online_friend_buttons">
                        <button id="btn_start_chat" class="btn bg-263238-d" v-on:click="startChat">Start Chat</button>
                        <button id="btn_invite_2_room" class="btn bg-263238-d" v-on:click="inivite2Room">Invite to Room</button>
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
            height: "350px",
            maxWidth: "250px",
            panel_visible: false
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_FRIEND_DETAIL, (friend) => { this._switchFriendDetail(friend) })
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
            let cover = document.getElementById("friend_detail_panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("friend_detail_panel_window")
                panel.style.width = "0px"
                cover.style.width = "0px"
                setTimeout(() => {
                    this.panel_visible = false
                }, 300)
            }, 300)
        },
        _open() {
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
            document.getElementById("friend_status").innerHTML = "Hi, this is my status and the only status that deserve tobe appreciate by anyone here :P"
            if (this.currFriend.online) {
                document.getElementById("online_friend_buttons").style.display = "inline"
                document.getElementById("offline_friend_buttons").style.display = "none"
            } else {
                document.getElementById("online_friend_buttons").style.display = "none"
                document.getElementById("offline_friend_buttons").style.display = "inline"
            }
        },
        startChat() {
            document.getElementById("btn_start_chat").blur()
            this.$events.$emit(this.START_CHAT, this.currFriend)
        },
        sendMessage() {
            document.getElementById("btn_send_msg").blur()
        },
        inivite2Room() {
            document.getElementById("btn_invite_2_room").blur()
        }
    }
}
</script>

<style>

</style>
