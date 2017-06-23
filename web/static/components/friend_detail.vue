<template>
    <div id="panel_window"></div>
</template>

<script>
export default {
    data() {
        return {
            leftMargin: this.$parent.leftMargin,
            maxWidth: this.$parent.detailPanelWidth
        }
    },
    created() {
        this.$events.$on("push_window", () => {
            //this._push()
        })
        this.$events.$on("pull_window", () => {
            //this._pull()
        })
    },
    methods: {
        _push() {
            document.getElementById("panel_window").style.marginLeft = this.leftMargin + "px"
        },
        _pull() {
            setTimeout(() => {
                document.getElementById("panel_window").style.marginLeft = "0px"
            }, 300)
        }
    }
}
</script>

<style>

</style>
