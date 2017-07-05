<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-d" v-on:click="seekInvitation">
                Invitations
                <a href="javascript:" style="color: white" class="btn">
                    <i id="header_btn" class="fa fa-chevron-down"></i>
                </a>
            </div>
            <div v-if="form_visible" id="seek_invitation" class="bg-212121-s slide-in">
                <div style="margin-left: 15px">
                    <span style="color: white">Search:</span>
                    <div class="form-inline">
                        <input id="search_args" class="form-control" type="text" placeholder="Name or email">
                        <a title="Search" class="btn bg-1976D2-d">
                            <i class="fa fa-search"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div id="invitations_list" class="accordion-body">
                <ul>
                    <li v-for="invit in invitations" v-bind:key="invit">
                        <div class="accordion-btn bg-263238-d">
                            <span>{{ invit }}</span>
                            <span class="pull-right icon">
                                <i class="fa fa-envelope-o"></i>
                            </span>
                        </div>
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
            invitations: ["Mulan Jameela", "Finka Ludianti", "Trianto Herhusodo", "Denis Hartanto", "Seno Partono"],
            visible: false,
            form_visible: false
        }
    },
    created() {
        this.$events.$on(this.OPEN_INVITATIONS, () => { this._openInvitationsList() })
        this.$events.$on(this.CLOSE_INVITATIONS, () => { this._closeInvitationsList() })
        this.$events.$on(this.UPDATE_INVITATIONS_LIST, (list) => { this._updateInvitationsList(list) })
    },
    methods: {
        _updateInvitationsList(list) {
            this.invitations = list
        },
        _openInvitationsList() {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("invitations_list")
                    body.style.maxHeight = "500px"
                }, 200)
            }, 300)
        },
        _closeInvitationsList() {
            let body = document.getElementById("invitations_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
            }, 300)
        },
        seekInvitation() {
            if (this.form_visible) {
                let div = document.getElementById("seek_invitation")
                div.style.maxHeight = "0px"
                div.style.padding = "10px"
                setTimeout(() => {
                    this.form_visible = false
                    let btn = document.getElementById("header_btn")
                    btn.classList.remove("fa-chevron-up")
                    btn.classList.add("fa-chevron-down")
                }, 200)
            } else {
                this.form_visible = true
                setTimeout(() => {
                    let div = document.getElementById("seek_invitation")
                    div.style.maxHeight = "80px"
                    div.style.padding = "10px"

                    let btn = document.getElementById("header_btn")
                    btn.classList.remove("fa-chevron-down")
                    btn.classList.add("fa-chevron-up")

                    let name = document.getElementById("channel_name")
                    name.focus()
                }, 200)
            }
        }
    }
}
</script>

<style>

</style>
