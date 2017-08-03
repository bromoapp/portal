<template>
    <div v-if="visible">
        <transition name="popup">
            <div class="popup-mask">
                <div class="popup-wrapper">
                    <div class="popup-container">
                        <div class="popup-header bg-37474f-s">
                            <label v-if="question">
                                <i class="fa fa-question-circle"></i>
                            </label>
                            <label v-if="error">
                                <i class="fa fa-warning"></i>
                            </label>
                            <label v-if="info">
                                <i class="fa fa-info-circle"></i>
                            </label>
                        </div>
                        <div class="popup-body bg-263238-s">
                            {{ message }}
                        </div>
                        <div class="popup-footer text-center bg-263238-s">
                            <span v-if="question">
                                <button class="btn bg-f50057-d" v-on:click="onYesEvent">
                                    Yes
                                </button>
                                <button class="btn bg-f50057-d" v-on:click="onNoEvent">
                                    No
                                </button>
                            </span>
                            <span v-else>
                                <button class="btn bg-f50057-d" v-on:click="close">
                                    Ok
                                </button>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </transition>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            visible: false,
            question: false,
            error: false,
            info: false,
            message: null,
            onYes: null,
            onNo: null
        }
    },
    created() {
        this.$events.$on(this.Event.POP_QUESTION, (obj) => { this._popUpQuestion(obj) })
        this.$events.$on(this.Event.POP_INFO, (obj) => { this._popUpInfo(obj) })
        this.$events.$on(this.Event.POP_ERROR, (obj) => { this._popUpError(obj) })
    },
    methods: {
        _popUpError(obj) {
            this.visible = true
            this.error = true
            this.message = obj.msg
        },
        _popUpQuestion(obj) {
            this.visible = true
            this.question = true
            this.message = obj.msg
            if (obj.onYes) {
                this.onYes = obj.onYes
            }
            if (obj.onNo) {
                this.onNo = obj.onNo
            }
        },
        _popUpInfo(obj) {
            this.visible = true
            this.info = true
            this.message = obj.msg
        },
        close() {
            this.visible = false
            this.question = false
            this.error = false
            this.info = false
        },
        onYesEvent() {
            if (this.onYes) {
                this.$events.$emit(this.onYes)
            }
            this.close()
        },
        onNoEvent() {
            if (this.onNo) {
                this.$events.$emit(this.onNo)
            }
            this.close()
        }
    }
}
</script>

<style>

</style>
