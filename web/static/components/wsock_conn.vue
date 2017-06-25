<template>
    <div></div>
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
        this.proxyChannel.on("initial_updates", updates => this._onInitialUpdates(updates))
        this.proxyChannel.on("friend_online", friend => this._onFriendOnline(friend))
        this.proxyChannel.on("friend_offline", friend => this._onFriendOffline(friend))
        this.proxyChannel.join()
            .receive("ok", () => { console.log("Succeed to join proxy ch") })
            .receive("error", () => { console.log("Failed to join proxy ch") })

        this.roomChannel = this.socket.channel(roomChannelPrefix + this.user)
        this.roomChannel.join()
            .receive("ok", () => { console.log("Succeed to join room ch") })
            .receive("error", () => { console.log("Failed to join room ch") })

        this.sharedChannels.push(this.roomChannel)

        // Events handling
        this.$events.$on("sign_out", () => {
            if (this.proxyChannel) {
                this.proxyChannel.leave()
            }
            for (let x = 0; x < this.sharedChannels.length; x++) {
                let ch = this.sharedChannels[x]
                ch.leave()
            }
        })
    },
    methods: {
        _onInitialUpdates(updates) {
            this.$events.$emit("on_friends_list_updates", updates.friends)
        },
        _onFriendOnline(friend) {
            console.log(">>> ONLINE FRIEND = ", friend)
            this.$events.$emit("online_friend", friend)
        },
        _onFriendOffline(friend) {
            console.log(">>> OFFLINE FRIEND = ", friend)
            this.$events.$emit("offline_friend", friend)
        }
    }
}
</script>

<style>

</style>