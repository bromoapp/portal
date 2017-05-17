<template>
    <div>
        <div class="panel accordion">
            <div class="panel-heading accordion-header" 
                v-on:click="onHeaderClicked"
                data="friends_list">
                <font>Friends</font>
            </div>
            <div id="friends_list" class="panel-body accordion-body">
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
                <font>Rooms</font>
            </div>
            <div id="rooms_list" class="panel-body accordion-body">
                List of rooms
            </div>
        </div>
        <div class="panel accordion">
            <div class="panel-heading accordion-header" 
                v-on:click="onHeaderClicked"
                data="options_list">
                <font>Options</font>
            </div>
            <div id="options_list" class="panel-body accordion-body">
                List of options
            </div>
        </div>
    </div>
</template>

<script>
let opened;

export default {
    methods: {
        onHeaderClicked() {
            let el = event.target
            let data = el.getAttribute("data")
            
            if (opened) {
                if (opened.getAttribute("id") == data) {
                    opened.style.display = "none"
                    opened = null;
                } else {
                    opened.style.display = "none"
                    opened = document.getElementById(data)
                    opened.style.display = "inline"
                }
            } else {
                opened = document.getElementById(data)
                opened.style.display = "inline"
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
    margin: 1px 1px 0px 1px; 
    width: 100%;
}

.accordion-header:hover {
    background-color: #5bc0de;
    cursor: hand;
}

.accordion-header {
    background-color: #428bca;
    border-radius: 0;
}

.accordion-body .on {
    display: block;
}

.accordion-body {
    display: none;
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

#main {
    transition: margin-left margin-top .5s;
    padding: 20px;
}
</style>
