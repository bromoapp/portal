import Vue from 'vue'
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
            methods: {
                doSubmit() {
                    form.submit()
                },
                doCancel() {
                    window.location.href = "/web"
                }
            },
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
            }
        })
    }
}
export default login