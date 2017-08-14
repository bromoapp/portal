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
                        <div id="messages" class="chat-conversation"></div>
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
                    <button class="btn bg-f50057-d" v-on:click="sendMessage">Send</button>
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
    },
    methods: {
        _switchGChat(group) {
            if (this.panel_visible) {
                if (this.currCounterpart == group) {
                    this._close()
                } else {
                    this.currCounterpart = group
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
            this.panel_visible = false
        },
        _open() {
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
