<template>
    <transition name="fade">
        <div v-if="visible">
            <div class="popup-mask">
                <div class="popup-wrapper">
                    <div class="popup-container">
                        <div class="popup-header bg-7cb342-s">
                            Search
                            <a href="#" v-on:click="hidePopup">
                                <i class="fa fa-close popup-close pull-right"></i>
                            </a>
                        </div>
                        <div class="popup-body">
                            <div class="bg-c5e1a5-s" style="width: 100%; text-align: center;">
                                <span style="margin-top: 20px" class="inline">
                                    <div class="form-group">
                                        <select id="search_type" class="form-control">
                                            <option>Room</option>
                                            <option>Player</option>
                                        </select>
                                    </div>
                                </span>
                                <span class="inline">
                                    <div class="form-group">
                                        <input id="search_args" type="text" class="form-control">
                                    </div>
                                </span>
                                <span class="inline">
                                    <div class="form-group">
                                        <a class="btn btn-primary" v-on:click="submitForm">Submit</a>
                                    </div>
                                </span>
                            </div>
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
        this.$events.$on("open_search", () => {
            this.visible = true
        })
    },
    methods: {
        hidePopup() {
            this.visible = false
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
