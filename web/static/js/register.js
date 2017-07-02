import Vue from 'vue'
import VueEvents from 'vue-events'
import RegisterForm from "../components/register.vue"

Vue.use(VueEvents)

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
                    paswdFieldType: "password"
                }
            },
            render(createElement) {
                return createElement(RegisterForm, {})
            },
            created() {
                this.$events.$on(this.REGISTER_CANCEL, () => {
                    window.location.href = "/web"
                })
                this.$events.$on(this.REGISTER_SUBMIT, () => {
                    form.submit()
                })
            }
        })
    }
}
export default register