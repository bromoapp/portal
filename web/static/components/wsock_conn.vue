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
        this.proxyChannel.on(this.INITIAL_UPDATES, (updates) => { this._onInitialUpdates(updates) })
        this.proxyChannel.on(this.FRIEND_ONLINE, (friend) => { this._onFriendOnline(friend) })
        this.proxyChannel.on(this.FRIEND_OFFLINE, (friend) => { this._onFriendOffline(friend) })
        this.proxyChannel.on(this.P2P_MSG_NEW, (msg) => { this._onP2pMsgNew(msg) })
        this.proxyChannel.on(this.P2P_MSG_IN, (msg) => { this._onP2pMsgIn(msg) })
        this.proxyChannel.join()
            .receive("ok", () => { /*console.log("Succeed to join proxy ch")*/ })
            .receive("error", () => { /*console.log("Failed to join proxy ch")*/ })

        this.roomChannel = this.socket.channel(roomChannelPrefix + this.user)
        this.roomChannel.join()
            .receive("ok", () => { /*console.log("Succeed to join room ch")*/ })
            .receive("error", () => { /*console.log("Failed to join room ch")*/ })

        this.sharedChannels.push(this.roomChannel)

        // Logout event handling
        this.$events.$on(this.SIGN_OUT, () => {
            if (this.proxyChannel) {
                this.proxyChannel.leave()
            }
            for (let x = 0; x < this.sharedChannels.length; x++) {
                let ch = this.sharedChannels[x]
                ch.leave()
            }
        })

        // P2p chat events handlers
        this.$events.$on(this.QUERY_CHATS, (chat) => {
            this.proxyChannel.push(this.QUERY_CHATS, { rec_id: chat.rec_id }).receive("ok", (resp) => {
                this.$events.$emit(this.UPDATE_CHAT_DATA, resp.query_chats_resp)
            })
        })
        this.$events.$on(this.P2P_MSG_OUT, (friend, message) => {
            this.proxyChannel.push(this.P2P_MSG_OUT, { to: friend.username, msg: message })
        })
    },
    methods: {
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
        }
    }
}
</script>

<style>

</style>
