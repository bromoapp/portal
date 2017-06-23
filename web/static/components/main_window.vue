<template>
    <div id="main_window" class="main-window lobby-body">
        <friend-detail></friend-detail>
    </div>
</template>

<script>
import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import FriendDetail from "./friend_detail.vue"

export default {
    components: {
        FriendDetail
    },
    data() {
        return {
            maxLeftMargin: this.$parent.maxLeftMargin,
            minLeftMargin: this.$parent.minLeftMargin,
        }
    },
    created() {
        this.$events.$on("push_window", () => {
            this._push()
        })
        this.$events.$on("pull_window", () => {
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
