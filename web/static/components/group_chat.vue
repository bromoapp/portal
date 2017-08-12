<template>
    <div v-if="panel_visible">
        <div id="gchat_dialog_panel_window" class="float-panel bg-455A64-s">
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
        <div id="gchat_dialog_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>
<script>
export default {
    data() {
        return {
            currCounterpart: null,
            height: "450px",
            maxWidth: "400px",
            panel_visible: false
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
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
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
