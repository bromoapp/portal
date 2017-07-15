<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s">
                Invitations
                <div class="accordion-header-btns">
                    <a v-if="invitations.length == 0" href="javascript:" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                    <a v-else v-on:click="seekInvitation" href="javascript:" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                </div>
            </div>
            <div v-if="src_form_visible" id="seek_invitation" class="bg-212121-s slide-in">
                <div style="margin: 0px 17px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Name:</span>
                    <input id="search_args" class="form-control" type="text" placeholder="Name">
                </div>
            </div>
            <div id="items_list" class="accordion-body">
                <ul>
                    <li v-for="invit in invitations" v-bind:key="invit">
                        <div v-on:click="onInvitClicked(invit)" class="accordion-btn bg-263238-d">
                            <span v-bind:id="'inv_' + invit.id">{{ invit.from_name }}</span>
                            <span class="pull-right icon">
                                <i class="fa fa-envelope-o"></i>
                            </span>
                        </div>
                    </li>
                    <li v-if="invitations.length > 0">
                        <div class="accordion-btn bg-212121-s">&nbsp;</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            invitations: [],
            visible: false,
            src_form_visible: false
        }
    },
    created() {
        this.$events.$on(this.WINDOW_RESIZING, () => { this._onWindowResizing() })
        this.$events.$on(this.OPEN_INVITATIONS, () => { this._openInvitationsList() })
        this.$events.$on(this.SHOW_UNOPENED, (list) => { this._showUnopened(list) })
        this.$events.$on(this.CLOSE_INVITATIONS, () => { this._closeInvitationsList() })
        this.$events.$on(this.UPDATE_INVITATIONS_LIST, (list) => { this._updateInvitationsList(list) })
    },
    methods: {
        _onWindowResizing() {
            let body = document.getElementById("items_list")
            body.style.display = "none"
            setTimeout(() => {
                body.style.height = (window.innerHeight - this.TOP_MARGIN) + "px"
                body.style.overflowY = "auto"
                body.style.display = "block"
            }, 200)
        },
        _showUnopened(list) {
            setTimeout(() => {
                if (this.visible) {
                    if (list.length > 0) {
                        for (let n = 0; n < list.length; n++) {
                            this._setItemToUnopened(list[n].id)
                        }
                    }
                } else {
                    this.$events.$emit(this.HIGHLIGHT_INVITS_BTN)
                }
            }, 300);
        },
        _setItemToUnopened(id) {
            setTimeout(() => {
                this.$events.$emit(this.ADD_UNOPENED, id)
                let el = document.getElementById('inv_' + id)
                if (el) {
                    let oldval = el.innerHTML
                    el.innerHTML = oldval + " <i class=\"chat-new-msg fa fa-exclamation\"></i>"
                }
            }, 200);
        },
        _updateInvitationsList(list) {
            this.invitations = list
        },
        _closeInvitationsList() {
            let body = document.getElementById("items_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
                this.src_form_visible = false
                this.$events.$emit(this.GET_UNOPENED)
            }, 300)
        },
        _openInvitationsList() {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("items_list")
                    body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                    this.$events.$emit(this.GET_UNOPENED)
                }, 200)
            }, 300)
        },
        seekInvitation() {
            if (this.src_form_visible) {
                let div = document.getElementById("seek_invitation")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.src_form_visible = false
                }, 200)
            } else {
                this.src_form_visible = true
                setTimeout(() => {
                    let div = document.getElementById("seek_invitation")
                    div.style.maxHeight = "100px"

                    let name = document.getElementById("search_args")
                    name.focus()
                }, 200)
            }
        },
        onInvitClicked(invit) {
            if (this.src_form_visible) {
                this.seekInvitation()
            }
            this.$events.$emit(this.SWITCH_INVIT_DETAIL, invit)
        }
    }
}
</script>

<style>

</style>
