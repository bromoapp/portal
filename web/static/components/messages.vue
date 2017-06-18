<template>
    <transition name="fade">
        <div v-if="showPopup">
            <div class="modal-mask">
                <div class="modal-wrapper">
                    <div class="modal-container">
                        <div class="modal-header">
                            <slot name="header">
                                Messages
                            </slot>
                        </div>
                        <div class="modal-body">
                            <slot name="body">
                                default body
                            </slot>
                        </div>
                        <div class="modal-footer">
                            <slot name="footer">
                                <button v-on:click="hidePopup" class="btn btn-danger">Close</button>
                            </slot>
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
        this.$events.$on("open_messages", () => {
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
