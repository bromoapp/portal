<template>
    <transition name="fade">
        <div v-if="showPopup">
            <div class="popup-mask">
                <div class="popup-wrapper">
                    <div class="popup-container">
                        <div class="popup-header">
                            Search
                            <a href="#" v-on:click="hidePopup">
                                <i class="fa fa-close popup-close pull-right"></i>
                            </a>
                        </div>
                        <div class="popup-body">
                            <form id="search_form" action="">
                                <label class="form-label">Type:</label>
                                <div class="form-group">
                                    <select id="search_type" class="form-control">
                                        <option>Room</option>
                                        <option>Player</option>
                                    </select>
                                </div>
                                <label class="form-label">Parameters:</label>
                                <div class="form-group">
                                    <input id="search_args" type="text" class="form-control">
                                </div>
                            </form>
                        </div>
                        <div class="popup-footer">
                            <span class="pull-right">
                                <a class="btn btn-primary" v-on:click="submitForm">Submit</a>
                                <a class="btn btn-default" v-on:click="resetForm">Reset</a>
                            </span>
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
        this.$events.$on("open_search", () => {
            this.showPopup = true
        })
    },
    methods: {
        hidePopup() {
            this.showPopup = false
        },
        resetForm() {
            document.getElementById("search_form").reset()
        },
        submitForm() {
            let type = document.getElementById("search_type")
            let args = document.getElementById("search_args")
            if (type.value.length > 0 && args.value.length > 0) {

            } else {
                alert()
            }
        }
    }
}
</script>

<style>

</style>
