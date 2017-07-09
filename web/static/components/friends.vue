<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s">
                Friends
                <div class="accordion-header-btns">
                    <a title="Add new friend" id="add_friend_btn" href="javascript:" v-on:click="addFriend" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-user-plus"></i>
                    </a>
                    <a title="Search friend" id="src_friend_btn" href="javascript:" v-on:click="seekFriend" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                </div>
            </div>
            <div v-if="search_form_visible" id="seek_friend" class="bg-212121-s slide-in">
                <div style="margin: 0px 17px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Search friend:</span>
                    <input id="search_args" class="form-control" type="text" placeholder="Name">
                </div>
            </div>
            <div v-if="add_form_visible" id="add_friend" class="bg-212121-s slide-in">
                <div style="margin: 0px 15px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Friend's email:</span>
                    <div class="form-inline">
                        <input id="invite_args" class="form-control" type="text" placeholder="Email">
                        <a title="Send invitation" v-on:click="sendInvitation" class="btn bg-1976D2-d">
                            <i class="fa fa-send"></i>
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
            search_form_visible: false,
            add_form_visible: false,
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
            if (this.search_form_visible) {
                this.seekFriend()
            }
            this.$events.$emit(this.SWITCH_FRIEND_DETAIL, friend)
        },
        addFriend() {
            document.getElementById("add_friend_btn").blur()
            if (this.add_form_visible) {
                let div = document.getElementById("add_friend")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.add_form_visible = false
                }, 200)
            } else {
                if (this.search_form_visible) {
                    this.seekFriend()
                }
                setTimeout(() => {
                    this.add_form_visible = true
                    setTimeout(() => {
                        let div = document.getElementById("add_friend")
                        div.style.maxHeight = "100px"

                        let inputEl = document.getElementById("invite_args")
                        inputEl.focus()
                    }, 150)
                }, 150);
            }
        },
        sendInvitation() {
            document.getElementById("invite_args").value = ""
            this.addFriend()
        },
        seekFriend() {
            document.getElementById("src_friend_btn").blur()
            if (this.search_form_visible) {
                let div = document.getElementById("seek_friend")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.search_form_visible = false
                }, 200)
            } else {
                if (this.add_form_visible) {
                    this.addFriend()
                }
                setTimeout(() => {
                    this.search_form_visible = true
                    setTimeout(() => {
                        let div = document.getElementById("seek_friend")
                        div.style.maxHeight = "100px"

                        let inputEl = document.getElementById("search_args")
                        inputEl.focus()
                    }, 150)
                }, 150);
            }
        }
    }
}
</script>

<style>

</style>
