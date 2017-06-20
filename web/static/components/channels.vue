<template>
    <div id="channels_panel" v-if="visible">
        <div class="panel list-panel">
            <div class="panel-heading list-panel-header bg-f50057-s">
                Channels
            </div>
            <div id="channels_list" class="list-panel-body">
                <ul>
                    <li v-for="ch in channels">
                        <div class="list-panel-btn bg-263238-d">
                            <span>{{ ch.name }}</span>
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
            channels: [],
            visible: false
        }
    },
    methods: {
        
    },
    created() {
        this.$events.$on("open_channels", () => {
            this.visible = true
        })
        this.$events.$on("close_channels", () => {
            this.visible = false
        })
        this.$events.$on("on_channels_list_updates", (channels) => {
            this.channels = channels
        })
    }
}
</script>

<style>

</style>
