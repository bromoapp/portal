<template>
    <div v-if="chat_dialog_visible">
        <div id="chat_dialog_panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 8px 10px">
                <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
        </div>
        <div id="chat_dialog_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            currUser: null,
            height: "55%",
            maxWidth: "400px",
            chat_dialog_visible: false
        }
    },
    created() {
        this.$events.$on("close_float_panel", () => {
            if (this.chat_dialog_visible) {
                this._close()
            }
        })
        this.$events.$on("switch_chat", (user) => {
            console.log(">>> CUR: " + this.currUser + "; USER: " + user)
            if (this.friend_detail_visible) {
                if (this.currUser == user) {
                    this._close()
                } else {
                    this.currUser = user
                }
            } else {
                this.currUser = user
                this._open()
            }
        })
    },
    methods: {
        _close() {
            this.currUser = null
            let cover = document.getElementById("chat_dialog_panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("chat_dialog_panel_window")
                panel.style.width = "0px"
                cover.style.width = "0px"
                setTimeout(() => {
                    this.chat_dialog_visible = false
                }, 300)
            }, 300)
        },
        _open() {
            this.chat_dialog_visible = true
            setTimeout(() => {
                this._showDetails()

                let panel = document.getElementById("chat_dialog_panel_window")
                let cover = document.getElementById("chat_dialog_panel_cover")
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
