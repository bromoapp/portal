<template>
    <div v-if="panel_visible">
        <div id="panel_window" class="float-panel bg-37474f-s">
            <span class="pull-right" style="margin: 8px 10px">
                <a href="javascript:" class="cl-f50057-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div style="margin: 40px 20px;">
                <div style="text-align: center">
                    <img src="/images/profile.png">
                </div>
                <div class="friend-profile">
                    <div>
                        <label id="friend_name"></label>
                    </div>
                    <div>
                        <p style="font-size: 10px; ">45 mins ago</p>
                        <p> this is my status, how can I put this into words? Hello by the way! :) So lets hangout!</p>
                    </div>
                </div>
            </div>
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
            maxWidth: "250px",
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
                    this._close()
                } else {
                    // Retrieves user data
                    this.currUser = user
                    document.getElementById("friend_name").innerHTML = this.currUser.name
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
            document.getElementById("panel_window").style.width = "0px"
            setTimeout(() => {
                this.panel_visible = false
            }, 300)
        },
        _open() {
            this.panel_visible = true
            setTimeout(() => {
                document.getElementById("friend_name").innerHTML = this.currUser.name

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
