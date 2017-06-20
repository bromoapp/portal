<template>
    <div id="chats_panel" v-if="visible">
        <div class="panel list-panel">
            <div class="panel-heading list-panel-header bg-f50057-s">
                Chats
            </div>
            <div id="chats_list" class="list-panel-body">
                <ul>
                    <li v-for="chat in chats">
                        <div class="list-panel-btn bg-263238-d">
                            <span>{{ chat.with }}</span>
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
            chats: [],
            visible: false
        }
    },
    methods: {
        
    },
    created() {
        this.$events.$on("open_chats", () => {
            this.visible = true
        })
        this.$events.$on("close_chats", () => {
            this.visible = false
        })
        this.$events.$on("on_chats_list_updates", (chats) => {
            this.chats = chats
        })
    }
}
</script>

<style>

</style>
