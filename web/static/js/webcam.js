import Vue from 'vue'
import Webcam from "../components/webcam.vue"

let webcam = {
    init(element) {
        if (!element) {
            return
        } else {
            this.init_ui()
        }
    },
    init_ui() {
        Vue.component("webcam", Webcam)
        new Vue({
            el: '#webcam-container',
            render(createElement) {
                return createElement(Webcam, {})
            }
        })
    }
}
export default webcam