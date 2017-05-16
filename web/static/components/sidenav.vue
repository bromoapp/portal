<template>
    <div id="mySidenav" class="sidenav">
        <button class="btn btn-primary closebtn box-shadow-menu" v-on:click="changeMode">
            &nbsp;
        </button>
        <div id="video_cam" class="video-cam">
            <webcam></webcam>
        </div>
        <navgroup></navgroup>
    </div>
</template>

<script>
import Vue from 'vue'
import Webcam from "./webcam.vue"
import NavGroup from "./navgroup.vue"

let isClosed = false

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
                document.getElementById("mySidenav").style.width = "282px"
                document.getElementById("cam_video").style.width = "280px"
                isClosed = false
            } else {
                document.getElementById("mySidenav").style.width = "54px"
                document.getElementById("cam_video").style.width = "0px"
                isClosed = true
            }
        },
    }
}
</script>

<style>
 /* The side navigation menu */
.sidenav {
    height: 100%; /* 100% Full-height */
    width: 0; /* 0 width - change this with JavaScript */
    position: fixed; /* Stay in place */
    z-index: 1; /* Stay on top */
    top: 0;
    left: 0;
    background-color: #111; /* Black*/
    overflow-x: hidden; /* Disable horizontal scroll */
    padding-top: 0px; /* Place content 60px from the top */
    transition: 0.5s; /* 0.5 second transition effect to slide in the sidenav */
}

/* Position and style the close button (top right corner) */
.sidenav .closebtn {
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
