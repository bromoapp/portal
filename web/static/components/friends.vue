<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s" data="friends_list">
                Friends
                <a title="Add friend" href="javascript:" class="btn cl-f50057-d" v-on:click="addFriend">
                    <i class="fa fa-plus-square"></i>
                </a>
            </div>
            <div id="friends_list" class="accordion-body">
                <div id="add_friend" class="bg-212121-s form-inline text-center" style="padding: 10px">
                    <input class="form-control" type="text" placeholder="Email" />
                    <a title="Invite" class="btn bg-1976D2-d">
                        <i class="fa fa-envelope"></i>
                    </a>
                    <a href="javascript:" style="position: fixed; right: 15px; top: 16px">
                        <i class="fa fa-close"></i>
                    </a>
                </div>
                <ul>
                    <li v-for="friend in friends">
                        <div class="accordion-btn bg-263238-d">
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
let btnAddFriend

export default {
    data() {
        return {
            friends: [],
            visible: false
        }
    },
    methods: {
        addFriend() {
            alert()
        }
    },
    created() {
        this.$events.$on("open_friends", () => {
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
        this.$events.$on("close_friends", () => {
            let el = document.getElementsByClassName("accordion-header")[0]
            let data = el.getAttribute("data")
            let body = document.getElementById(data)
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
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
