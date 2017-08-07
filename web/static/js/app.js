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
                    get INVIT_IGNORE() { return "IGNORED" },
                    get TYPE_FRIEND() { return "F" },
                    get TYPE_GROUP() { return "G" },
                    get TOP_MARGIN() { return 310 },
                }
            },

            get Message() {
                return {
                    get NOTIF_INVITATION_SENT() { return "Invitation sent!" },
                    get ERROR_GROUP_NAME_EMPTY() { return "You must provide a name for a group!" },
                    get ERROR_GROUP_MEMBERS_EMPTY() { return "You must have more than 1 member in a group beside you!" },
                    get ERROR_WRONG_EMAIL_FORMAT() { return "Invalid email format!" },
                    get ERROR_EMAIL_EMPTY() { return "Email cannot be empty!" }
                }
            },

            // Client server messages
            get Event() {
                return {
                    get INITIAL_UPDATES() { return "initial_updates" },
                    get FRIEND_NEW() { return "friend_new" },
                    get FRIEND_ONLINE() { return "friend_online" },
                    get FRIEND_OFFLINE() { return "friend_offline" },
                    get P2P_MSG_NEW() { return "p2p_msg_new" },
                    get P2P_MSG_IN() { return "p2p_msg_in" },
                    get QUERY_CHATS() { return "query_chats" },
                    get P2P_MSG_READ() { return "p2p_msg_read" },
                    get INVIT_OPENED() { return "invit_opened" },
                    get GROUP_NEW() { return "group_new" },
                    get GROUP_UPDATE() { return "group_update" },
                    get P2G_MSG_NEW() { return "p2g_msg_new" },
                    get P2G_MSG_IN() { return "p2g_msg_in" },
                    get ONLINE_MEMBERS() { return "online_members" },
                    get PRESENCE_STATE() { return "presence_state" },
                    get PRESENCE_DIFF() { return "presence_diff" },

                    // Component 2 component messages with args
                    get UPDATE_FRIENDS_LIST() { return "update_friends_list" },
                    get UPDATE_GROUPS_LIST() { return "update_groups_list" },
                    get UPDATE_CHATS_LIST() { return "update_chats_list" },
                    get UPDATE_CHANNELS_LIST() { return "update_channels_list" },
                    get UPDATE_INVITATIONS_LIST() { return "update_invitations_list" },
                    get CHAT_DATA_UPDATED() { return "chat_data_updated" },
                    get UPDATE_CHAT_DATA() { return "update_chat_data" },
                    get UPDATE_CHAT_DIALOG() { return "update_chat_dialog" },
                    get P2P_MSG_OUT() { return "p2p_msg_out" },
                    get P2G_MSG_OUT() { return "p2g_msg_out" },
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
                    get ADD_GROUP_OUT() { return "add_group_out" },
                    get ADD_GROUP_IN() { return "add_group_in" },
                    get ADD_GROUP_RESP() { return "add_group_resp" },
                    get JOIN_GROUP() { return "join_group" },

                    // Component 2 component messages with args that triggers GUI component
                    get SHOW_UNREAD() { return "show_unread" },
                    get SHOW_UNOPENED() { return "show_unopened" },
                    get START_CHAT() { return "start_chat" },
                    get POP_QUESTION() { return "pop_question" },
                    get POP_INFO() { return "pop_info" },
                    get POP_ERROR() { return "pop_error" },
                    get SWITCH_FRIEND_DETAIL() { return "switch_friend_detail" },
                    get SWITCH_GROUP_DETAIL() { return "switch_group_detail" },
                    get SWITCH_INVIT_DETAIL() { return "switch_invit_detail" },
                    get SWITCH_CHAT() { return "switch_chat" },
                    get SWITCH_ADD_GROUP() { return "switch_add_group" },
                    get SHOW_FRIENDS_LIST() { return "show_friends_list" },

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
                    get OPEN_GROUPS() { return "open_groups" },
                    get CLOSE_GROUPS() { return "close_groups" },
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
                    get SWITCH_MENU() { return "switch_menu" },
                    get SWITCH_ADD_FRIEND() { return "switch_add_friend" },
                    get MINIMIZE() { return "minimize" },
                    get GET_FRIENDS_LIST() { return "get_friends_list" },
                }
            }
        }
    }
})

lobby.init(socket, document.getElementById("lobby_div"))

new Vue({
    created() {
        window.onresize = () => {
            this.$events.$emit(this.Event.WINDOW_RESIZING)
        }
    }
})
