<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-d" v-on:click="addFriend">
                Friends
                <a title="Add friend" href="javascript:" class="btn cl-f50057-d">
                    <i id="header_btn" class="fa fa-chevron-down"></i>
                </a>
            </div>
            <div v-if="form_visible" id="add_friend" class="bg-212121-s slide-in">
                <div style="margin-left: 15px">
                    <span style="color: white">New friend:</span>
                    <div class="form-inline">
                        <input id="friend_email" class="form-control" type="text" placeholder="Email">
                        <a title="Invite" class="btn bg-1976D2-d">
                            <i class="fa fa-search"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div id="friends_list" class="accordion-body">
                <ul>
                    <li v-for="friend in friends" v-bind:key="friend">
                        <div class="accordion-btn bg-263238-d">
                            <span>{{ friend.name }}</span>
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
let closed = true

export default {
    data() {
        return {
            friends: [],
            visible: false,
            form_visible: false
        }
    },
    methods: {
        addFriend() {
            if (this.form_visible) {
                let div = document.getElementById("add_friend")
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
                    let div = document.getElementById("add_friend")
                    div.style.maxHeight = "80px"
                    div.style.padding = "10px"

                    let btn = document.getElementById("header_btn")
                    btn.classList.remove("fa-chevron-down")
                    btn.classList.add("fa-chevron-up")

                    let mail = document.getElementById("friend_email")
                    mail.focus()
                }, 200)
            }
        }
    },
    created() {
        this.$events.$on("open_friends", () => {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("friends_list")
                    body.style.maxHeight = "500px"
                }, 200)
            }, 300)
        })
        this.$events.$on("close_friends", () => {
            let body = document.getElementById("friends_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
                this.form_visible = false
            }, 300)
        })
        this.$events.$on("on_friends_list_updates", (friends) => {
            this.friends = friends
        })
    }
}
</script>

<style>

</style>
