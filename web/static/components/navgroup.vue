<template>
    <div>
        <div class="panel accordion">
            <div class="panel-heading accordion-header" 
                v-on:click="onHeaderClicked"
                data="friends_list">
                Friends
            </div>
            <div id="friends_list" class="accordion-body">
                <ul>
                    <li v-for="friend in friends">
                        <div class="accordion-btn">
                            <span>{{ friend.name }}</span><span class="pull-right" style="margin-right: 10px;">+</span>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <div class="panel accordion">
            <div class="panel-heading accordion-header" 
                v-on:click="onHeaderClicked"
                data="rooms_list">
                Rooms
            </div>
            <div id="rooms_list" class="accordion-body">
                <ul>
                    <li v-for="room in rooms">
                        <div class="accordion-btn">{{ room.name }}</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
let opened
let accordionMaxHeight = 250

export default {
    data() {
        return {
            friends: [],
            rooms: [],
        }
    },
    methods: {
        onHeaderClicked(event) {
            let el = event.target
            let data = el.getAttribute("data")
            let body = document.getElementById(data)

            if (opened) {
                if (opened.getAttribute("id") == data) {
                    body.style.maxHeight = null
                    opened = null
                } else {
                    body.style.maxHeight = accordionMaxHeight + "px"
                    opened.style.maxHeight = null
                    opened = body
                }
            } else {
                opened = body
                body.style.maxHeight = accordionMaxHeight + "px"
            }
        }
    },
    created() {
        this.$events.$on("on_friends_list_updates", (friends) => {
            this.friends = friends
        })
        this.$events.$on("on_rooms_list_updates", (rooms) => {
            this.rooms = rooms
        })
    }
}
</script>

<style>

</style>
