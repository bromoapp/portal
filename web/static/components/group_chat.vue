<template>
    <div v-if="panel_visible">
        <div id="gchat_dialog_panel_window" class="float-panel bg-455A64-s">
            <div style="text-align: right; margin: 5px 10px 0px;">
                <span>
                    <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                        <i class="fa fa-close"></i>
                    </a>
                </span>
            </div>
            <div class="chat-wrapper">
                <div class="chat-area">
                    <div>
                        <label id="chat_to"></label>
                    </div>
                    <div>
                        <ul id="messages" class="chat-conversation"></ul>
                    </div>
                </div>
                <div class="chat-friends" style="margin-left: -25px;">
                    <span style="margin: 0px 0px; color: white; font-weight: bold">Online members:</span>
                    <div id="names_list" style="margin-top: 3px;" class="accordion-body">
                        <ul style="margin: 0; padding: 0; list-style: none; overflow-y: scroll;">
                            <li v-for="f in currCounterpart.members" v-bind:key="f">
                                <div class="accordion-btn bg-37474f-d">
                                    <div style="overflow: hidden; width: 110px; text-overflow: ellipsis">{{ f.name }}</div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="chat-toolbar inline">
                    <a title="Smiley" href="javascript:" class="btn btn-sm bg-263238-d" v-on:click="onSmiley">
                        <i class="fa fa-smile-o"></i>
                    </a>
                    <a title="Attachment" href="javascript:" class="btn btn-sm bg-263238-d" v-on:click="onAttachment">
                        <i class="fa fa-paperclip"></i>
                    </a>
                </div>
                <div class="chat-input form-inline">
                    <textarea id="message" class="chat-message form-control"></textarea>
                    <button class="btn bg-f50057-d">Send</button>
                </div>
            </div>
        </div>
        <div id="gchat_dialog_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>
<script>
export default {
    data() {
        return {
            username: null,
            currCounterpart: null,
            height: "450px",
            maxWidth: "580px",
            panel_visible: false,
            listHeight: "392px"
        }
    },
    created() {
        this.$events.$on(this.Event.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.Event.SWITCH_GCHAT, (group) => { this._switchGChat(group) })
        this.$events.$on(this.Event.UPDATE_GCHAT_DIALOG, (chat) => { this._updateChatDialog(chat) })
    },
    methods: {
        _updateChatDialog(chat) {
            if (this.panel_visible) {
                if (this.currCounterpart.id == chat.counter_id) {
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
                        if (obj.from == this.username) {
                            conv = conv + "<li><div style=\"margin: 15px 0px 15px 0px; text-align: right\">" +
                                "<div class=\"chat-bubble-me\" style=\"text-align: left\">" +
                                "<div style=\"font-size: 11px; font-weight: bold\">" + this.getMemberName(this.username) + "</div>" +
                                "<div>" + obj.message + "</div></div>" +
                                "</div></li>"
                        } else {
                            conv = conv + "<li><div style=\"margin: 15px 0px 15px 0px;\">" +
                                "<div class=\"chat-bubble\" style=\"text-align: left\">" + 
                                "<div style=\"font-size: 11px; font-weight: bold\">" + this.getMemberName(obj.from) + "</div>" +
                                "<div>" + obj.message + "</div></div>" +
                                "</div></li>"
                        }
                    }
                    conv = conv + "</div>"
                    let new_conv = old_conv + conv
                    conv_div.innerHTML = new_conv
                    conv_div.scrollTop = conv_div.scrollHeight;
                }
            }
        },
        _switchGChat(group) {
            if (this.panel_visible) {
                if (this.currCounterpart == group) {
                    this._close()
                } else {
                    this.currCounterpart = group
                    document.getElementById("messages").innerHTML = ""
                    document.getElementById("chat_to").innerHTML = "Group: " + this.currCounterpart.name
                    this.$events.$emit(this.Event.GET_GCHATS, this.currCounterpart)
                }
            } else {
                this.currCounterpart = group
                this._open()
            }
        },
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _close() {
            this.$events.$emit(this.Event.GCHAT_DIALOG_CLOSED)
            this.panel_visible = false
        },
        _open() {
            this.username = document.getElementById("lobby_div").getAttribute("data-username")
            this.$events.$emit(this.Event.CLOSE_FLOAT_PANEL)
            this.panel_visible = true
            setTimeout(() => {
                document.getElementById("chat_to").innerHTML = "Group: " + this.currCounterpart.name
                let panel = document.getElementById("gchat_dialog_panel_window")
                let cover = document.getElementById("gchat_dialog_panel_cover")
                let list = document.getElementById("names_list")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                list.style.height = this.listHeight
                list.style.maxHeight = this.listHeight
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);

                this.$events.$emit(this.Event.GET_GCHATS, this.currCounterpart)
            }, 300)
        },
        getMemberName(username) {
            let name = username
            for (let n = 0; n < this.currCounterpart.members.length; n++) {
                if (this.currCounterpart.members[n].username == username) {
                    name = this.currCounterpart.members[n].name
                    break
                }
            }
            return name
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
