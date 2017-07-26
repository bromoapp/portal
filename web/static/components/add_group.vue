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
                    <span style="color: white">Group's name:</span>
                    <input id="invite_args" class="form-control" type="text" placeholder="Group" style="margin-bottom: 10px">
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
            height: "100%",
            maxWidth: "250px",
            panel_visible: false,
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
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
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
