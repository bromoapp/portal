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
        this.$events.$on(this.INITIAL_UPDATES, (data) => { this._onInitialUpdates(data) })
        this.$events.$on(this.FRIEND_ONLINE, (data) => { this._onFriendOnline(data) })
        this.$events.$on(this.FRIEND_OFFLINE, (data) => { this._onFriendOffline(data) })
        this.$events.$on(this.GET_CHATS, (data) => { this._onGetChats(data) })
        this.$events.$on(this.UPDATE_CHAT_DATA, (data) => { this._onUpdateChatData(data) })
        this.$events.$on(this.P2P_MSG_NEW, (data) => { this._onP2pMsgNew(data) })
        this.$events.$on(this.P2P_MSG_IN, (data) => { this._onP2pMsgIn(data) })
    },
    methods: {
        _onP2pMsgIn(data) {
            let conv = this.tbl_chats.find({ "friend_id": data.friend_id })
            if (conv != null) {
                let chat = conv[(conv.length - 1)]
                if (chat.chats) {
                    chat.chats.push(data.chats[0])
                    this.$events.$emit(this.UPDATE_CHAT_DIALOG, chat)
                }
            }
        },
        _onP2pMsgNew(data) {
            this.tbl_chats.insert(data)
            let conv = this.tbl_chats.find({ 'rec_id': data.rec_id })
            this.$events.$emit(this.UPDATE_CHAT_DIALOG, conv[0])
        },
        _onUpdateChatData(data) {
            let conv = this.tbl_chats.find({ 'rec_id': data.rec_id })
            if (conv[0]) {
                conv[0].chats = data.chats
                conv[0].read = data.read
                conv[0].date = data.date
                this.$events.$emit(this.UPDATE_CHAT_DIALOG, conv[0])
            }
        },
        _onGetChats(data) {
            let convs = this.tbl_chats.find({ 'friend_id': data.id })
            for (let n = 0; n < convs.length; n++) {
                let conv = convs[n]
                if (conv.chats == null) {
                    this.$events.$emit(this.QUERY_CHATS, conv)
                } else {
                    this.$events.$emit(this.UPDATE_CHAT_DIALOG, conv)
                }
            }
        },
        _onFriendOffline(data) {
            let friend = this.tbl_friends.find({ 'id': data.id })
            friend[0].online = false
            this._updateFriendsList()
        },
        _onFriendOnline(data) {
            let friend = this.tbl_friends.find({ 'id': data.id })
            friend[0].online = true
            this._updateFriendsList()
        },
        _onInitialUpdates(data) {
            for (let n = 0; n < data.friends.length; n++) {
                let friend = data.friends[n]
                this.tbl_friends.insert(friend)
            }
            this._updateFriendsList()

            for (let n = 0; n < data.chats.length; n++) {
                let chat = data.chats[n]
                this.tbl_chats.insert(chat)
            }
            this._updateChatsList()
        },
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
        }
    }
}
</script>

<style>

</style>
