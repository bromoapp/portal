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
                        <div class="accordion-btn">{{ friend.name }}</div>
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
        <div class="panel accordion">
            <div class="panel-heading accordion-header" 
                v-on:click="onHeaderClicked"
                data="options_list">
                Options
            </div>
            <div id="options_list" class="accordion-body">
                <ul>
                    <li><div class="accordion-btn">Bromo Kunto Adji</div></li>
                    <li><div class="accordion-btn">Indra Birowo</div></li>
                    <li><div class="accordion-btn">Soraya Permatasari</div></li>
                    <li><div class="accordion-btn">Yunia Maharani</div></li>
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
            friends: []
        }
    },
    computed: {
        rooms() {
            return this.$parent.rooms
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
        this.$events.$on("on_updates_avail", (updates) => {
            this.friends = updates.friends
        })
    }
}
</script>

<style>
.accordion {
    width: 280px;
    border: none; 
    outline: none;
    margin: 1px 1px 1px 1px;
}

.accordion-header {
    transition: 0.4s;
    border-radius: 0;
    cursor: pointer;
    color: white;
    font-size: 16px;
    background-color: #428bca;
}

.accordion-header:hover {
    background-color: #5bc0de;
}

.accordion-body {
    max-height: 0;
    overflow-y: auto;
    overflow-wrap: hidden;
    transition: max-height 0.2s ease-out;
}

.accordion-body ul {
    margin-top: 0;
    margin-bottom: 0;
    padding: 0;
}

.accordion-btn {
    cursor: pointer;
	transition: 0.4s;
	border-top: 1px solid black;
	color: black;
    margin-left: 0px;
    padding: 5px 0px 5px 10px;
    position: relative;
    display: block;
}

.accordion-btn:hover {
    color: white;
	background-color: black;
}

.accordion font {
    font-weight: normal;
    font-size: 16px;
    color: #ffffff;
}
</style>
