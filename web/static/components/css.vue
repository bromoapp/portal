<template>
    
</template>

<script>
export default {

}
</script>

<style>
/************************** Webcam styles **************************/

#cam_video {
    width: 280px;
    height: 210px;
    transition: 0.5s;
}

/************************** Sidenav styles **************************/
.sidenav {
    height: 100%;
    width: 0;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    overflow-x: hidden;
    padding-top: 0px;
    transition: 0.3s ease;
}

.sidenav-cover {
    height: 100%;
    width: 0;
    position: fixed;
    z-index: 2;
    top: 0;
    left: 0;
    overflow-x: hidden;
    padding-top: 0px;
    transition: 0.3s ease;
}

.sidenav-close {
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

/************************** Navgroup styles **************************/
.accordion {
    transition: 0.4s ease;
    border: none; 
    outline: none;
    margin: 1px 1px 1px 1px;
}

.accordion-header {
    transition: 0.4s ease;
    border-radius: 0;
    cursor: pointer;
    color: black;
    font-size: 16px;
    font-weight: bold;
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
	color: white;
    margin-left: 0px;
    padding: 5px 0px 5px 10px;
    position: relative;
    display: block;
}

.accordion font {
    font-weight: normal;
    font-size: 16px;
    color: #ffffff;
}

/************************** Popup styles **************************/
.popup-mask {
    position: fixed;
    z-index: 9998;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, .8);
    display: table;
    transition: opacity .3s ease-in-out;
}

.popup-wrapper {
    display: table-cell;
    vertical-align: middle;
}

.popup-container {
    position: relative;
    width: 500px;
    height: 300px;
    margin: 0px auto;
    background-color: #000;
    transition: all .3s ease-in-out;
    font-family: Helvetica, Arial, sans-serif;
}

.popup-header {
    position: relative;
    padding: 10px;
    color: #fff;
    font-size: 18px;
}

.popup-footer {
    bottom: 0px;
    padding: 0px 10px 10px 0px;
}

.popup-close {
    position: absolute;
    bottom: 14px;
    right: 10px;
    color: #000;
}

.popup-close:hover{
    color: #fff;
}

.fade-enter {
    opacity: 0;
}

.fade-leave-active {
    opacity: 0;
}

.fade-enter .popup-container,
.fade-leave-active .popup-container {
    -webkit-transform: scale(1.1);
    transform: scale(1.1);
}

.inline {
    display: inline-block;
}

.inline a {
    margin-bottom: 4px;
}

/************************** Color styles **************************/
.bg-37474f-d {
    transition: 0.4s ease;
    color: white;
    background-color: #37474f;
}

.bg-37474f-d:hover {
    color: black;
    background-color: #f50057;
}

.bg-37474f-s {
    color: white;
    background-color: #37474f;
}

.bg-f50057-d {
    transition: 0.4s ease;
    color: white;
    background-color: #f50057;
}

.bg-f50057-d:hover {
    color: black;
    background-color: #37474f;
}

.bg-f50057-s {
    color: white;
    background-color: #f50057;
}

.bg-263238-d {
    transition: 0.4s ease;
    color: white;
    background-color: #263238;
}

.bg-263238-d:hover {
    color: black;
    background-color: #d81b60;
}

.bg-263238-s {
    color: white;
    background-color: #263238;
}

.bg-212121-s {
    background-color: #212121;
}
</style>
