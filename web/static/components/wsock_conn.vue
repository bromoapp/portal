<template>
    <div>
    </div>
</template>

<script>
const proxyChannelPrefix = "user_proxy:"
const roomChannelPrefix = "user_room:"

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
        // Connecting to server
        this.socket.connect()
        this.proxyChannel = this.socket.channel(proxyChannelPrefix + this.user)
        this.proxyChannel.on(this.FRIEND_ONLINE, (friend) => { this._onFriendOnline(friend) })
        this.proxyChannel.on(this.FRIEND_OFFLINE, (friend) => { this._onFriendOffline(friend) })
        this.proxyChannel.on(this.P2P_MSG_NEW, (msg) => { this._onP2pMsgNew(msg) })
        this.proxyChannel.on(this.P2P_MSG_IN, (msg) => { this._onP2pMsgIn(msg) })
        this.proxyChannel.join()
            .receive("ok", (updates) => { this._onInitialUpdates(updates) })
            .receive("error", () => { /*console.log("Failed to join proxy ch")*/ })

        this.roomChannel = this.socket.channel(roomChannelPrefix + this.user)
        this.roomChannel.join()
            .receive("ok", () => { /*console.log("Succeed to join room ch")*/ })
            .receive("error", () => { /*console.log("Failed to join room ch")*/ })

        this.sharedChannels.push(this.roomChannel)

        // Logout event handling
        this.$events.$on(this.SIGN_OUT, () => { this._onSignOut() })

        // P2p chat events handlers
        this.$events.$on(this.QUERY_CHATS, (conv) => { this._onQueryChats(conv) })
        this.$events.$on(this.P2P_MSG_OUT, (friend, message) => { this._onP2pMsgOut(friend, message) })
        this.$events.$on(this.ADD_FRIEND_OUT, (email) => { this._onAddFriendOut(email) })
    },
    methods: {
        _onAddFriendOut(email) {
            this.proxyChannel.push(this.ADD_FRIEND_OUT, { email: email })
                .receive("ok", () => {
                    let obj = {
                        msg: "Invitation sent!"
                    }
                    this.$events.$emit(this.POP_INFO, obj)
                })
                .receive("error", (data) => {
                    let obj = {
                        msg: data.msg
                    }
                    this.$events.$emit(this.POP_ERROR, obj)
                })
        },
        _onInitialUpdates(updates) {
            this.$events.$emit(this.INITIAL_UPDATES, updates)
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
