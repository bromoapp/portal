<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s" data="channels_list">
                Channels
                <a title="Add channel" href="javascript:" class="btn cl-f50057-d" v-on:click="addChannel">
                    <i class="fa fa-plus-square"></i>
                </a>
            </div>
            <div id="channels_list" class="accordion-body">
                <ul>
                    <li v-for="ch in channels" v-bind:key="ch">
                        <div class="accordion-btn bg-263238-d">
                            <span>{{ ch }}</span>
                            <span class="pull-right" style="margin-right: 10px;">+</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            channels: ["Classic 90's Songs", "Classic Balads", "Tiesto Concert", "Double Six Bali"],
            visible: false
        }
    },
    methods: {
        addChannel() {
            alert()
        }
    },
    created() {
        this.$events.$on("open_channels", () => {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let el = document.getElementsByClassName("accordion-header")[0]
                    let data = el.getAttribute("data")
                    let body = document.getElementById(data)
                    body.style.maxHeight = "500px"
                }, 200)
            }, 300)
        })
        this.$events.$on("close_channels", () => {
            let el = document.getElementsByClassName("accordion-header")[0]
            let data = el.getAttribute("data")
            let body = document.getElementById(data)
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
            }, 300)
        })
        this.$events.$on("on_channels_list_updates", (channels) => {
            this.channels = channels
        })
    }
}
</script>

<style>

</style>
