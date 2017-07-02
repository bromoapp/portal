import loki from 'lokijs'
import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

Vue.mixin({
    data: function () {
        return {
            // Client server messages
            get INITIAL_UPDATES() { return "initial_updates" },
            get FRIEND_ONLINE() { return "friend_online" },
            get FRIEND_OFFLINE() { return "friend_offline" },
            get P2P_MSG_IN() { return "p2p_msg_in" },
            get QUERY_CHATS() { return "query_chats" },
            
            // Component 2 component messages with args
            get UPDATE_FRIENDS_LIST() { return "update_friends_list" },
            get UPDATE_CHATS_LIST() { return "update_chats_list" },
            get UPDATE_CHANNELS_LIST() { return "update_channels_list" },
            get UPDATE_INVITATIONS_LIST() { return "update_invitations_list" },
            get UPDATE_CHAT_DIALOG() { return "update_chat_dialog" },
            get P2P_MSG_OUT() { return "p2p_msg_out" },
            get GET_CHATS() { return "get_chats" },

            // Component 2 component messages with args that triggers GUI component
            get START_CHAT() { return "start_chat" },
            get POP_QUESTION() { return "pop_question" },
            get POP_INFO() { return "pop_info" },
            get POP_ERROR() { return "pop_error" },
            get SWITCH_FRIEND_DETAIL() { return "switch_friend_detail" },
            get SWITCH_CHAT() { return "switch_chat" },

            // Component 2 component messages w/o args that triggers GUI component
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
        }
    }
})

import Database from "../components/database.vue"
import WsockConn from "../components/wsock_conn.vue"
import MainWindow from "../components/main_window.vue"
import Sidebar from "../components/sidebar.vue"
import Popup from "../components/popup.vue"

let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            this.init_database()
            this.init_server_conn(socket, element)
            this.init_popup()
            this.init_sideBar()
            this.init_mainWindow()
        }
    },
    init_database() {
        Vue.component("database", Database)
        new Vue({
            el: "#database_div",
            data() {
                return {
                    db: new loki('portaldb.json')
                }
            },
            render(createElement) {
                return createElement(Database, {})
            }
        })
    },
    init_server_conn(socket, element) {
        let username = element.getAttribute("data-username")
        Vue.component("wsock-conn", WsockConn)
        new Vue({
            el: "#wsock_conn_div",
            data() {
                return {
                    user: username,
                    wsocket: socket
                }
            },
            render(createElement) {
                return createElement(WsockConn, {})
            }
        })
    },
    init_popup() {
        Vue.component("popup", Popup)
        new Vue({
            el: "#popup_div",
            render(createElement) {
                return createElement(Popup, {})
            }
        })
    },
    init_sideBar() {
        Vue.component("sidebar", Sidebar)
        new Vue({
            el: "#sidebar_div",
            data() {
                return {
                    maxWidth: 282,
                    minWidth: 50
                }
            },
            render(createElement) {
                return createElement(Sidebar, {})
            }
        })
    },
    init_mainWindow() {
        Vue.component("main-window", MainWindow)
        new Vue({
            el: "#main_div",
            data() {
                return {
                    maxLeftMargin: 282,
                    minLeftMargin: 50
                }
            },
            render(createElement) {
                return createElement(MainWindow, {})
            }
        })
    }
}
export default lobby