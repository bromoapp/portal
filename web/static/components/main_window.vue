<template>
    <div id="main_window" class="main-window lobby-body">
    
    </div>
</template>

<script>
export default {
    data() {
        return {
            maxLeftMargin: this.$parent.maxLeftMargin
        }
    },
    created() {
        this.$events.$on("push_window", () => {
            this._push()
        })
        this.$events.$on("pull_window", () => {
            this._pull()
        })
    },
    methods: {
        _push() {
            document.getElementById("main_window").style.marginLeft = this.maxLeftMargin + "px"
        },
        _pull() {
            setTimeout(() => {
                document.getElementById("main_window").style.marginLeft = "0px"
            }, 300)
        }
    }
}
</script>

<style>

</style>
