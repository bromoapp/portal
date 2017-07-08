<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-d" v-on:click="seekFriend">
                Friends
                <a href="javascript:" style="color: white" class="btn">
                    <i id="header_btn" class="fa fa-chevron-down"></i>
                </a>
            </div>
            <div v-if="form_visible" id="seek_friend" class="bg-212121-s slide-in">
                <div style="margin: 0px 15px 0px 15px">
                    <span style="color: white">Search:</span>
                    <div class="form-inline">
                        <input id="search_args" class="form-control" type="text" placeholder="Name or email">
                        <a title="Invite" class="btn bg-1976D2-d">
                            <i class="fa fa-search"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div id="items_list" class="accordion-body">
                <ul>
                    <li v-for="friend in friends" v-bind:key="friend">
                        <div v-on:click="onFriendClicked(friend)" class="accordion-btn bg-263238-d">
                            <span>{{ friend.name }}</span>
                            <span v-if="friend.online" style="color: #ffb300" class="pull-right icon">
                                <i class="fa fa-user"></i>
                            </span>
                            <span v-else style="color: #000" class="pull-right icon">
                                <i class="fa fa-user"></i>
                            </span>
                        </div>
                    </li>
                    <li>
                        <div class="accordion-btn bg-263238-s">&nbsp;</div>
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
            form_visible: false,
            detailPanelWidth: 300
        }
    },
    created() {
        this.$events.$on(this.WINDOW_RESIZING, () => { this._onWindowResizing() })
        this.$events.$on(this.OPEN_FRIENDS, () => { this._openFriendsList() })
        this.$events.$on(this.CLOSE_FRIENDS, () => { this._closeFriendsList() })
        this.$events.$on(this.UPDATE_FRIENDS_LIST, (list) => { this._updateFriendsList(list) })
    },
    methods: {
        _onWindowResizing() {
            let body = document.getElementById("items_list")
            body.style.display = "none"
            setTimeout(() => {
                body.style.height = (window.innerHeight - this.TOP_MARGIN) + "px"
                body.style.overflowY = "auto"
                body.style.display = "block"
            }, 200)
        },
        _updateFriendsList(list) {
            this.friends = list
        },
        _closeFriendsList() {
            let body = document.getElementById("items_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
                this.form_visible = false
            }, 300)
        },
        _openFriendsList() {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("items_list")
                    body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                }, 200)
            }, 300)
        },
        onFriendClicked(friend) {
            this.$events.$emit(this.SWITCH_FRIEND_DETAIL, friend)
        },
        seekFriend() {
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

                    let inputEl = document.getElementById("search_args")
                    inputEl.focus()
                }, 200)
            }
        }
    }
}
</script>

<style>

</style>
