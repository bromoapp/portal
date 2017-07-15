// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import "phoenix_html"
import socket from "./socket"
import lobby from "./lobby"
import login from "./login"
import register from "./register"
import Vue from 'vue'
import VueEvents from 'vue-events'

Vue.use(VueEvents)

Vue.mixin({
    data: function () {
        return {
            // Constants
            get Constant() {
                return {
                    get INVIT_ACCEPT() { return "ACCEPTED" },
                    get INVIT_REJECT() { return "REJECTED" },
                    get INVIT_IGNORE() { return "IGNORED" }
                }
            },

            // Client server messages
            get INITIAL_UPDATES() { return "initial_updates" },
            get FRIEND_NEW() { return "friend_new" },
            get FRIEND_ONLINE() { return "friend_online" },
            get FRIEND_OFFLINE() { return "friend_offline" },
            get P2P_MSG_NEW() { return "p2p_msg_new" },
            get P2P_MSG_IN() { return "p2p_msg_in" },
            get QUERY_CHATS() { return "query_chats" },
            get P2P_MSG_READ() { return "p2p_msg_read" },
            get ADD_FRIEND_OPENED() { return "add_friend_opened" },

            // Component 2 component messages with args
            get UPDATE_FRIENDS_LIST() { return "update_friends_list" },
            get UPDATE_CHATS_LIST() { return "update_chats_list" },
            get UPDATE_CHANNELS_LIST() { return "update_channels_list" },
            get UPDATE_INVITATIONS_LIST() { return "update_invitations_list" },
            get CHAT_DATA_UPDATED() { return "chat_data_updated" },
            get UPDATE_CHAT_DATA() { return "update_chat_data" },
            get UPDATE_CHAT_DIALOG() { return "update_chat_dialog" },
            get P2P_MSG_OUT() { return "p2p_msg_out" },
            get GET_CHATS() { return "get_chats" },
            get GET_UNREAD() { return "get_unread" },
            get ADD_UNREAD() { return "add_unread" },
            get DEL_UNREAD() { return "del_unread" },
            get DEL_UNREAD_REC() { return "del_unread_rec" },
            get ADD_FRIEND_OUT() { return "add_friend_out" },
            get ADD_FRIEND_IN() { return "add_friend_in" },
            get ADD_FRIEND_RESP() { return "add_friend_resp" },
            get GET_UNOPENED() { return "get_unopened" },
            get ADD_UNOPENED() { return "add_unopened" },
            get DEL_UNOPENED() { return "del_unopened" },
            get DEL_UNOPENED_REC() { return "del_unopened_rec" },

            // Component 2 component messages with args that triggers GUI component
            get SHOW_UNREAD() { return "show_unread" },
            get SHOW_UNOPENED() { return "show_unopened" },
            get START_CHAT() { return "start_chat" },
            get POP_QUESTION() { return "pop_question" },
            get POP_INFO() { return "pop_info" },
            get POP_ERROR() { return "pop_error" },
            get SWITCH_FRIEND_DETAIL() { return "switch_friend_detail" },
            get SWITCH_INVIT_DETAIL() { return "switch_invit_detail" },
            get SWITCH_CHAT() { return "switch_chat" },

            // Component 2 component messages w/o args that triggers GUI component
            get CHAT_DIALOG_CLOSED() { return "chat_dialog_closed" },
            get SIGN_OUT() { return "sign_out" },
            get LOGIN_SUBMIT() { return "login_submit" },
            get LOGIN_CANCEL() { return "login_cancel" },
            get REGISTER_SUBMIT() { return "register_submit" },
            get REGISTER_CANCEL() { return "register_cancel" },
            get OPEN_CHANNELS() { return "open_channels" },
            get CLOSE_CHANNELS() { return "close_channels" },
            get OPEN_FRIENDS() { return "open_friends" },
            get CLOSE_FRIENDS() { return "close_friends" },
            get OPEN_CHATS() { return "open_chats" },
            get CLOSE_CHATS() { return "close_chats" },
            get OPEN_INVITATIONS() { return "open_invitations" },
            get CLOSE_INVITATIONS() { return "close_invitations" },
            get CLOSE_FLOAT_PANEL() { return "close_float_panel" },
            get PUSH_WINDOW() { return "push_window" },
            get PULL_WINDOW() { return "pull_window" },
            get SWITCH_SETTINGS() { return "switch_settings" },
            get HIGHLIGHT_CHATS_BTN() { return "highlight_chats_btn" },
            get HIGHLIGHT_INVITS_BTN() { return "highlight_invits_btn" },
            get WINDOW_RESIZING() { return "window_risizing" },

            // Constant values
            get TOP_MARGIN() { return 310 }
        }
    }
})

login.init(document.getElementById("login_form"))
register.init(document.getElementById("register_form"))
lobby.init(socket, document.getElementById("lobby_div"))

new Vue({
    created() {
        window.onresize = () => {
            this.$events.$emit(this.WINDOW_RESIZING)
        }
    }
})
