<template>
    <div v-if="panel_visible">
        <div id="invit_detail_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="invit-detail">
                <div style="background: black; width: 100%">
                    <div class="friend-image">
                        <img src="/images/profile.png">
                    </div>
                </div>
                <div class="invit-details">
                    <div>
                        <label id="friend_name"></label>
                    </div>
                    <div class="friend-status">
                        <p id="friend_message"></p>
                    </div>
                </div>
                <div style="text-align: center">
                    <button id="btn_accept_inv" class="btn bg-263238-d" v-on:click="acceptInvit">Accept</button>
                    <button id="btn_ignore_inv" class="btn bg-263238-d" v-on:click="rejectInvit">Reject</button>
                </div>
            </div>
        </div>
        <div id="invit_detail_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            currInvit: null,
            height: "350px",
            maxWidth: "250px",
            panel_visible: false,
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_INVIT_DETAIL, (invit) => { this._switchInvitDetail(invit) })
    },
    methods: {
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _switchInvitDetail(invit) {
            console.log(invit)
            if (this.panel_visible) {
                if (this.currInvit == invit) {
                    this._close()
                } else {
                    this.currInvit = invit
                    this._showDetails()
                }
            } else {
                this.currInvit = invit
                this._open()
            }
        },
        _close() {
            this.currInvit = null
            let cover = document.getElementById("invit_detail_panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("invit_detail_panel_window")
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

                let panel = document.getElementById("invit_detail_panel_window")
                let cover = document.getElementById("invit_detail_panel_cover")
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
            document.getElementById("friend_name").innerHTML = this.currInvit.from_name
            document.getElementById("friend_message").innerHTML = this.currInvit.msg
        },
        acceptInvit() {
            this.$events.$emit(this.ADD_FRIEND_RESP, { id: this.currInvit.id, resp: this.Constant.INVIT_ACCEPT })
            this._close()
        },
        rejectInvit() {
            this.$events.$emit(this.ADD_FRIEND_RESP, { id: this.currInvit.id, resp: this.Constant.INVIT_REJECT })
            this._close()
        }
    }
}
</script>

<style>

</style>
