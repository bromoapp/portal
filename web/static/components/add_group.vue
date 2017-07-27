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
                            <li v-for="friend in friends" v-bind:key="friend">
                                <div class="accordion-btn bg-37474f-d">
                                    <span>{{ friend }}</span>
                                    <span class="pull-right" style="margin-right: 10px;">
                                        <input type="checkbox">
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
            friends: [
                "Bromo Kunto Adji", "Bromo Kunto Adji", "Bromo Kunto Adji",
                "Bromo Kunto Adji", "Bromo Kunto Adji", "Bromo Kunto Adji",
            ],
            height: "520px",
            maxWidth: "250px",
            panel_visible: false,
            listHeight: "341px"
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_ADD_GROUP, () => { this._switchAddGroup() })
    },
    methods: {
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
                }, 300);
            }, 300)
        },
    }
}
</script>

<style>

</style>
