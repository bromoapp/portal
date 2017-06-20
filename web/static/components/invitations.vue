<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-f50057-s" data="invitations_list">
                Invitations
            </div>
            <div id="invitations_list" class="accordion-body">
                <ul>
                    <li v-for="invit in invitations">
                        <div class="accordion-btn bg-263238-d">
                            <span>{{ invit }}</span>
                            <span class="pull-right" style="margin-right: 10px;">+</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            invitations: ["Mulan Jameela", "Finka Ludianti", "Trianto Herhusodo", "Denis Hartanto", "Seno Partono"],
            visible: false
        }
    },
    methods: {

    },
    created() {
        this.$events.$on("open_invitations", () => {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let el = document.getElementsByClassName("accordion-header")[0]
                    let data = el.getAttribute("data")
                    let body = document.getElementById(data)
                    body.style.maxHeight = "500px"
                }, 200)
            }, 300)
        })
        this.$events.$on("close_invitations", () => {
            let el = document.getElementsByClassName("accordion-header")[0]
            let data = el.getAttribute("data")
            let body = document.getElementById(data)
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
            }, 300)
        })
        this.$events.$on("on_invitations_list_updates", (invitations) => {
            this.invitations = invitations
        })
    }
}
</script>

<style>

</style>
