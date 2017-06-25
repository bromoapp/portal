<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-d" v-on:click="seekChat">
                Chats
                <a title="Add chats" href="javascript:" style="color: white" class="btn">
                    <i id="header_btn" class="fa fa-chevron-down"></i>
                </a>
            </div>
            <div v-if="form_visible" id="seek_chat" class="bg-212121-s slide-in">
                <div style="margin-left: 15px">
                    <span style="color: white">Search:</span>
                    <div class="form-inline">
                        <input id="search_args" class="form-control" type="text" placeholder="Name or email">
                        <a title="Search" class="btn bg-1976D2-d">
                            <i class="fa fa-search"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div id="chats_list" class="accordion-body">
                <ul>
                    <li v-for="chat in chats" v-bind:key="chat">
                        <div v-on:click="onChatClicked(chat)" class="accordion-btn bg-263238-d">
                            <span>{{ chat }}</span>
                            <span class="pull-right icon">
                                <i class="fa fa-comment"></i>
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
        seekChat() {
            if (this.form_visible) {
                let div = document.getElementById("seek_chat")
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
                    let div = document.getElementById("seek_chat")
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
