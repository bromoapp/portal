<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s">
                Chats
                <div class="accordion-header-btns">
                    <a v-if="counterparts.length == 0" title="Search chat" id="src_chat_btn" href="javascript:" class="btn bg-37474f-d">
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
                    <li v-for="counterpart in counterparts" v-bind:key="counterpart">
                        <div v-if="counterpart.unique == null" v-on:click="onChatClicked(counterpart)" class="accordion-btn bg-263238-d">
                            <span v-bind:id="'cpid_' + counterpart.id">{{ counterpart.name }}</span>
                            <span v-if="counterpart.online" style="color: #ffb300" class="pull-right icon">
                                <i class="fa fa-comment"></i>
                            </span>
                            <span v-else style="color: #37474f" class="pull-right icon">
                                <i class="fa fa-comment"></i>
                            </span>
                        </div>
                        <div v-else v-on:click="onGChatClicked(counterpart)" class="accordion-btn bg-263238-d">
                            <span v-bind:id="'gcpid_' + counterpart.id">{{ counterpart.name }}</span>
                            <span v-if="counterpart.online" style="color: #ffb300" class="pull-right icon">
                                <i class="fa fa-comment"></i>
                            </span>
                            <span v-else style="color: #37474f" class="pull-right icon">
                                <i class="fa fa-comment"></i>
                            </span>
                        </div>
                    </li>
                    <li v-if="counterparts.length > 2">
                        <div class="accordion-btn bg-212121-s">&nbsp;</div>
                    </li>
                    <li v-else>
                        <div style="height: 150px;" class="accordion-btn bg-212121-s">&nbsp;</div>
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
            currGroup: null,
            currFriend: null,
            counterparts: [],
            visible: false,
            src_form_visible: false,
        }
    },
    created() {
        this.$events.$on(this.Event.WINDOW_RESIZING, () => { this._onWindowResizing() })
        this.$events.$on(this.Event.CHAT_DATA_UPDATED, (data) => this._onChatDataUpdated(data))
        this.$events.$on(this.Event.OPEN_CHATS, (friend) => { this._openChatsList(friend) })
        this.$events.$on(this.Event.OPEN_GCHATS, (group) => { this._openChatsList(group) })
        this.$events.$on(this.Event.CLOSE_CHATS, () => { this._closeChatsList() })
        this.$events.$on(this.Event.CHAT_DIALOG_CLOSED, () => { this._onChatDialogClosed() })
        this.$events.$on(this.Event.GCHAT_DIALOG_CLOSED, () => { this._onGChatDialogClosed() })
        this.$events.$on(this.Event.UPDATE_CHATS_LIST, (list) => { this._updateChatsList(list) })
        this.$events.$on(this.Event.SHOW_UNREAD, (list) => { this._showUnread(list) })
    },
    methods: {
        _onChatDataUpdated(chat) {
            if (this.visible) {
                if (this.currFriend != null) {
                    if (this.currFriend.id == chat.counter_id) {
                        this.$events.$emit(this.Event.UPDATE_CHAT_DIALOG, chat)
                        this.$events.$emit(this.Event.DEL_UNREAD, chat.id)
                    } else {
                        this._setItemToUnread(chat.id, chat.counter_id, chat.type)
                    }
                } else if (this.currGroup != null) {
                    if (this.currGroup.id == chat.counter_id) {
                        this.$events.$emit(this.Event.UPDATE_GCHAT_DIALOG, chat)
                        this.$events.$emit(this.Event.DEL_UNREAD, chat.id)
                    } else {
                        this._setItemToUnread(chat.id, chat.counter_id, chat.type)
                    }
                } else {
                    this._setItemToUnread(chat.id, chat.counter_id, chat.type)
                }
            } else {
                this.$events.$emit(this.Event.HIGHLIGHT_CHATS_BTN)
                this._setItemToUnread(chat.id, chat.counter_id, chat.type)
            }
        },
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
            setTimeout(() => {
                if (this.visible) {
                    if (list.length > 0) {
                        for (let n = 0; n < list.length; n++) {
                            this._setItemToUnread(list[n].id, list[n].cid, list[n].type)
                        }
                    }
                } else {
                    this.$events.$emit(this.Event.HIGHLIGHT_CHATS_BTN)
                }
            }, 300);
        },
        _onChatDialogClosed() {
            this.currFriend = null
        },
        _onGChatDialogClosed() {
            this.currGroup = null
        },
        _setItemToUnread(id, cid, type) {
            console.log(">>> UNREAD " + type)
            if (type == "P2P") {
                setTimeout(() => {
                    this.$events.$emit(this.Event.ADD_UNREAD, { id: id, cid: cid })
                    let el = document.getElementById('cpid_' + cid)
                    if (el) {
                        el.innerHTML = this._getFriendName(cid) + " <i class=\"chat-new-msg fa fa-exclamation\"></i>"
                    }
                }, 200);
            } else {
                setTimeout(() => {
                    this.$events.$emit(this.Event.ADD_UNREAD, { id: id, cid: cid })
                    let el = document.getElementById('gcpid_' + cid)
                    if (el) {
                        el.innerHTML = this._getGroupName(cid) + " <i class=\"chat-new-msg fa fa-exclamation\"></i>"
                    }
                }, 200);
            }
        },
        _updateChatsList(list) {
            this.counterparts = list
        },
        _closeChatsList() {
            setTimeout(() => {
                this.visible = false
                this.src_form_visible = false
                this.$events.$emit(this.Event.GET_UNREAD)
            }, 300)
        },
        _openChatsList(counter) {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("items_list")
                    body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                    this.$events.$emit(this.Event.GET_UNREAD)

                    if (counter && counter.target == null) {
                        if (counter.members) {
                            this.currGroup = counter
                            this.$events.$emit(this.Event.SWITCH_GCHAT, this.currGroup)
                        } else {
                            this.currFriend = counter
                            this.$events.$emit(this.Event.SWITCH_CHAT, this.currFriend)
                        }
                    }
                }, 200)
            }, 300)
        },
        _getFriendName(id) {
            let friend = null
            for (let n = 0; n < this.counterparts.length; n++) {
                friend = this.counterparts[n]
                if (friend.id == id && friend.members == null) {
                    break
                }
            }
            if (friend) {
                return friend.name
            } else {
                return ""
            }
        },
        _getGroupName(id) {
            let group = null
            for (let n = 0; n < this.counterparts.length; n++) {
                group = this.counterparts[n]
                if (group.id == id && group.members != null) {
                    break
                }
            }
            if (group) {
                return group.name
            } else {
                return ""
            }
        },
        onChatClicked(friend) {
            if (this.src_form_visible) {
                this.seekChat()
            }
            this.currFriend = friend
            let el = document.getElementById('cpid_' + friend.id)
            if (el) {
                el.innerHTML = this._getFriendName(friend.id)
                this.$events.$emit(this.Event.DEL_UNREAD, friend.id)
            }
            this.$events.$emit(this.Event.SWITCH_CHAT, friend)
        },
        onGChatClicked(group) {
            if (this.src_form_visible) {
                this.seekChat()
            }
            this.currGroup = group
            let el = document.getElementById('gcpid_' + group.id)
            if (el) {
                el.innerHTML = this._getGroupName(group.id)
                this.$events.$emit(this.Event.DEL_UNREAD, group.id)
            }
            this.$events.$emit(this.Event.SWITCH_GCHAT, group)
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
