<template>
    <div v-if="panel_visible">
        <div id="menu_panel_window" class="float-panel bg-455A64-s">
            <ul style="margin: 0; padding: 0; list-style: none;">
                <li v-on:click="newChat">
                    <div class="accordion-btn bg-37474f-d">New chat</div>
                </li>
                <li v-on:click="newFriend">
                    <div class="accordion-btn bg-37474f-d">New friend</div>
                </li>
                <li v-on:click="newGroup">
                    <div class="accordion-btn bg-37474f-d">New group</div>
                </li>
                <li style="margin-top: 2px;" v-on:click="settings">
                    <div class="accordion-btn bg-37474f-d">Settings</div>
                </li>
                <li v-on:click="minimize">
                    <div class="accordion-btn bg-37474f-d">Minimize</div>
                </li>
                <li v-on:click="signout">
                    <div class="accordion-btn bg-37474f-d">Sign out</div>
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
            height: "190px",
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
            this.panel_visible = false
        },
        _open() {
            this.$events.$emit(this.CLOSE_FLOAT_PANEL)
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
            this.panel_visible = false
            let obj = {
                msg: "Do you really want to exit?",
                onYes: this.SIGN_OUT
            }
            this.$events.$emit(this.POP_QUESTION, obj)
        },
        minimize() {
            this.panel_visible = false
            this.$events.$emit(this.MINIMIZE)
        },
        settings() {
            this.panel_visible = false
        },
        newChat() { 
            this.panel_visible = false
        },
        newFriend() { 
            this.panel_visible = false
            this.$events.$emit(this.SWITCH_ADD_FRIEND)
        },
        newGroup() { 
            this.panel_visible = false
        }
    }
}
</script>

<style>

</style>
