<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s">
                Groups &amp; Friends
                <div class="accordion-header-btns">
                    <a v-if="counterparts.length == 0" title="Search friend" id="src_friend_btn" href="javascript:" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                    <a v-else title="Search friend" id="src_friend_btn" href="javascript:" v-on:click="seekFriend" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                </div>
            </div>
            <div v-if="src_form_visible" id="seek_friend" class="bg-212121-s slide-in">
                <div style="margin: 0px 17px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Search friend:</span>
                    <input id="search_args" class="form-control" type="text" placeholder="Name">
                </div>
            </div>
            <div id="items_list" class="accordion-body">
                <ul>
                    <li v-for="counterpart in counterparts" v-bind:key="counterpart">
                        <div v-on:click="onFriendClicked(counterpart)" class="accordion-btn bg-263238-d">
                            <span>{{ counterpart.name }}</span>
                            <span v-if="counterpart.online" style="color: #ffb300" class="pull-right icon">
                                <i class="fa fa-user"></i>
                            </span>
                            <span v-else style="color: #000" class="pull-right icon">
                                <i class="fa fa-user"></i>
                            </span>
                        </div>
                    </li>
                    <li v-if="counterparts.length > 6">
                        <div class="accordion-btn bg-212121-s">&nbsp;</div>
                    </li>
                    <li v-else>
                        <div style="height: 200px;" class="accordion-btn bg-212121-s">&nbsp;</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div v-else></div>
</template>

<script>
let closed = true

export default {
    data() {
        return {
            counterparts: [],
            visible: false,
            invit_msg: "Hi, can I be your friend?",
            src_form_visible: false,
            add_form_visible: false,
            detailPanelWidth: 300
        }
    },
    created() {
        this.$events.$on(this.WINDOW_RESIZING, () => { this._onWindowResizing() })
        this.$events.$on(this.OPEN_FRIENDS, () => { this._openFriendsList() })
        this.$events.$on(this.CLOSE_FRIENDS, () => { this._closeFriendsList() })
        this.$events.$on(this.UPDATE_FRIENDS_LIST, (list) => { this._updateFriendsList(list) })
    },
    methods: {
        _onWindowResizing() {
            let body = document.getElementById("items_list")
            body.style.display = "none"
            setTimeout(() => {
                body.style.height = (window.innerHeight - this.TOP_MARGIN) + "px"
                body.style.overflowY = "auto"
                body.style.display = "block"
            }, 200)
        },
        _updateFriendsList(list) {
            this.counterparts = list
        },
        _closeFriendsList() {
            setTimeout(() => {
                this.visible = false
                this.src_form_visible = false
                this.add_form_visible = false
            }, 300)
        },
        _openFriendsList() {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("items_list")
                    body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                }, 200)
            }, 300)
        },
        onFriendClicked(friend) {
            if (this.src_form_visible) {
                this.seekFriend()
            }
            this.$events.$emit(this.SWITCH_FRIEND_DETAIL, friend)
        },
        seekFriend() {
            document.getElementById("src_friend_btn").blur()
            if (this.src_form_visible) {
                let div = document.getElementById("seek_friend")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.src_form_visible = false
                }, 200)
            } else {
                if (this.add_form_visible) {
                    this.addFriend()
                }
                setTimeout(() => {
                    this.src_form_visible = true
                    setTimeout(() => {
                        let div = document.getElementById("seek_friend")
                        div.style.maxHeight = "100px"

                        let inputEl = document.getElementById("search_args")
                        inputEl.focus()
                    }, 150)
                }, 150);
            }
        }
    }
}
</script>

<style>

</style>
