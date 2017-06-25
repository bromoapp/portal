<template>
    <div v-if="friend_detail_visible">
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
                <div class="frind-details">
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
    openPanel() {
        alert()
    },
    data() {
        return {
            currUser: null,
            height: "55%",
            maxWidth: "250px",
            maxLeftMargin: this.$parent.maxLeftMargin,
            minLeftMargin: this.$parent.minLeftMargin,
            friend_detail_visible: false
        }
    },
    created() {
        this.$events.$on("close_float_panel", () => {
            if (this.friend_detail_visible) {
                this._close()
            }
        })
        this.$events.$on("switch_friend_detail", (user) => {
            console.log(">>> CUR: " + this.currUser + "; USER: " + user)
            if (this.friend_detail_visible) {
                if (this.currUser == user) {
                    this._close()
                } else {
                    this.currUser = user
                    this._showDetails()
                }
            } else {
                this.currUser = user
                this._open()
            }
        })
    },
    methods: {
        startChat() {
            document.getElementById("btn_start_chat").blur()
        },
        sendMessage() {
            document.getElementById("btn_send_msg").blur()
        },
        inivite2Room() {
            document.getElementById("btn_invite_2_room").blur()
        },
        _close() {
            this.currUser = null
            let cover = document.getElementById("friend_detail_panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("friend_detail_panel_window")
                panel.style.width = "0px"
                cover.style.width = "0px"
                setTimeout(() => {
                    this.friend_detail_visible = false
                }, 300)
            }, 300)
        },
        _open() {
            this.friend_detail_visible = true
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
            document.getElementById("friend_name").innerHTML = this.currUser.name
            document.getElementById("friend_status").innerHTML = "Hi, this is my status and the only status that deserve tobe appreciate by anyone here :P"
            if (this.currUser.online) {
                document.getElementById("online_friend_buttons").style.display = "inline"
                document.getElementById("offline_friend_buttons").style.display = "none"
            } else {
                document.getElementById("online_friend_buttons").style.display = "none"
                document.getElementById("offline_friend_buttons").style.display = "inline"
            }
        }
    }
}
</script>

<style>

</style>
