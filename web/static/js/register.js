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
        Vue.component("register", RegisterForm)
        new Vue({
            el: '#register_form',
            render(createElement) {
                return createElement(RegisterForm, {})
            }
        })
    }
}
export default register