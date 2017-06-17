<template>
    <div id="side_nav" class="sidenav">
        <div>
            <div class="outer">
                <div class="inner">
                    <button class="btn btn-primary">
                        <i class="fa fa-sign-out"></i>
                    </button>
                </div>
                <div class="inner">
                    <button class="btn btn-primary">
                        <i class="fa fa-search"></i>
                    </button>
                </div>
                <div class="inner">
                    <button class="btn btn-primary">
                        <i class="fa fa-envelope-o"></i>
                    </button>
                </div>
            </div>
            <button id="switch" class="btn btn-primary closebtn" v-on:click="changeMode">
                <i class=""></i>
            </button>
        </div>
        <div id="video_cam" class="video-cam">
            <webcam></webcam>
        </div>
        <navgroup></navgroup>
        <div id="side_nav_cover" class="sidenav-cover"></div>
    </div>
</template>

<script>
import Vue from 'vue'
import VueEvents from 'vue-events'
Vue.use(VueEvents)

import Webcam from "./webcam.vue"
import Navgroup from "./navgroup.vue"

let closed = false

export default {
    components: {
        Webcam,
        Navgroup
    },
    data() {
        return {
            maxWidth: this.$parent.maxWidth,
            minWidth: this.$parent.minWidth
        }
    },
    methods: {
        changeMode() {
            if (closed) {
                this._open()
            } else {
                this._close()
            }
        },
        _close() {
            document.getElementById("side_nav").style.width = this.minWidth + "px"
            document.getElementById("side_nav_cover").style.width = this.minWidth + "px"
            setTimeout(function () {
                document.getElementById("switch").classList.add("fa", "fa-chevron-right")
                document.getElementById("switch").classList.remove("fa-chevron-left")
                document.getElementById("switch").blur()
            }, 500)

            closed = true
        },
        _open() {
            document.getElementById("side_nav").style.width = this.maxWidth + "px"
            document.getElementById("side_nav_cover").style.width = "0px"
            setTimeout(function () {
                document.getElementById("switch").classList.add("fa", "fa-chevron-left")
                document.getElementById("switch").classList.remove("fa-chevron-right")
                document.getElementById("switch").blur()
            }, 500);

            closed = false
        }
    },
    mounted() {
        this._open()
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

.closebtn {
    z-index: 3;
    position: absolute;
    top: 8px;
    right: 8px;
}

.outer {
    width: 100%;
    position: absolute;
    top: 8px;
    left: 8px;
}

.inner {
    display: inline-block;
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
    box-shadow: 0 0.4em 0 0 white,
    0 0.8em 0 0 white;
}

/* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */

@media screen and (max-height: 450px) {
    .sidenav {
        padding-top: 15px;
    }
    .sidenav a {
        font-size: 18px;
    }
}
</style>
