<template>
    <div></div>
</template>

<script>
import Vue from 'vue'
import VueEvents from 'vue-events'
import { Presence } from "phoenix"

Vue.use(VueEvents)

const proxyChannelPrefix = "user_proxy:"
const groupChannelPrefix = "user_group:"

export default {
    data() {
        return {
            proxyChannel: null,
            roomChannel: null,
            groupChats: [],
            user: this.$parent.user,
            socket: this.$parent.wsocket
        }
    },
    created() {
        this.socket.connect()
        this.proxyChannel = this.socket.channel(proxyChannelPrefix + this.user)

        // Events to/from server
        this.proxyChannel.on(this.Event.FRIEND_NEW, (data) => { this._onFriendNew(data) })
        this.proxyChannel.on(this.Event.FRIEND_ONLINE, (data) => { this._onFriendOnline(data) })
        this.proxyChannel.on(this.Event.FRIEND_OFFLINE, (data) => { this._onFriendOffline(data) })
        this.proxyChannel.on(this.Event.P2P_MSG_NEW, (data) => { this._onP2pMsgNew(data) })
        this.proxyChannel.on(this.Event.P2P_MSG_IN, (data) => { this._onP2pMsgIn(data) })
        this.proxyChannel.on(this.Event.ADD_FRIEND_IN, (data) => { this._onAddFriendIn(data) })
        this.proxyChannel.on(this.Event.ADD_GROUP_IN, (data) => { this._onAddGroupIn(data) })
        this.proxyChannel.on(this.Event.GROUP_NEW, (data) => { this._onGroupNew(data) })
        this.proxyChannel.on(this.Event.GROUP_UPDATE, (data) => { this._onGroupUpdate(data) })

        this.proxyChannel.join()
            .receive("ok", (updates) => { this._onInitialUpdates(updates) })
            .receive("error", () => { /*console.log("Failed to join proxy ch")*/ })

        // Logout event handling
        this.$events.$on(this.Event.SIGN_OUT, () => { this._onSignOut() })

        // P2p chat events handlers
        this.$events.$on(this.Event.QUERY_CHATS, (conv) => { this._onQueryChats(conv) })
        this.$events.$on(this.Event.P2P_MSG_OUT, (friend, message) => { this._onP2pMsgOut(friend, message) })
        this.$events.$on(this.Event.ADD_FRIEND_OUT, (invit) => { this._onAddFriendOut(invit) })
        this.$events.$on(this.Event.ADD_GROUP_OUT, (group) => { this._addGroupOut(group) })

        // Group chat related events handlers
        this.$events.$on(this.Event.JOIN_GROUP, (group) => { this._joinGroupChat(group) })

        // Add friend events handlers
        this.$events.$on(this.Event.DEL_UNREAD_REC, (id) => { this._onDelUnreadRec(id) })
        this.$events.$on(this.Event.DEL_UNOPENED_REC, (id) => { this._onDelUnopenedRec(id) })
        this.$events.$on(this.Event.ADD_FRIEND_RESP, (data) => { this._onAddFriendResp(data) })
        this.$events.$on(this.Event.ADD_GROUP_RESP, (data) => { this._onAddGroupResp(data) })
    },
    methods: {
        _joinGroupChat(object) {
            let groupChannel = this.socket.channel(groupChannelPrefix + object.unique)
            let groupChat = new Vue({
                data: {
                    group: object,
                    channel: groupChannel,
                    presences: {}
                },
                methods: {
                    init() {
                        this.channel.on(this.Event.ONLINE_MEMBERS, (data) => { this._onOnlineMembers(this.group, data) })
                        this.channel.on(this.Event.P2G_MSG_NEW, (data) => { this._onP2gMessageNew(this.group, data) })
                        this.channel.on(this.Event.P2G_MSG_IN, (data) => { this._onP2gMessageIn(this.group, data) })
                        this.channel.on(this.Event.PRESENCE_STATE, state => {
                            this.presences = Presence.syncState(this.presences, state)
                            console.log(">>> PRESENCES", this.presences)
                        })

                        this.channel.on(this.Event.PRESENCE_DIFF, diff => {
                            this.presences = Presence.syncDiff(this.presences, diff)
                            console.log(">>> PRESENCES", this.presences)
                        })

                        this.channel.join()
                            .receive("ok", (updates) => { this._onGroupInitialUpdates(updates) })
                            .receive("error", () => { console.log("Failed to join user group channel") })
                    },
                    sendP2gMessageOut(group, data) {

                    },
                    _onGroupInitialUpdates(updates) {
                        console.log(">>> GROUP INITIAL UPDATES", updates)
                    },
                    _onOnlineMembers(group, data) {
                        console.log("ONLINE: ", data)
                    },
                    _onP2gMessageNew(group, data) {

                    },
                    _onP2gMessageIn(group, data) {

                    }
                }
            })
            groupChat.init()

            this.groupChats.push(groupChat)
        },
        _onGroupNew(group) {
            console.log(">>> NEW GROUP: ", group)
            this.$events.$emit(this.Event.GROUP_NEW, group)
        },
        _onGroupUpdate(group) {
            console.log(">>> GROUP UPDATE: ", group)
            this.$events.$emit(this.Event.GROUP_UPDATE, group)
        },
        _onAddGroupResp(data) {
            this.proxyChannel.push(this.Event.ADD_GROUP_RESP, { id: data.id, resp: data.resp })
        },
        _onAddGroupIn(invit) {
            this.$events.$emit(this.Event.ADD_GROUP_IN, invit)
        },
        _addGroupOut(group) {
            this.proxyChannel.push(this.Event.ADD_GROUP_OUT, group)
        },
        _onAddFriendResp(data) {
            this.proxyChannel.push(this.Event.ADD_FRIEND_RESP, { id: data.id, resp: data.resp })
        },
        _onDelUnreadRec(id) {
            this.proxyChannel.push(this.Event.P2P_MSG_READ, { id: id })
        },
        _onDelUnopenedRec(id) {
            this.proxyChannel.push(this.Event.INVIT_OPENED, { id: id })
        },
        _onAddFriendIn(invit) {
            this.$events.$emit(this.Event.ADD_FRIEND_IN, invit)
        },
        _onAddFriendOut(invit) {
            this.proxyChannel.push(this.Event.ADD_FRIEND_OUT, invit)
                .receive("ok", () => {
                    let obj = { msg: this.Message.NOTIF_INVITATION_SENT }
                    this.$events.$emit(this.Event.POP_INFO, obj)
                })
                .receive("error", (data) => {
                    let obj = { msg: data.msg }
                    this.$events.$emit(this.Event.POP_ERROR, obj)
                })
        },
        _onInitialUpdates(updates) {
            this.$events.$emit(this.Event.INITIAL_UPDATES, updates)
        },
        _onFriendNew(friend) {
            this.$events.$emit(this.Event.FRIEND_NEW, friend)
        },
        _onFriendOnline(friend) {
            this.$events.$emit(this.Event.FRIEND_ONLINE, friend)
        },
        _onFriendOffline(friend) {
            this.$events.$emit(this.Event.FRIEND_OFFLINE, friend)
        },
        _onP2pMsgNew(msg) {
            this.$events.$emit(this.Event.P2P_MSG_NEW, msg)
        },
        _onP2pMsgIn(msg) {
            this.$events.$emit(this.Event.P2P_MSG_IN, msg)
        },
        _onSignOut() {
            if (this.proxyChannel) {
                this.proxyChannel.leave()
            }
            for (let x = 0; x < this.groupChats.length; x++) {
                let ch = this.groupChats[x]
                ch.leave()
            }
        },
        _onQueryChats(conv) {
            this.proxyChannel.push(this.Event.QUERY_CHATS, { id: conv.id }).receive("ok", (resp) => {
                this.$events.$emit(this.Event.UPDATE_CHAT_DATA, resp.query_chats_resp)
            })
        },
        _onP2pMsgOut(friend, message) {
            this.proxyChannel.push(this.Event.P2P_MSG_OUT, { to: friend.username, msg: message }).receive("error", (data) => {
                let obj = {
                    msg: data.msg
                }
                this.$events.$emit(this.Event.POP_ERROR, obj)
            })
        }
    }
}
</script>

<style>

</style>
