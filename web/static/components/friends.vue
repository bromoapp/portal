<template>
    <div v-if="visible">
        <div class="panel list-panel">
            <div class="panel-heading list-panel-header bg-f50057-s">
                Friends
            </div>
            <div id="friends_list" class="list-panel-body">
                <ul>
                    <li v-for="friend in friends">
                        <div class="list-panel-btn bg-263238-d">
                            <span>{{ friend.name }}</span>
                            <span class="pull-right" style="margin-right: 10px;">+</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            friends: [],
            visible: false
        }
    },
    methods: {
        
    },
    created() {
        this.$events.$on("open_friends", () => {
            this.visible = true
        })
        this.$events.$on("close_friends", () => {
            this.visible = false
        })
        this.$events.$on("on_friends_list_updates", (friends) => {
            this.friends = friends
        })
    }
}
</script>

<style>

</style>
