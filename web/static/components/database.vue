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
            tbl_unread: null,
            tbl_unopened: null,
        }
    },
    created() {
        this.tbl_chats = this.db.addCollection('chats')
        this.tbl_invits = this.db.addCollection('invits')
        this.tbl_friends = this.db.addCollection('friends')
        this.tbl_unread = this.db.addCollection('unread')
        this.tbl_unopened = this.db.addCollection("unopened")

        // Insert or update database events handlers
        this.$events.$on(this.INITIAL_UPDATES, (data) => { this._onInitialUpdates(data) })
        this.$events.$on(this.FRIEND_NEW, (data) => { this._onFriendNew(data) })
        this.$events.$on(this.FRIEND_ONLINE, (data) => { this._onFriendOnline(data) })
        this.$events.$on(this.FRIEND_OFFLINE, (data) => { this._onFriendOffline(data) })
        this.$events.$on(this.GET_CHATS, (data) => { this._onGetChats(data) })
        this.$events.$on(this.UPDATE_CHAT_DATA, (data) => { this._onUpdateChatData(data) })
        this.$events.$on(this.P2P_MSG_NEW, (data) => { this._onP2pMsgNew(data) })
        this.$events.$on(this.P2P_MSG_IN, (data) => { this._onP2pMsgIn(data) })
        this.$events.$on(this.ADD_UNREAD, (data) => { this._onAddUnread(data) })
        this.$events.$on(this.GET_UNREAD, () => { this._onGetUnread() })
        this.$events.$on(this.DEL_UNREAD, (data) => { this._onDelUnread(data) })
        this.$events.$on(this.ADD_FRIEND_IN, (data) => { this._onAddFriendIn(data) })
        this.$events.$on(this.ADD_FRIEND_RESP, (data) => { this._onAddFriendResp(data) })

        this.$events.$on(this.ADD_UNOPENED, (data) => { this._onAddUnopened(data) })
        this.$events.$on(this.GET_UNOPENED, () => { this._onGetUnopened() })
        this.$events.$on(this.DEL_UNOPENED, (data) => { this._onDelUnopened(data) })
    },
    methods: {
        _onAddFriendResp(invit) {
            this.tbl_invits.findAndRemove({id: invit.id})
            this._updateInvitsList()
            this._onGetUnopened()
        },
        _onAddFriendIn(invit) {
            this.tbl_invits.insert(invit)
            this._onAddUnopened(invit.id)
            this._updateInvitsList()
            this._onGetUnopened()
        },
        _onAddUnopened(id) {
            let list = this.tbl_unopened.find({ "id": id })
            if (list.length == 0) {
                this.tbl_unopened.insert({ id: id })
            }
        },
        _onDelUnopened(id) {
            this.tbl_unopened.findAndRemove({ "id": id })
            this.$events.$emit(this.DEL_UNOPENED_REC, id)
        },
        _onGetUnopened() {
            let list = this.tbl_unopened.find({})
            if (list.length > 0) {
                this.$events.$emit(this.SHOW_UNOPENED, list)
            }
        },
        _onAddUnread(data) {
            let list = this.tbl_unread.find({ "id": data.id })
            if (list.length == 0) {
                this.tbl_unread.insert(data)
            }
        },
        _onGetUnread() {
            let list = this.tbl_unread.find({})
            if (list.length > 0) {
                this.$events.$emit(this.SHOW_UNREAD, list)
            }
        },
        _onDelUnread(fid) {
            let unreads = this.tbl_unread.find({ "fid": fid })
            if (unreads.length > 0) {
                this.tbl_unread.findAndRemove({ "fid": fid })
                this.$events.$emit(this.DEL_UNREAD_REC, unreads[0].id)
            }
        },
        _onP2pMsgNew(data) {
            console.log(">>> NEW P2P", data)
            this.tbl_chats.insert(data)
            let conv = this.tbl_chats.find({ 'id': data.id })
            this._updateChatsList()
            this._onChatDataUpdated(conv[0])
        },
        _onP2pMsgIn(data) {
            let table = this.tbl_chats.find({})
            let convs = this.tbl_chats.find({ 'id': data.id })
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
        _onFriendNew(data) {
            this.tbl_friends.insert(data)
            this._updateFriendsList()
        },
        _onFriendOnline(data) {
            let friend = this.tbl_friends.find({ 'id': data.id })
            friend[0].online = true
            this._updateFriendsList()
        },
        _onInitialUpdates(data) {
            console.log(data)
            for (let n = 0; n < data.friends.length; n++) {
                let friend = data.friends[n]
                this.tbl_friends.insert(friend)
            }
            this._updateFriendsList()

            for (let n = 0; n < data.chats.length; n++) {
                let chat = data.chats[n]
                if (chat.read == 0) {
                    this.tbl_unread.insert({ id: chat.id, fid: chat.friend_id })
                }
                this.tbl_chats.insert(chat)
            }
            this._updateChatsList()

            for (let n = 0; n < data.invits.length; n++) {
                let invit = data.invits[n]
                if (invit.opened == 0) {
                    this.tbl_unopened.insert({ id: invit.id })
                }
                this.tbl_invits.insert(invit)
            }
            this._updateInvitsList()

            // Force to shows unread chats
            this._onGetUnread()
            this._onGetUnopened()
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
                let fid = raw[n].friend_id
                let friend = this.tbl_friends.find({ 'id': fid })
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
