<template>
    <div v-if="panel_visible">
        <div id="panel_window" class="float-panel" style="background-color: #37474f; text-align: center; color: white">
            <h3>Opening {{ currUser }}</h3>
        </div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            currUser: null,
            height: "100%",
            maxWidth: "400px",
            maxLeftMargin: this.$parent.maxLeftMargin,
            minLeftMargin: this.$parent.minLeftMargin,
            panel_visible: false
        }
    },
    created() {
        this.$events.$on("switch_friend_detail", (user) => {
            console.log(">>> CUR: " + this.currUser + "; USER: " + user)
            if (this.panel_visible) {
                if (this.currUser == user) {
                    this.currUser = null
                    this._close()
                } else {
                    // Retrieves user data
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
            document.getElementById("panel_window").style.width = "0px"
            setTimeout(() => {
                this.panel_visible = false
            }, 300)
        },
        _open() {
            this.panel_visible = true
            setTimeout(() => {
                let panel = document.getElementById("panel_window")
                panel.style.width = this.maxWidth
                panel.style.height = this.height
            }, 300)
        }
    }
}
</script>

<style>

</style>
