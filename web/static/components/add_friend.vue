<template>
    <div v-if="panel_visible">
        <div id="add_friend_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="float-panel-form">
                <div>
                    <span style="color: white">Friend's email:</span>
                    <input id="invite_args" class="form-control" type="text" placeholder="Email" style="margin-bottom: 10px">
                    <span style="margin: 10px 0px; color: white;">Message:</span>
                    <div style="margin-bottom: 10px">
                        <textarea id="invite_msg" style="width: 230px; height: 50px; resize: none" rows="1" class="form-control" v-model="invit_msg"></textarea>
                    </div>
                    <div style="text-align: center">
                        <a id="send_invit_btn" title="Send invitation" v-on:click="sendInvitation" class="btn bg-263238-d">
                            Send request
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="add_friend_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            height: "230px",
            maxWidth: "250px",
            panel_visible: false,
            invit_msg: "Hi, can I be your friend?",
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_ADD_FRIEND, () => { this._switchAddFriend() })
    },
    methods: {
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _switchAddFriend() {
            if (this.panel_visible) {
                this._close()
            } else {
                this._open()
            }
        },
        _close() {
            this.panel_visible = false
        },
        _open() {
            this.$events.$emit(this.CLOSE_FLOAT_PANEL)
            this.panel_visible = true
            setTimeout(() => {
                let panel = document.getElementById("add_friend_panel_window")
                let cover = document.getElementById("add_friend_panel_cover")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
            }, 300)
        },
        _isFormatCorrect(data) {
            let re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(data);
        },
        sendInvitation() {
            document.getElementById("send_invit_btn").blur()
            let mailEL = document.getElementById("invite_args")
            let msgEl = document.getElementById("invite_msg")
            if (mailEL.value.length > 0) {
                let invit = { email: mailEL.value, msg: msgEl.value }
                if (this._isFormatCorrect(invit.email)) {
                    this.$events.$emit(this.ADD_FRIEND_OUT, invit)
                    this._close()
                    setTimeout(() => {
                        this.addFriend()
                        mailEL.value = ""
                        msgEl.value = this.invit_msg
                    }, 500);
                } else {
                    let obj = {
                        msg: "Invalid email format!",
                    }
                    this.$events.$emit(this.POP_ERROR, obj)
                }
            } else {
                let obj = {
                    msg: "Email cannot be empty!",
                }
                this.$events.$emit(this.POP_ERROR, obj)
            }
        },
    }
}
</script>

<style>

</style>
