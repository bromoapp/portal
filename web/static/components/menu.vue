<template>
    <div v-if="panel_visible">
        <div id="menu_panel_window" class="float-panel bg-455A64-s">
            <ul style="margin: 0; padding: 0; list-style: none;">
                <li>
                    <div class="accordion-btn bg-263238-d">New chat</div>
                </li>
                <li>
                    <div class="accordion-btn bg-263238-d">New friend</div>
                </li>
                <li>
                    <div class="accordion-btn bg-263238-d">New group</div>
                </li>
                <li style="margin-top: 2px;" v-on:click="minimize">
                    <div class="accordion-btn bg-263238-d">Minimize</div>
                </li>
                <li v-on:click="signout">
                    <div class="accordion-btn bg-263238-d">Sign out</div>
                </li>
            </ul>
        </div>
        <div id="menu_panel_cover" class="float-panel bg-455A64-s"></div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            currFriend: null,
            height: "158px",
            maxWidth: "150px",
            panel_visible: false
        }
    },
    created() {
        this.$events.$on(this.CLOSE_FLOAT_PANEL, () => { this._closePanel() })
        this.$events.$on(this.SWITCH_MENU, () => { this._switchMenu() })
    },
    methods: {
        _closePanel() {
            if (this.panel_visible) {
                this._close()
            }
        },
        _switchMenu() {
            if (this.panel_visible) {
                this._close()
            } else {
                this._open()
            }
        },
        _close() {
            this.currFriend = null
            let cover = document.getElementById("menu_panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("menu_panel_window")
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
                let panel = document.getElementById("menu_panel_window")
                let cover = document.getElementById("menu_panel_cover")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
            }, 300)
        },
        signout() {
            let obj = {
                msg: "Do you really want to exit?",
                onYes: this.SIGN_OUT
            }
            this.$events.$emit(this.POP_QUESTION, obj)
        },
        minimize() {
            this._close()
            this.$events.$emit(this.MINIMIZE)
        }
    }
}
</script>

<style>

</style>
