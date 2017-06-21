<template>
  
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
        this.socket.connect()
        this.proxyChannel = this.socket.channel(proxyChannelPrefix + this.user)
        this.proxyChannel.on("user_updates", updates => this.onUpdatesAvail(updates))
        this.proxyChannel.join()
            .receive("ok", () => { console.log("Succeed to join proxy ch") })
            .receive("error", () => { console.log("Failed to join proxy ch") })

        this.roomChannel = this.socket.channel(roomChannelPrefix + this.user)
        this.roomChannel.join()
            .receive("ok", () => { console.log("Succeed to join room ch") })
            .receive("error", () => { console.log("Failed to join room ch") })

        this.sharedChannels.push(this.roomChannel)
    },
    methods: {
        onUpdatesAvail(updates) {
            this.$events.$emit("on_friends_list_updates", updates.friends)
        }
    }
}
</script>

<style>

</style>
