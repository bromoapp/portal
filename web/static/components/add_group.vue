<template>
    <div v-if="panel_visible">
        <div id="add_group_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div>
                <div class="float-panel-form">
                    <span style="color: white; font-weight: bold">Group's name:</span>
                    <input id="invite_args" class="form-control" type="text" placeholder="Group" style="margin-top: 3px; margin-bottom: 10px">
                    <span style="margin: 10px 0px; color: white; font-weight: bold">Members:</span>
                    <div id="names_list" style="margin-top: 3px; margin-bottom: 10px" class="accordion-body">
                        <ul style="margin: 0; padding: 0; list-style: none;">
                            <li v-for="f in friends" v-bind:key="f">
                                <div class="accordion-btn bg-37474f-d">
                                    <span>{{ f.name }}</span>
                                    <span class="pull-right" style="margin-right: 10px;">
                                        <input v-bind:id="'fid_' + f.id" v-on:click="onCheckboxClicked" type="checkbox">
                                    </span>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div style="text-align: center">
                        <a id="create_grp_btn" title="Create" v-on:click="createGroup" class="btn bg-263238-d">
                            Create
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div id="add_group_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            friends: [],
            height: "520px",
            maxWidth: "250px",
            panel_visible: false,
            listHeight: "341px",
            members: []
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_ADD_GROUP, () => { this._switchAddGroup() })
        this.$events.$on(this.SHOW_FRIENDS_LIST, (list) => { this._showFriendsList(list) })
    },
    methods: {
        _showFriendsList(list) {
            this.friends = list
        },
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _switchAddGroup() {
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
                let panel = document.getElementById("add_group_panel_window")
                let cover = document.getElementById("add_group_panel_cover")
                let list = document.getElementById("names_list")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                list.style.height = this.listHeight
                list.style.maxHeight = this.listHeight
                setTimeout(() => {
                    cover.style.width = "0px"
                    this.$events.$emit(this.GET_FRIENDS_LIST)
                }, 300);
            }, 300)
        },
        onCheckboxClicked(ev) {
            let id = ev.target.id.split("_")[1]
            if (ev.target.checked) {
                this.members.push(id)
            } else {
                let index = this.members.indexOf(id)
                this.members.splice(index, 1)
            }
        },
        createGroup() {
            let name = document.getElementById("invite_args").value
            let error = null
            if (name.length == 0) {
                error = { msg: this.ERROR_GROUP_NAME_EMPTY }
            } else {
                if (this.members.length == 0) {
                    error = { msg: this.ERROR_GROUP_MEMBERS_EMPTY }
                }
            }
            if (error) {
                this.$events.$emit(this.POP_ERROR, error)
            } else {
                let group = {
                    name: name,
                    members: this.members
                }
                this.$events.$emit(this.ADD_GROUP_OUT, group)
                this._close()
            }
        }
    }
}
</script>

<style>

</style>
