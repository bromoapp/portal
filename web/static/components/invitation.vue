<template>
    <div v-if="panel_visible">
        <div id="invit_detail_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="invit-detail">
                <div v-if="currInvit.type == 'FRIENDSHIP'">
                    <div style="background: black; width: 100%">
                        <div class="friend-image">
                            <img src="/images/profile.png">
                        </div>
                    </div>
                    <div class="friendship-invit-details">
                        <div>
                            <span style="font-weight: bold">
                                {{ currInvit.from_name }}
                            </span>
                        </div>
                        <div class="friend-status">
                            <p>{{ currInvit.msg }}</p>
                        </div>
                    </div>
                    <div style="text-align: center">
                        <button id="btn_accept_inv" class="btn bg-263238-d" v-on:click="acceptInvit">Accept</button>
                        <button id="btn_ignore_inv" class="btn bg-263238-d" v-on:click="rejectInvit">Reject</button>
                    </div>
                </div>
                <div style="text-align: center" v-else>
                    <div class="membership-invit-details">
                        <div>
                            <p>Would you like to join
                                <b>{{ currInvit.from_name }}</b> group?</p>
                        </div>
                    </div>
                    <div style="text-align: center">
                        <button id="btn_accept_inv" class="btn bg-263238-d" v-on:click="acceptInvit">Yes</button>
                        <button id="btn_ignore_inv" class="btn bg-263238-d" v-on:click="rejectInvit">No</button>
                    </div>
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
            friendInvitHeight: "350px",
            memberInvitHeight: "140px",
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
                    this._showFriendInvitDetails()
                }
            } else {
                this.currInvit = invit
                this._open()
            }
        },
        _close() {
            this.currInvit = null
            this.panel_visible = false
        },
        _open() {
            this.panel_visible = true
            setTimeout(() => {
                let panel = document.getElementById("invit_detail_panel_window")
                let cover = document.getElementById("invit_detail_panel_cover")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                if (this.currInvit.type == 'FRIENDSHIP') {
                    panel.style.height = this.friendInvitHeight
                    cover.style.height = this.friendInvitHeight
                } else {
                    panel.style.height = this.memberInvitHeight
                    cover.style.height = this.memberInvitHeight
                }
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
            }, 300)
        },
        acceptInvit() {
            if (this.currInvit.type == 'FRIENDSHIP') {
                this.$events.$emit(this.ADD_FRIEND_RESP, { id: this.currInvit.id, resp: this.Constant.INVIT_ACCEPT })
            } else {
                this.$events.$emit(this.ADD_GROUP_RESP, { id: this.currInvit.id, resp: this.Constant.INVIT_ACCEPT })
            }
            this._close()
        },
        rejectInvit() {
            if (this.currInvit.type == 'FRIENDSHIP') {
                this.$events.$emit(this.ADD_FRIEND_RESP, { id: this.currInvit.id, resp: this.Constant.INVIT_REJECT })
            } else {
                this.$events.$emit(this.ADD_GROUP_RESP, { id: this.currInvit.id, resp: this.Constant.INVIT_REJECT })
            }
            this._close()
        }
    }
}
</script>

<style>

</style>
