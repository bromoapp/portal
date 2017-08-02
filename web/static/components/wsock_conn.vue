<template>
    <div>
    </div>
</template>

<script>
const proxyChannelPrefix = "user_proxy:"
const groupChannelPrefix = "user_group:"

export default {
    data() {
        return {
            proxyChannel: null,
            roomChannel: null,
            sharedChannels: [],
            user: this.$parent.user,
            socket: this.$parent.wsocket
        }
    },
    created() {
        this.socket.connect()
        this.proxyChannel = this.socket.channel(proxyChannelPrefix + this.user)

        // Events to/from server
        this.proxyChannel.on(this.FRIEND_NEW, (data) => { this._onFriendNew(data) })
        this.proxyChannel.on(this.FRIEND_ONLINE, (data) => { this._onFriendOnline(data) })
        this.proxyChannel.on(this.FRIEND_OFFLINE, (data) => { this._onFriendOffline(data) })
        this.proxyChannel.on(this.P2P_MSG_NEW, (data) => { this._onP2pMsgNew(data) })
        this.proxyChannel.on(this.P2P_MSG_IN, (data) => { this._onP2pMsgIn(data) })
        this.proxyChannel.on(this.ADD_FRIEND_IN, (data) => { this._onAddFriendIn(data) })
        this.proxyChannel.on(this.ADD_GROUP_IN, (data) => { this._onAddGroupIn(data) })
        this.proxyChannel.join()
            .receive("ok", (updates) => { this._onInitialUpdates(updates) })
            .receive("error", () => { /*console.log("Failed to join proxy ch")*/ })

        // Logout event handling
        this.$events.$on(this.SIGN_OUT, () => { this._onSignOut() })

        // P2p chat events handlers
        this.$events.$on(this.QUERY_CHATS, (conv) => { this._onQueryChats(conv) })
        this.$events.$on(this.P2P_MSG_OUT, (friend, message) => { this._onP2pMsgOut(friend, message) })
        this.$events.$on(this.ADD_FRIEND_OUT, (invit) => { this._onAddFriendOut(invit) })
        this.$events.$on(this.ADD_GROUP_OUT, (group) => { this._addGroupOut(group) })

        // Add friend events handlers
        this.$events.$on(this.DEL_UNREAD_REC, (id) => { this._onDelUnreadRec(id) })
        this.$events.$on(this.DEL_UNOPENED_REC, (id) => { this._onDelUnopenedRec(id) })
        this.$events.$on(this.ADD_FRIEND_RESP, (data) => { this._onAddFriendResp(data) })
        this.$events.$on(this.ADD_GROUP_RESP, (data) => { this._onAddGroupResp(data) })
    },
    methods: {
        _onAddGroupResp(data) {
            this.proxyChannel.push(this.ADD_GROUP_RESP, { id: data.id, resp: data.resp })
        },
        _onAddGroupIn(invit) {
            this.$events.$emit(this.ADD_GROUP_IN, invit)
        },
        _addGroupOut(group) {
            this.proxyChannel.push(this.ADD_GROUP_OUT, group)
        },
        _onAddFriendResp(data) {
            this.proxyChannel.push(this.ADD_FRIEND_RESP, { id: data.id, resp: data.resp })
        },
        _onDelUnreadRec(id) {
            this.proxyChannel.push(this.P2P_MSG_READ, { id: id })
        },
        _onDelUnopenedRec(id) {
            this.proxyChannel.push(this.INVIT_OPENED, { id: id })
        },
        _onAddFriendIn(invit) {
            this.$events.$emit(this.ADD_FRIEND_IN, invit)
        },
        _onAddFriendOut(invit) {
            this.proxyChannel.push(this.ADD_FRIEND_OUT, invit)
                .receive("ok", () => {
                    let obj = { msg: this.NOTIF_INVITATION_SENT }
                    this.$events.$emit(this.POP_INFO, obj)
                })
                .receive("error", (data) => {
                    let obj = { msg: data.msg }
                    this.$events.$emit(this.POP_ERROR, obj)
                })
        },
        _onInitialUpdates(updates) {
            console.log(">>> UPDATES", updates)
            this.$events.$emit(this.INITIAL_UPDATES, updates)
        },
        _onFriendNew(friend) {
            this.$events.$emit(this.FRIEND_NEW, friend)
        },
        _onFriendOnline(friend) {
            this.$events.$emit(this.FRIEND_ONLINE, friend)
        },
        _onFriendOffline(friend) {
            this.$events.$emit(this.FRIEND_OFFLINE, friend)
        },
        _onP2pMsgNew(msg) {
            this.$events.$emit(this.P2P_MSG_NEW, msg)
        },
        _onP2pMsgIn(msg) {
            this.$events.$emit(this.P2P_MSG_IN, msg)
        },
        _onSignOut() {
            if (this.proxyChannel) {
                this.proxyChannel.leave()
            }
            for (let x = 0; x < this.sharedChannels.length; x++) {
                let ch = this.sharedChannels[x]
                ch.leave()
            }
        },
        _onQueryChats(conv) {
            this.proxyChannel.push(this.QUERY_CHATS, { id: conv.id }).receive("ok", (resp) => {
                this.$events.$emit(this.UPDATE_CHAT_DATA, resp.query_chats_resp)
            })
        },
        _onP2pMsgOut(friend, message) {
            this.proxyChannel.push(this.P2P_MSG_OUT, { to: friend.username, msg: message }).receive("error", (data) => {
                let obj = {
                    msg: data.msg
                }
                this.$events.$emit(this.POP_ERROR, obj)
            })
        }
    }
}
</script>

<style>

</style>
