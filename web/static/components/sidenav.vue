<template>
    <div id="side_nav" class="sidenav">
        <button class="btn btn-primary closebtn box-shadow-menu" v-on:click="changeMode">
            &nbsp;
        </button>
        <div id="video_cam" class="video-cam">
            <webcam></webcam>
        </div>
        <navgroup></navgroup>
        <div id="side_nav_cover" class="sidenav-cover"></div>
    </div>
</template>

<script>
import Vue from 'vue'
import Webcam from "./webcam.vue"
import NavGroup from "./navgroup.vue"

let isClosed = false
let sidenavMaxWidth = 282
let sidenavMinWidth = 52

Vue.component("webcam", Webcam)
Vue.component("navgroup", NavGroup)

new Vue({
    render(createElement) {
        return createElement(Webcam, {})
    }
})

new Vue({
    render(createElement) {
        return createElement(NavGroup, {})
    }
})

export default {
    methods: {
        /* Set the width of the side navigation to 250px */
        changeMode() {
            if (isClosed) {
                document.getElementById("side_nav").style.width = sidenavMaxWidth + "px"
                document.getElementById("side_nav_cover").style.width = "0px"
                isClosed = false
            } else {
                document.getElementById("side_nav").style.width = sidenavMinWidth + "px"
                document.getElementById("side_nav_cover").style.width = sidenavMinWidth + "px"
                isClosed = true
            }
        },
    }
}
</script>

<style>
 /* The side navigation menu */
.sidenav {
    height: 100%;
    width: 0;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    background-color: #111;
    overflow-x: hidden;
    padding-top: 0px;
    transition: 0.5s;
}

.sidenav-cover {
    height: 100%;
    width: 0;
    position: fixed;
    z-index: 2;
    top: 0;
    left: 0;
    background-color: #111;
    overflow-x: hidden;
    padding-top: 0px;
    transition: 0.5s;
}

/* Position and style the close button (top right corner) */
.sidenav .closebtn {
    z-index: 3;
    position: absolute;
    top: 8px;
    right: 8px;
}

/* Style page content - use this if you want to push the page content to the right when you open the side navigation */
#main {
    transition-property: width;
    transition: margin-left .5s;
    padding: 20px;
}

.video-cam {
    margin: 50px 1px 0px 1px;
}

.box-shadow-menu {
    position: relative;
    padding-left: 1.25em;
}
.box-shadow-menu:before {
    content: "";
    position: absolute;
    left: 8px;
    top: 10px;
    width: 18px;
    height: 0.1em;
    background: white;
    box-shadow: 
        0 0.4em 0 0 white,
        0 0.8em 0 0 white;
}

/* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
@media screen and (max-height: 450px) {
    .sidenav {padding-top: 15px;}
    .sidenav a {font-size: 18px;}
} 
</style>
