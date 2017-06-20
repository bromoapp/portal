<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-f50057-s" data="friends_list">
                Friends
            </div>
            <div id="friends_list" class="accordion-body">
                <ul>
                    <li v-for="friend in friends">
                        <div class="accordion-btn bg-263238-d">
                            <span>{{ friend.name }}</span>
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
            friends: [],
            visible: false
        }
    },
    methods: {

    },
    created() {
        this.$events.$on("open_friends", () => {
            this.visible = true
            setTimeout(() => {
                let el = document.getElementsByClassName("accordion-header")[0]
                let data = el.getAttribute("data")
                let body = document.getElementById(data)
                body.style.maxHeight = "500px"
            }, 300)
        })
        this.$events.$on("close_friends", () => {
            let el = document.getElementsByClassName("accordion-header")[0]
            let data = el.getAttribute("data")
            let body = document.getElementById(data)
            body.style.maxHeight = "0px"
            setTimeout(() => {
                this.visible = false
            }, 300)
        })
        this.$events.$on("on_friends_list_updates", (friends) => {
            this.friends = friends
        })
    }
}
</script>

<style>

</style>
