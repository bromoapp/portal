<template>
    <div v-if="panel_visible">
        <div id="chat_dialog_panel_window" class="float-panel bg-455A64-s">
            <div class="chat-dialog">
                <div style="text-align: right">
                    <span>
                        <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                            <i class="fa fa-close"></i>
                        </a>
                    </span>
                </div>
                <div>
                    <label id="chat_to"></label>
                </div>
                <div>
                    <div id="messages" class="chat-conversation"></div>
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
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => {
            if (this.panel_visible) {
                this._close()
            }
        })
        this.$events.$on(this.SWITCH_CHAT, (friend) => {
            if (this.panel_visible) {
                if (this.currFriend == friend) {
                    this._close()
                } else {
                    this.currFriend = friend
                    document.getElementById("messages").innerHTML = ""
                    document.getElementById("chat_to").innerHTML = "To: " + this.currFriend.name
                    this.$events.$emit(this.GET_CHATS, this.currFriend)
                }
            } else {
                this.currFriend = friend
                this._open()
            }
        })
        this.$events.$on(this.UPDATE_CHAT_DIALOG, (chat) => {
            if (this.panel_visible) {
                if (this.currFriend.id == chat.friend_id) {
                    let oldConvDiv = document.getElementById(chat.date)
                    if (oldConvDiv) {
                        var parent = oldConvDiv.parentNode
                        parent.removeChild(oldConvDiv)
                    }
                    let chats = chat.chats
                    let conv_div = document.getElementById("messages")
                    let old_conv = conv_div.innerHTML
                    let conv = "<div id=\"" + chat.date + "\">"
                    conv = conv + "<div class=\"chat-separator\"><span>" + chat.date + "</span></div>"
                    for (let n = 0; n < chats.length; n++) {
                        let obj = chats[n]
                        if (obj.from == this.currFriend.username) {
                            conv = conv + "<div style=\"margin: 8px 0px 8px 0px;\"><span class=\"chat-bubble\">" + obj.message + "</span></div>"
                        } else {
                            conv = conv + "<div style=\"margin: 8px 0px 8px 0px; text-align: right\"><span class=\"chat-bubble-me\">" + obj.message + "</span></div>"
                        }
                    }
                    conv = conv + "</div>"
                    conv = old_conv + conv
                    conv_div.innerHTML = conv
                    conv_div.scrollTop = conv_div.scrollHeight;
                } else {
                    this.$events.$emit(this.NEW_P2P_MSG, chat)
                }
            } else {
                this.$events.$emit(this.NEW_P2P_MSG, chat)
            }
        })
    },
    methods: {
        sendMessage() {
            let msg_form = document.getElementById("message")
            let msg = msg_form.value
            this.$events.$emit(this.P2P_MSG_OUT, this.currFriend, msg)
            msg_form.value = ""
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

                this.$events.$emit(this.GET_CHATS, this.currFriend)
            }, 300)
        },
    }
}
</script>

<style>

</style>
