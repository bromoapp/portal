<template>
    <div id="main_window" class="main-window lobby-body">
        <chat></chat>
        <friend-detail></friend-detail>
    </div>
</template>

<script>
import FriendDetail from "./friend_detail.vue"
import Chat from "./chat.vue"

export default {
    components: {
        FriendDetail,
        Chat
    },
    data() {
        return {
            maxLeftMargin: this.$parent.maxLeftMargin,
            minLeftMargin: this.$parent.minLeftMargin,
        }
    },
    created() {
        this.$events.$on(this.PUSH_WINDOW, () => {
            this._push()
        })
        this.$events.$on(this.PULL_WINDOW, () => {
            this._pull()
        })
    },
    methods: {
        _push() {
            document.getElementById("main_window").style.marginLeft = this.maxLeftMargin + "px"
        },
        _pull() {
            setTimeout(() => {
                document.getElementById("main_window").style.marginLeft = this.minLeftMargin + "px"
            }, 300)
        }
    }
}
</script>

<style>

</style>
