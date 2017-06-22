<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s" data="chats_list">
                Chats
                <a title="Add chats" href="javascript:" class="btn cl-f50057-d" v-on:click="addChat">
                    <i class="fa fa-plus-square"></i>
                </a>
            </div>
            <div id="chats_list" class="accordion-body">
                <ul>
                    <li v-for="chat in chats" v-bind:key="chat">
                        <div class="accordion-btn bg-263238-d">
                            <span>{{ chat }}</span>
                            <span class="pull-right" style="margin-right: 10px;">
                                <i class="fa fa-circle"></i>
                            </span>
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
            chats: ["Yunia Maharani", "Indra Birowo", "Aura Kasih", "Erwin Utomo"],
            visible: false
        }
    },
    methods: {
        addChat() {
            alert()
        }
    },
    created() {
        this.$events.$on("open_chats", () => {
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
        this.$events.$on("close_chats", () => {
            let el = document.getElementsByClassName("accordion-header")[0]
            let data = el.getAttribute("data")
            let body = document.getElementById(data)
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
            }, 300)
        })
        this.$events.$on("on_chats_list_updates", (chats) => {
            this.chats = chats
        })
    }
}
</script>

<style>

</style>
