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
            tbl_groups: null,
            tbl_unread: null,
            tbl_friends: null,
            tbl_unopened: null,
        }
    },
    created() {
        this.tbl_chats = this.db.addCollection('chats')
        this.tbl_invits = this.db.addCollection('invits')
        this.tbl_groups = this.db.addCollection('groups')
        this.tbl_unread = this.db.addCollection('unread')
        this.tbl_friends = this.db.addCollection('friends')
        this.tbl_unopened = this.db.addCollection("unopened")

        // Insert or update database events handlers
        this.$events.$on(this.Event.INITIAL_UPDATES, (data) => { this._onInitialUpdates(data) })
        this.$events.$on(this.Event.GROUP_INITIAL_UPDATES, (data) => { this._onGroupInitialUpdates(data) })
        this.$events.$on(this.Event.FRIEND_NEW, (data) => { this._onFriendNew(data) })
        this.$events.$on(this.Event.FRIEND_ONLINE, (data) => { this._onFriendOnline(data) })
        this.$events.$on(this.Event.FRIEND_OFFLINE, (data) => { this._onFriendOffline(data) })
        this.$events.$on(this.Event.GET_CHATS, (data) => { this._onGetChats(data) })
        this.$events.$on(this.Event.GET_GCHATS, (data) => { this._onGetGChats(data) })
        this.$events.$on(this.Event.UPDATE_CHAT_DATA, (data) => { this._onUpdateChatData(data) })
        this.$events.$on(this.Event.UPDATE_GCHAT_DATA, (data) => { this._onUpdateGChatData(data) })
        this.$events.$on(this.Event.P2P_MSG_NEW, (data) => { this._onP2pMsgNew(data) })
        this.$events.$on(this.Event.P2P_MSG_IN, (data) => { this._onP2pMsgIn(data) })
        this.$events.$on(this.Event.ADD_UNREAD, (data) => { this._onAddUnread(data) })
        this.$events.$on(this.Event.GET_UNREAD, () => { this._onGetUnread() })
        this.$events.$on(this.Event.DEL_UNREAD, (data) => { this._onDelUnread(data) })
        this.$events.$on(this.Event.ADD_FRIEND_IN, (data) => { this._onAddFriendIn(data) })
        this.$events.$on(this.Event.ADD_GROUP_IN, (data) => { this._onAddGroupIn(data) })
        this.$events.$on(this.Event.ADD_FRIEND_RESP, (data) => { this._onAddFriendResp(data) })
        this.$events.$on(this.Event.GROUP_NEW, (data) => { this._onGroupNew(data) })
        this.$events.$on(this.Event.GROUP_UPDATE, (data) => { this._onGroupUpdate(data) })

        this.$events.$on(this.Event.ADD_UNOPENED, (data) => { this._onAddUnopened(data) })
        this.$events.$on(this.Event.GET_UNOPENED, () => { this._onGetUnopened() })
        this.$events.$on(this.Event.DEL_UNOPENED, (data) => { this._onDelUnopened(data) })
        this.$events.$on(this.Event.GET_FRIENDS_LIST, () => { this._onGetFriendsList() })
    },
    methods: {
        _onGetGChats(data) {
            let requery = false
            let convs = this.tbl_chats.find({ 'counter_id': data.id, 'type': 'P2G' })
            for (let n = 0; n < convs.length; n++) {
                let conv = convs[n]
                if (conv.chats == null || conv.date == null) {
                    requery = true
                    this.$events.$emit(this.Event.QUERY_GCHATS, conv)
                } else {
                    if (requery) {
                        this.$events.$emit(this.Event.QUERY_GCHATS, conv)
                    } else {
                        this._onChatDataUpdated(conv)
                    }
                }
            }
        },
        _onGroupInitialUpdates(data) {
            let updates = data.updates
            let groups = this.tbl_groups.find({ 'unique': data.unique })
            if (groups.length > 0) {
                groups[0].members = updates.members
                groups[0].admins = updates.admins
            }
            this._updateGroupsList()

            let chats = updates.chats
            for (let n = 0; n < chats.length; n++) {
                let chat = chats[n]
                if (chat.read == 0) {
                    this.tbl_unread.insert({ id: chat.id, cid: chat.counter_id, type: chat.type })
                }
                this.tbl_chats.insert(chat)
            }
            this._updateChatsList()
        },
        _onGroupNew(group) {
            this.tbl_groups.insert(group)
            this.$events.$emit(this.Event.JOIN_GROUP, group)
            this._updateGroupsList()
        },
        _onGroupUpdate(group) {
            let groups = this.tbl_groups.find({ 'unique': group.unique })
            if (groups.length > 0) {
                groups[0].members = group.members
                this._updateGroupsList()
            }
        },
        _updateGroupsList() {
            let groups = this.tbl_groups.where((o) => {
                return o.name != null
            })
            this.$events.$emit(this.Event.UPDATE_GROUPS_LIST, groups)
        },
        _updateFriendsList() {
            let friends = this.tbl_friends.where((o) => {
                return o.name != null
            })
            this.$events.$emit(this.Event.UPDATE_FRIENDS_LIST, friends)
        },
        _updateChatsList() {
            let raw = this.tbl_chats.where((o) => {
                return o.counter_id != null
            })
            let chats = []
            for (let n = 0; n < raw.length; n++) {
                if (raw[n].type == "P2G") {
                    let cid = raw[n].counter_id
                    let groups = this.tbl_groups.find({ 'id': cid })
                    if (groups.length > 0) {
                        let group = groups[0]
                        if (!chats.includes(group)) {
                            chats.push(groups[0])
                        }
                    }
                } else {
                    let cid = raw[n].counter_id
                    let friends = this.tbl_friends.find({ 'id': cid })
                    if (friends.length > 0) {
                        let friend = friends[0]
                        if (!chats.includes(friend)) {
                            chats.push(friends[0])
                        }
                    }
                }
            }
            this.$events.$emit(this.Event.UPDATE_CHATS_LIST, chats)
        },
        _updateInvitsList() {
            let invits = this.tbl_invits.where((o) => {
                return o.from_name != null
            })
            this.$events.$emit(this.Event.UPDATE_INVITATIONS_LIST, invits)
        },
        _onAddGroupIn(invit) {
            this._onAddFriendIn(invit)
        },
        _onGetFriendsList() {
            let friends = this.tbl_friends.where((o) => {
                return o.name != null
            })
            this.$events.$emit(this.Event.SHOW_FRIENDS_LIST, friends)
        },
        _onAddFriendResp(invit) {
            this.tbl_invits.findAndRemove({ id: invit.id })
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
            this.$events.$emit(this.Event.DEL_UNOPENED_REC, id)
        },
        _onGetUnopened() {
            let list = this.tbl_unopened.find({})
            if (list.length > 0) {
                this.$events.$emit(this.Event.SHOW_UNOPENED, list)
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
                this.$events.$emit(this.Event.SHOW_UNREAD, list)
            }
        },
        _onDelUnread(cid) {
            let unreads = this.tbl_unread.find({ "cid": cid })
            if (unreads.length > 0) {
                this.tbl_unread.findAndRemove({ "cid": cid })
                this.$events.$emit(this.Event.DEL_UNREAD_REC, unreads[0].id)
            }
        },
        _onP2pMsgNew(data) {
            this.tbl_chats.insert(data)
            let convs = this.tbl_chats.find({ 'id': data.id })
            this._updateChatsList()
            this._onChatDataUpdated(convs[0])
        },
        _onP2pMsgIn(data) {
            let table = this.tbl_chats.find({})
            let convs = this.tbl_chats.find({ 'id': data.id })
            if (convs.length > 0) {
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
        _onUpdateGChatData(data) {
            let convs = this.tbl_chats.find({ 'id': data.id, 'type': 'P2G' })
            if (convs.length > 0) {
                if (convs[0]) {
                    convs[0].chats = data.chats
                    convs[0].read = data.read
                    convs[0].date = data.date
                    convs[0].type = data.type
                    this._onChatDataUpdated(convs[0])
                }
            }
        },
        _onUpdateChatData(data) {
            let convs = this.tbl_chats.find({ 'id': data.id, 'type': 'P2P' })
            if (convs.length > 0) {
                if (convs[0]) {
                    convs[0].chats = data.chats
                    convs[0].read = data.read
                    convs[0].date = data.date
                    convs[0].type = data.type
                    this._onChatDataUpdated(convs[0])
                }
            }
        },
        _onGetChats(data) {
            let requery = false
            let convs = this.tbl_chats.find({ 'counter_id': data.id, 'type': 'P2P' })
            for (let n = 0; n < convs.length; n++) {
                let conv = convs[n]
                if (conv.chats == null || conv.date == null) {
                    requery = true
                    this.$events.$emit(this.Event.QUERY_CHATS, conv)
                } else {
                    if (requery) {
                        this.$events.$emit(this.Event.QUERY_CHATS, conv)
                    } else {
                        this._onChatDataUpdated(conv)
                    }
                }
            }
        },
        _onFriendNew(data) {
            this.tbl_friends.insert(data)
            this._updateFriendsList()
        },
        _onFriendOffline(data) {
            let friends = this.tbl_friends.find({ 'id': data.id })
            if (friends.length > 0) {
                friends[0].online = false
                this._updateFriendsList()
            }
        },
        _onFriendOnline(data) {
            let friends = this.tbl_friends.find({ 'id': data.id })
            if (friends.length > 0) {
                friends[0].online = true
                this._updateFriendsList()
            }
        },
        _onChatDataUpdated(data) {
            this.$events.$emit(this.Event.CHAT_DATA_UPDATED, data)
        },
        _onInitialUpdates(data) {
            for (let n = 0; n < data.groups.length; n++) {
                let group = data.groups[n]
                this.tbl_groups.insert(group)
                this.$events.$emit(this.Event.JOIN_GROUP, group)
            }
            this._updateGroupsList()

            for (let n = 0; n < data.friends.length; n++) {
                let friend = data.friends[n]
                this.tbl_friends.insert(friend)
            }
            this._updateFriendsList()

            for (let n = 0; n < data.chats.length; n++) {
                let chat = data.chats[n]
                if (chat.read == 0) {
                    this.tbl_unread.insert({ id: chat.id, cid: chat.counter_id, type: chat.type })
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

            // Force to shows unread or unopened data
            setTimeout(() => {
                this._onGetUnread()
                this._onGetUnopened()
            }, 500);
        }
    }
}
</script>

<style>

</style>
