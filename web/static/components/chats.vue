<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s">
                Chats
                <div class="accordion-header-btns">
                    <a v-if="friends.length == 0" title="Search chat" id="src_chat_btn" href="javascript:" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                    <a v-else title="Search chat" id="src_chat_btn" href="javascript:" v-on:click="seekChat" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                </div>
            </div>
            <div v-if="src_form_visible" id="seek_chat" class="bg-212121-s slide-in">
                <div style="margin: 0px 17px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Search chat:</span>
                    <input id="search_args" class="form-control" type="text" placeholder="Name">
                </div>
            </div>
            <div id="items_list" class="accordion-body">
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
                    <li v-if="friends.length > 0">
                        <div id="form_cover" class="accordion-btn bg-212121-s">&nbsp;</div>
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
            src_form_visible: false
        }
    },
    created() {
        this.$events.$on(this.WINDOW_RESIZING, () => { this._onWindowResizing() })
        this.$events.$on(this.CHAT_DATA_UPDATED, (data) => this._onChatDataUpdated(data))
        this.$events.$on(this.OPEN_CHATS, (friend) => { this._openChatsList(friend) })
        this.$events.$on(this.CLOSE_CHATS, () => { this._closeChatsList() })
        this.$events.$on(this.CHAT_DIALOG_OPENED, (friend) => { this._onChatDialogOpened(friend) })
        this.$events.$on(this.CHAT_DIALOG_CLOSED, () => { this._onChatDialogClosed() })
        this.$events.$on(this.UPDATE_CHATS_LIST, (list) => { this._updateChatsList(list) })
        this.$events.$on(this.SHOW_UNREAD, (list) => { this._showUnread(list) })
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
        _showUnread(list) {
            if (this.visible) {
                setTimeout(() => {
                    if (list.length > 0) {
                        for (let n = 0; n < list.length; n++) {
                            this._setItemToUnread(list[n].id)
                        }
                    }
                }, 200);
            } else {
                this.$events.$emit(this.HIGHLIGHT_CHATS_BTN)
            }
        },
        _onChatDataUpdated(chat) {
            if (this.visible) {
                if (this.currFriend != null) {
                    if (this.currFriend.id == chat.friend_id) {
                        this.$events.$emit(this.UPDATE_CHAT_DIALOG, chat)
                    } else {
                        this._setItemToUnread(chat.friend_id)
                    }
                } else {
                    this._setItemToUnread(chat.friend_id)
                }
            } else {
                this.$events.$emit(this.HIGHLIGHT_CHATS_BTN)
                this._setItemToUnread(chat.friend_id)
            }
        },
        _onChatDialogOpened(friend) {
            this.currFriend = friend
            let el = document.getElementById(friend.id)
            if (el) {
                el.innerHTML = this._getFriendsName(friend.id)
                this.$events.$emit(this.DEL_UNREAD, friend.id)
            }
        },
        _onChatDialogClosed() {
            this.currFriend = null
        },
        _setItemToUnread(id) {
            setTimeout(() => {
                this.$events.$emit(this.ADD_UNREAD, id)
                let el = document.getElementById(id)
                if (el) {
                    el.innerHTML = this._getFriendsName(id) + " <i class=\"chat-new-msg fa fa-exclamation\"></i>"
                }
            }, 200);
        },
        _updateChatsList(list) {
            this.friends = list
        },
        _closeChatsList() {
            let body = document.getElementById("items_list")
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
                this.src_form_visible = false
                this.$events.$emit(this.GET_UNREAD)
            }, 300)
        },
        _openChatsList(friend) {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("items_list")
                    body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                    if (friend && friend.target == null) {
                        this.$events.$emit(this.SWITCH_CHAT, friend)
                    }
                }, 200)
                this.$events.$emit(this.GET_UNREAD)
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
            if (this.src_form_visible) {
                this.seekChat()
            }
            this.$events.$emit(this.SWITCH_CHAT, friend)
        },
        seekChat() {
            document.getElementById("src_chat_btn").blur()
            if (this.src_form_visible) {
                let div = document.getElementById("seek_chat")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.src_form_visible = false
                }, 200)
            } else {
                this.src_form_visible = true
                setTimeout(() => {
                    let div = document.getElementById("seek_chat")
                    div.style.maxHeight = "100px"

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
