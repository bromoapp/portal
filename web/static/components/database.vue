<template>
    <div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            db: this.$parent.db,
            tbl_friends: null,
            tbl_chats: null
        }
    },
    created() {
        this.tbl_friends = this.db.addCollection('friends')
        this.tbl_chats = this.db.addCollection('chats')

        // Insert or update database events handlers
        this.$events.$on(this.INITIAL_UPDATES, (updates) => {
            for (let n = 0; n < updates.friends.length; n++) {
                let friend = updates.friends[n]
                this.tbl_friends.insert(friend)
            }
            this._updateFriendsList()

            for (let n = 0; n < updates.chats.length; n++) {
                let chat = updates.chats[n]
                this.tbl_chats.insert(chat)
            }
            this._updateChatsList()
        })

        this.$events.$on(this.FRIEND_ONLINE, (data) => {
            let friend = this.tbl_friends.find({ 'id': data.id })
            friend[0].online = true
            this._updateFriendsList()
        })

        this.$events.$on(this.FRIEND_OFFLINE, (data) => {
            let friend = this.tbl_friends.find({ 'id': data.id })
            friend[0].online = false
            this._updateFriendsList()
        })

        this.$events.$on(this.GET_CHATS, (data) => {
            let chats = this.tbl_chats.find({ 'friend_id': data.id })
            for (let n = 0; n < chats.length; n++) {
                let chat = chats[n]
                console.log(">>> CHAT ", chat)
                if (chat.chats == null) {
                    this.$events.$emit(this.QUERY_CHATS, chat)
                } else {
                    this.$events.$emit(this.UPDATE_CHAT_DIALOG, chat)
                }
            }
        })
    },
    methods: {
        _updateFriendsList() {
            let friends = this.tbl_friends.where((o) => {
                return o.name != null
            })
            this.$events.$emit(this.UPDATE_FRIENDS_LIST, friends)
        },
        _updateChatsList() {
            let raw = this.tbl_chats.where((o) => {
                return o.friend_id != null
            })
            let chats = []
            for (let n = 0; n < raw.length; n++) {
                let friend = this.tbl_friends.find({ 'id': raw[n].friend_id })
                if (!chats.includes(friend[0])) {
                    chats.push(friend[0])
                }
            }
            this.$events.$emit(this.UPDATE_CHATS_LIST, chats)
        },
    }
}
</script>

<style>

</style>
