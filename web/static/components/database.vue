<template>
    <div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            db: this.$parent.db,
            tbl_chats: null,
            tbl_invits: null,
            tbl_friends: null,
            tbl_unreads: null,
        }
    },
    created() {
        this.tbl_chats = this.db.addCollection('chats')
        this.tbl_invits = this.db.addCollection('invits')
        this.tbl_friends = this.db.addCollection('friends')
        this.tbl_unreads = this.db.addCollection('unreads')

        // Insert or update database events handlers
        this.$events.$on(this.INITIAL_UPDATES, (data) => { this._onInitialUpdates(data) })
        this.$events.$on(this.FRIEND_ONLINE, (data) => { this._onFriendOnline(data) })
        this.$events.$on(this.FRIEND_OFFLINE, (data) => { this._onFriendOffline(data) })
        this.$events.$on(this.GET_CHATS, (data) => { this._onGetChats(data) })
        this.$events.$on(this.UPDATE_CHAT_DATA, (data) => { this._onUpdateChatData(data) })
        this.$events.$on(this.P2P_MSG_NEW, (data) => { this._onP2pMsgNew(data) })
        this.$events.$on(this.P2P_MSG_IN, (data) => { this._onP2pMsgIn(data) })
        this.$events.$on(this.ADD_UNREAD, (data) => { this._onAddUnread(data) })
        this.$events.$on(this.GET_UNREADS, () => { this._onGetUnreads() })
        this.$events.$on(this.DEL_UNREAD, (data) => { this._onDelUnread(data) })
    },
    methods: {
        _onDelUnread(data) {
            this.tbl_unreads.findAndRemove({ "id": data })
        },
        _onGetUnreads() {
            let list = this.tbl_unreads.find({})
            if (list.length > 0) {
                this.$events.$emit(this.SHOW_UNREADS, list)
            }
        },
        _onAddUnread(data) {
            let list = this.tbl_unreads.find({ "id": data })
            if (list.length == 0) {
                this.tbl_unreads.insert({ id: data })
            }
        },
        _onP2pMsgIn(data) {
            let convs = this.tbl_chats.find({ "friend_id": data.friend_id })
            if (convs != null) {
                let conv = convs[0]
                if (conv.chats) {
                    conv.chats.push(data.chats[0])
                    this._onChatDataUpdated(conv)
                } else {
                    conv.chats = [data.chats[0]]
                    this._onChatDataUpdated(conv)
                }
            }
        },
        _onP2pMsgNew(data) {
            this.tbl_chats.insert(data)
            let conv = this.tbl_chats.find({ 'id': data.id })
            this._updateChatsList()
            this._onChatDataUpdated(conv[0])
        },
        _onUpdateChatData(data) {
            let conv = this.tbl_chats.find({ 'id': data.id })
            if (conv[0]) {
                conv[0].chats = data.chats
                conv[0].read = data.read
                conv[0].date = data.date
                this._onChatDataUpdated(conv[0])
            }
        },
        _onGetChats(data) {
            let requery = false
            let convs = this.tbl_chats.find({ 'friend_id': data.id })
            for (let n = 0; n < convs.length; n++) {
                let conv = convs[n]
                if (conv.chats == null || conv.date == null) {
                    requery = true
                    this.$events.$emit(this.QUERY_CHATS, conv)
                } else {
                    if (requery) {
                        this.$events.$emit(this.QUERY_CHATS, conv)
                    } else {
                        this._onChatDataUpdated(conv)
                    }
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
            console.log(">>> UPDATES", data)
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

            for (let n = 0; n < data.invits.length; n++) {
                let invit = data.invits[n]
                this.tbl_invits.insert(invit)
            }
            this._updateInvitsList()
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
        },
        _updateInvitsList() {
            let invits = this.tbl_invits.where((o) => {
                return o.from_name != null
            })
            this.$events.$emit(this.UPDATE_INVITATIONS_LIST, invits)
        },
        _onChatDataUpdated(data) {
            this.$events.$emit(this.CHAT_DATA_UPDATED, data)
        }
    }
}
</script>

<style>

</style>
