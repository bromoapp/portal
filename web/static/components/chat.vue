<template>
    <div v-if="panel_visible">
        <div id="chat_dialog_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 8px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="chat-dialog">
                <div>
                    <label id="chat_to"></label>
                </div>
                <div>
                    <div class="chat-conversation" disabled></div>
                </div>
                <div class="inline">
                    <a href="javascript:" class="btn btn-sm bg-263238-d">Hello</a>
                    <a href="javascript:" class="btn btn-sm bg-263238-d">Hello</a>
                    <a href="javascript:" class="btn btn-sm bg-263238-d">Hello</a>
                </div>
                <div class="form-inline">
                    <textarea id="message" class="chat-message form-control"></textarea>
                    <button class="btn bg-f50057-d" v-on:click="sendMessage">Send</button>
                </div>
            </div>
        </div>
        <div id="chat_dialog_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            currFriend: null,
            height: "450px",
            maxWidth: "400px",
            panel_visible: false
        }
    },
    created() {
        this.$events.$on("close_float_panel", () => {
            if (this.panel_visible) {
                this._close()
            }
        })
        this.$events.$on("switch_chat", (friend) => {
            if (this.panel_visible) {
                if (this.currFriend == friend) {
                    this._close()
                } else {
                    this.currFriend = friend
                    document.getElementById("chat_to").innerHTML = "To: " + this.currFriend.name
                }
            } else {
                this.currFriend = friend
                this._open()
            }
        })
    },
    methods: {
        sendMessage() {
            let msg = document.getElementById("message").value
            if (this.currFriend.online) {
                this.$events.$emit("send_online_p2p_msg", this.currFriend, msg)
            } else {
                this.$events.$emit("send_offline_p2p_msg", this.currFriend, msg)
            }
        },
        _close() {
            this.currFriend = null
            let cover = document.getElementById("chat_dialog_panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("chat_dialog_panel_window")
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
                document.getElementById("chat_to").innerHTML = "To: " + this.currFriend.name
                let panel = document.getElementById("chat_dialog_panel_window")
                let cover = document.getElementById("chat_dialog_panel_cover")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
            }, 300)
        },
    }
}
</script>

<style>

</style>
