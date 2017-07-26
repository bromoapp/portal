<template>
    <div id="main_window" class="main-window" style="background-color: #E0E0E0" v-on:click="closeAll">
        <friend-detail></friend-detail>
        <invitation></invitation>
        <add-friend></add-friend>
        <add-group></add-group>
        <main-menu></main-menu>
        <chat></chat>
    </div>
</template>

<script>
import FriendDetail from "./friend_detail.vue"
import Invitation from "./invitation.vue"
import AddFriend from "./add_friend.vue"
import AddGroup from "./add_group.vue"
import MainMenu from "./menu.vue"
import Chat from "./chat.vue"

export default {
    components: {
        FriendDetail,
        Invitation,
        AddFriend,
        AddGroup,
        MainMenu,
        Chat
    },
    data() {
        return {
            maxLeftMargin: this.$parent.maxLeftMargin,
            minLeftMargin: this.$parent.minLeftMargin,
        }
    },
    created() {
        this.$events.$on(this.PUSH_WINDOW, () => { this._push() })
        this.$events.$on(this.PULL_WINDOW, () => { this._pull() })
    },
    methods: {
        closeAll(event) {
            if (event.target.id == "main_window") {
                this.$events.$emit(this.CLOSE_FLOAT_PANEL)
            }
        },
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
