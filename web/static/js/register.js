import Vue from 'vue'
import RegisterForm from "../components/register.vue"

let register = {
    init(element) {
        if (!element) {
            return
        } else {
            this.init_ui()
        }
    },
    init_ui() {
        let form = document.getElementById("register_form")
        Vue.component("register", RegisterForm)
        new Vue({
            el: '#register_form_group',
            data() {
                return {
                    unameFieldName: "user[name]",
                    unamePlaceholder: "Name",
                    unameFieldType: "text",
                    emailFieldName: "user[username]",
                    emailPlaceholder: "Email",
                    emailFieldType: "email",
                    paswdFieldName: "user[password]",
                    paswdPlaceholder: "Password",
                    paswdFieldType: "password",
                    doSubmit: () => {
                        form.submit()
                    },
                    doCancel: () => {
                        window.location.href = "/web"
                    }
                }
            },
            render(createElement) {
                return createElement(RegisterForm, {})
            }
        })
    }
}
export default register