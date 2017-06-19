<template>
    <transition name="fade">
        <div v-if="visible">
            <div class="popup-mask">
                <div class="popup-wrapper">
                    <div id="popup_container" class="popup-container">
                        <div class="popup-header">
                            Settings
                            <a href="#" v-on:click="hidePopup">
                                <i class="fa fa-close popup-close pull-right"></i>
                            </a>
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
            visible: false
        }
    },
    created() {
        this.$events.$on("open_settings", () => {
            this.visible = true
        })
    },
    methods: {
        hidePopup() {
            this.visible = false
        }
    }
}
</script>

<style>

</style>
