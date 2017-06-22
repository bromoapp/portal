<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-d" v-on:click="addChat">
                Chats
                <a title="Add chats" href="javascript:" class="btn cl-f50057-d">
                    <i id="header_btn" class="fa fa-chevron-down"></i>
                </a>
            </div>
            <div v-if="form_visible" id="seek_friend" class="bg-212121-s slide-in">
                <div style="margin-left: 15px">
                    <span style="color: white">New chat:</span>
                    <div class="form-inline">
                        <input id="friend_name" class="form-control" type="text" placeholder="Name">
                        <a title="Search" class="btn bg-1976D2-d">
                            <i class="fa fa-search"></i>
                        </a>
                    </div>
                </div>
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
            visible: false,
            form_visible: false
        }
    },
    methods: {
        addChat() {
            if (this.form_visible) {
                let div = document.getElementById("seek_friend")
                div.style.maxHeight = "0px"
                div.style.padding = "10px"
                setTimeout(() => {
                    this.form_visible = false
                    let btn = document.getElementById("header_btn")
                    btn.classList.remove("fa-chevron-up")
                    btn.classList.add("fa-chevron-down")
                }, 200)
            } else {
                this.form_visible = true
                setTimeout(() => {
                    let div = document.getElementById("seek_friend")
                    div.style.maxHeight = "80px"
                    div.style.padding = "10px"

                    let btn = document.getElementById("header_btn")
                    btn.classList.remove("fa-chevron-down")
                    btn.classList.add("fa-chevron-up")

                    let mail = document.getElementById("friend_name")
                    mail.focus()
                }, 200)
            }
        }
    },
    created() {
        this.$events.$on("open_chats", () => {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("chats_list")
                    body.style.maxHeight = "500px"
                }, 200)
            }, 300)
        })
        this.$events.$on("close_chats", () => {
            let body = document.getElementById("chats_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
                this.form_visible = false
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
