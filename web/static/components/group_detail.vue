<template>
    <div v-if="panel_visible">
        <div id="group_detail_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="float-panel-form">
                <span style="color: white; font-weight: bold">Group's name:</span>
                <input id="group_name" class="form-control" type="text" placeholder="Group" style="margin-top: 3px; margin-bottom: 10px" v-bind:value="currGroup.name">
                <span style="margin: 10px 0px; color: white; font-weight: bold">Members:</span>
                <div id="names_list" style="margin-top: 3px; margin-bottom: 10px" class="accordion-body">
                    <ul style="margin: 0; padding: 0; list-style: none;">
                        <li v-for="f in members" v-bind:key="f">
                            <div class="accordion-btn bg-37474f-d">
                                <span>{{ f.name }}</span>
                            </div>
                        </li>
                    </ul>
                </div>
                <div style="text-align: center">
                    <button id="btn_start_chat" class="btn bg-263238-d" v-on:click="startChat">Start Chat</button>
                </div>
            </div>
        </div>
        <div id="group_detail_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            currGroup: null,
            height: "520px",
            maxWidth: "250px",
            panel_visible: false,
            listHeight: "341px",
            members: []
        }
    },
    created() {
        this.$events.$on(this.Event.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.Event.SWITCH_GROUP_DETAIL, (group) => { this._switchGroupDetail(group) })
    },
    methods: {
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _switchGroupDetail(group) {
            if (this.panel_visible) {
                if (this.currGroup.unique == group.unique) {
                    this._close()
                } else {
                    this.currGroup = group
                    this.members = group.members
                }
            } else {
                this.currGroup = group
                this.members = group.members
                this._open()
            }
        },
        _close() {
            this.panel_visible = false
        },
        _open() {
            this.$events.$emit(this.Event.CLOSE_FLOAT_PANEL)
            this.panel_visible = true
            setTimeout(() => {
                let panel = document.getElementById("group_detail_panel_window")
                let cover = document.getElementById("group_detail_panel_cover")
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
            }, 300)
        },
        startChat(ev) {
            ev.target.blur()
        }
    }
}
</script>

<style>

</style>
