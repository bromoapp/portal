<template>
    <transition name="popup">
        <div class="popup-mask">
            <div class="popup-wrapper">
                <div class="popup-container">
                    <div class="popup-header">
                        <slot name="header">
                            default header
                        </slot>
                    </div>
                    <div class="popup-body">
                        <slot name="body">
                            default body
                        </slot>
                    </div>
                    <div class="popup-footer">
                        <slot name="footer">
                            default footer
                            <button class="popup-default-button" @click="$emit('close')">
                                OK
                            </button>
                        </slot>
                    </div>
                </div>
            </div>
        </div>
    </transition>
</template>

<script>
export default {

}
</script>

<style>

</style>
