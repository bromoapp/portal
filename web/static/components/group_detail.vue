<template>
    <div v-if="panel_visible">
        <div id="group_detail_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 6px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="float-panel-form">
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
                }
            } else {
                this.currGroup = group
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
                //let list = document.getElementById("names_list")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                //list.style.height = this.listHeight
                //list.style.maxHeight = this.listHeight
                setTimeout(() => {
                    cover.style.width = "0px"
                    //this.$events.$emit(this.Event.GET_FRIENDS_LIST)
                }, 300);
            }, 300)
        },
    }
}
</script>

<style>

</style>
