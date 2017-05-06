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
        Vue.component('login', LoginForm)
        new Vue({
            el: '#login-form',
            render(createElement) {
                return createElement(LoginForm, {})
            }
        })
    }
}
export default login