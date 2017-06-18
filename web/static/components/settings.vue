<template>
    <transition name="fade">
        <div v-if="showPopup">
            <div class="popup-mask">
                <div class="popup-wrapper">
                    <div class="popup-container">
                        <div class="popup-header">
                            Settings <a href="#" v-on:click="hidePopup" > <i class="fa fa-close popup-close pull-right"></i></a>
                        </div>
                        <div class="popup-body">
                            default body
                        </div>
                        <div class="popup-footer">
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>

<script>
export default {
    data() {
        return {
            showPopup: false
        }
    },
    created() {
        this.$events.$on("open_settings", () => {
            this.showPopup = true
        })
    },
    methods: {
        hidePopup() {
            this.showPopup = false
        }
    }
}
</script>

<style>

</style>
