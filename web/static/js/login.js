import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import LoginForm from "../components/login.vue"

let login = {
    init(element) {
        if (!element) {
            return
        } else {
            this.init_ui()
        }
    },
    init_ui() {
        let form = document.getElementById("login_form")
        Vue.component('login', LoginForm)
        new Vue({
            el: '#login_form_group',
            data() {
                return {
                    unameFieldName: "session[username]",
                    unamePlaceholder: "Email",
                    unameFieldType: "email",
                    paswdFieldName: "session[password]",
                    paswdPlaceholder: "Password",
                    paswdFieldType: "password"
                }
            },
            render(createElement) {
                return createElement(LoginForm, {})
            },
            created() {
                this.$events.$on(this.LOGIN_CANCEL, () => {
                    window.location.href = "/web"
                })
                this.$events.$on(this.LOGIN_SUBMIT, () => {
                    form.submit()
                })
            }
        })
    }
}
export default login