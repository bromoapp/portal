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
                    <li v-for="friend in friends" v-bind:key="friend">
                        <div v-on:click="onChatClicked(friend)" class="accordion-btn bg-263238-d">
                            <span v-bind:id="friend.id">{{ friend.name }}</span>
                            <span v-if="friend.online" style="color: #ffb300" class="pull-right icon">
                                <i class="fa fa-comment"></i>
                            </span>
                            <span v-else style="color: #000" class="pull-right icon">
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
            currFriend: null,
            friends: [],
            visible: false,
            form_visible: false
        }
    },
    created() {
        this.$events.$on(this.CHAT_DATA_UPDATED, (data) => this._onChatDataUpdated(data))
        this.$events.$on(this.OPEN_CHATS, (friend) => { this._openChatsList(friend) })
        this.$events.$on(this.CLOSE_CHATS, () => { this._closeChatsList() })
        this.$events.$on(this.CHAT_DIALOG_OPENED, (friend) => { this._onChatDialogOpened(friend) })
        this.$events.$on(this.CHAT_DIALOG_CLOSED, () => { this._onChatDialogClosed() })
        this.$events.$on(this.UPDATE_CHATS_LIST, (list) => { this._updateChatsList(list) })
    },
    methods: {
        _onChatDataUpdated(chat) {
            if (this.currFriend != null) {
                if (this.currFriend.id == chat.friend_id) {
                    this.$events.$emit(this.UPDATE_CHAT_DIALOG, chat)
                } else {
                    setTimeout(() => {
                        let el = document.getElementById(chat.friend_id)
                        if (el) {
                            el.innerHTML = this._getFriendsName(chat.friend_id) + " <i class=\"chat-new-msg fa fa-exclamation\"></i>"
                        }
                    }, 200);
                }
            } else {
                setTimeout(() => {
                    let el = document.getElementById(chat.friend_id)
                    if (el) {
                        el.innerHTML = this._getFriendsName(chat.friend_id) + " <i class=\"chat-new-msg fa fa-exclamation\"></i>"
                    }
                }, 200);
            }
        },
        _onChatDialogOpened(friend) {
            this.currFriend = friend
            let el = document.getElementById(friend.id)
            if (el) {
                el.innerHTML = this._getFriendsName(friend.id)
            }
        },
        _onChatDialogClosed() {
            this.currFriend = null
        },
        _updateChatsList(list) {
            this.friends = list
        },
        _closeChatsList() {
            let body = document.getElementById("chats_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
                this.form_visible = false
            }, 300)
        },
        _openChatsList(friend) {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("chats_list")
                    body.style.maxHeight = "500px"
                    if (friend && friend.target == null) {
                        this.$events.$emit(this.SWITCH_CHAT, friend)
                    }
                }, 200)
            }, 300)
        },
        _getFriendsName(id) {
            let friend = null
            for (let n = 0; n < this.friends.length; n++) {
                friend = this.friends[n]
                if (friend.id == id) {
                    break
                }
            }
            if (friend) {
                return friend.name
            } else {
                return ""
            }
        },
        onChatClicked(friend) {
            this.$events.$emit(this.SWITCH_CHAT, friend)
        },
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

                    let mail = document.getElementById("search_args")
                    mail.focus()
                }, 200)
            }
        }
    }
}
</script>

<style>

</style>
