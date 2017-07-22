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
                    <a title="Smiley" href="javascript:" class="btn btn-sm bg-263238-d" v-on:click="onSmiley">
                        <i class="fa fa-smile-o"></i>
                    </a>
                    <a title="Attachment" href="javascript:" class="btn btn-sm bg-263238-d" v-on:click="onAttachment">
                        <i class="fa fa-paperclip"></i>
                    </a>
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
            panel_visible: false,
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_CHAT, (friend) => { this._switchChat(friend) })
        this.$events.$on(this.UPDATE_CHAT_DIALOG, (chat) => { this._updateChatDialog(chat) })
    },
    methods: {
        _updateChatDialog(chat) {
            if (this.panel_visible) {
                if (this.currFriend.id == chat.friend_id) {
                    let oldConvDiv = document.getElementById("cid_" + chat.id)
                    if (oldConvDiv) {
                        var parent = oldConvDiv.parentNode
                        parent.removeChild(oldConvDiv)
                    }
                    let chats = chat.chats
                    let conv_div = document.getElementById("messages")
                    let old_conv = conv_div.innerHTML
                    let conv = "<div id=\"cid_" + chat.id + "\">"
                    conv = conv + "<div class=\"chat-separator\"><span>" + chat.date + "</span></div>"
                    for (let n = 0; n < chats.length; n++) {
                        let obj = chats[n]
                        if (obj.from == this.currFriend.username) {
                            conv = conv + "<div style=\"margin: 15px 0px 15px 0px;\"><div class=\"chat-bubble\" style=\"text-align: left\">" + obj.message + "</div></div>"
                        } else {
                            conv = conv + "<div style=\"margin: 15px 0px 15px 0px; text-align: right\"><div class=\"chat-bubble-me\" style=\"text-align: left\">" + obj.message + "</div></div>"
                        }
                    }
                    conv = conv + "</div>"
                    let new_conv = old_conv + conv
                    conv_div.innerHTML = new_conv
                    conv_div.scrollTop = conv_div.scrollHeight;
                }
            }
        },
        _switchChat(friend) {
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
        },
        _closePanel() {
            if (this.panel_visible) {
                this._close()
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
                    this.$events.$emit(this.CHAT_DIALOG_CLOSED)
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
        sendMessage(event) {
            event.target.blur()
            let msg_form = document.getElementById("message")
            let msg = msg_form.value
            if (msg.trim().length > 0) {
                this.$events.$emit(this.P2P_MSG_OUT, this.currFriend, msg)
            }
            msg_form.value = ""
        },
        onSmiley(event) {
            event.target.blur()
        },
        onAttachment(event) {
            event.target.blur()
        }
    }
}
</script>

<style>

</style>
