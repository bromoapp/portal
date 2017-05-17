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
                    <li class="accordion-li">Bromo Kunto Adji</li>
                    <li class="accordion-li">Indra Birowo</li>
                    <li class="accordion-li">Soraya Permatasari</li>
                    <li class="accordion-li">Yunia Maharani</li>
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
                List of rooms
            </div>
        </div>
        <div class="panel accordion">
            <div class="panel-heading accordion-header" 
                v-on:click="onHeaderClicked"
                data="options_list">
                Options
            </div>
            <div id="options_list" class="accordion-body">
                List of options
            </div>
        </div>
    </div>
</template>

<script>
let opened

export default {
    methods: {
        onHeaderClicked() {
            let el = event.target
            el.classList.toggle("active")
            let data = el.getAttribute("data")
            let body = document.getElementById(data)

            if (opened) {
                if (opened.getAttribute("id") == data) {
                    body.style.maxHeight = null
                } else {
                    body.style.maxHeight = "100px"
                    opened.style.maxHeight = null
                    opened = body
                }
            } else {
                opened = body
                body.style.maxHeight = "100px"
            }
        }
    }
}
</script>

<style>
#nav_group {
    transition: 0.5s;
    width: 100%;
}

.accordion {
    border: none; 
    outline: none;
    margin: 1px 1px 1px 1px; 
    width: 100%;
}

.accordion-header {
    background-color: #428bca;
    transition: 0.4s;
    border-radius: 0;
    cursor: pointer;
}

.accordion-header.active .accordion-header:hover {
    background-color: #5bc0de;
}

.accordion-body {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.2s ease-out;
}

.accordion-li { 
    margin: 0px;
    position: relative;
    display: block;
    font-style: italic;
}

.accordion font {
    font-weight: normal;
    font-size: 16px;
    color: #ffffff;
}
</style>
