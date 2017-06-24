<template>
    <div v-if="panel_visible">
        <div id="panel_window" class="float-panel bg-455A64-s">
            <span class="pull-right" style="margin: 8px 10px">
                <a href="javascript:" class="cl-f50057-d" v-on:click="_close">
                    <i class="fa fa-close"></i>
                </a>
            </span>
            <div class="friend-profile">
                <div style="background: black; width: 100%">
                    <div class="friend-image">
                        <img src="/images/profile.png">
                    </div>
                </div>
                <div class="frind-details">
                    <div>
                        <label id="friend_name"></label>
                    </div>
                    <div style="font-size: 10px; ">45 mins ago</div>
                    <div class="friend-status">
                        <p> this is my status, how can I put this into words? Hello by the way! :) So lets hangout!</p>
                    </div>
                </div>
            </div>
        </div>
        <div id="panel_cover" class="float-panel-cover bg-455A64-s"></div>
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
            let cover = document.getElementById("panel_cover")
            cover.style.width = this.maxWidth

            setTimeout(() => {
                let panel = document.getElementById("panel_window")
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
                document.getElementById("friend_name").innerHTML = this.currUser.name

                let panel = document.getElementById("panel_window")
                let cover = document.getElementById("panel_cover")
                panel.style.width = this.maxWidth
                cover.style.width = this.maxWidth
                panel.style.height = this.height
                cover.style.height = this.height
                setTimeout(() => {
                    cover.style.width = "0px"
                }, 300);
            }, 300)
        }
    }
}
</script>

<style>

</style>
