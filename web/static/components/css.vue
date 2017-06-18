<template>
    
</template>

<script>
export default {

}
</script>

<style>
/* Webcam styles */

#cam_video {
    width: 280px;
    height: 210px;
    transition: 0.5s;
}

#cam_canvas {
    width: 280px;
    height: 210px;
    display: none;
}

/* Sidenav styles */
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
    transition: 0.5s ease;
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
    transition: 0.5s ease;
}

.closebtn {
    z-index: 3;
    position: absolute;
    top: 8px;
    right: 8px;
}

.toolbar {
    width: 100%;
    position: absolute;
    top: 8px;
    left: 8px;
}

.toolbar-button {
    display: inline-block;
}

#main {
    transition-property: width;
    transition: margin-left .5s;
    padding: 20px;
}

.video-cam {
    margin: 50px 1px 0px 1px;
}

@media screen and (max-height: 450px) {
    .sidenav {
        padding-top: 15px;
    }
    .sidenav a {
        font-size: 18px;
    }
}

/* Navgroup styles */
.accordion {
    border: none; 
    outline: none;
    margin: 1px 1px 1px 1px;
}

.accordion-header {
    transition: 0.4s ease;
    border-radius: 0;
    cursor: pointer;
    color: white;
    font-size: 16px;
    font-weight: bold;
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
	transition: 0.4s ease;
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

/* Popup styles */
.modal-mask {
    position: fixed;
    z-index: 9998;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, .5);
    display: table;
    transition: opacity .3s ease;
}

.modal-wrapper {
    display: table-cell;
    vertical-align: middle;
}

.modal-container {
    width: 400px;
    height: 300px;
    margin: 0px auto;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
    transition: all .3s ease;
    font-family: Helvetica, Arial, sans-serif;
}

.modal-header h3 {
    margin-top: 0;
    color: #42b983;
}

.modal-body {
    margin: 10px 0;
}

.modal-default-button {
    float: right;
}

.modal-enter {
    opacity: 0;
}

.modal-leave-active {
    opacity: 0;
}

.modal-enter .modal-container,
.modal-leave-active .modal-container {
    -webkit-transform: scale(1.1);
    transform: scale(1.1);
}
</style>
