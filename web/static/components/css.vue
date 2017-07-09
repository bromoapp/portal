<template>
    <div>
    </div>
</template>

<script>
export default {

}
</script>

<style>
/************************** Common styles **************************/
.container-lobby {
    margin-left: auto;
    margin-right: auto;
    max-width: 100%;
}

.container-login-register {
    margin-left: auto;
    margin-right: auto;
    max-width: 500px;
}

/************************** Main window styles **************************/
.main-window {
    transition: 0.3s ease;
    position: fixed;
    height: 100%;
    width: 100%;
    top: 0;
    left: 0;
}

/************************** Webcam styles **************************/
#cam_video {
    width: 280px;
    height: 210px;
    transition: 0.5s;
}

/************************** Float panel styles **************************/
.float-panel {
    position: fixed;
    width: 0;
    z-index: 2;
    top: 0;
    overflow-x: hidden;
    overflow-y: hidden;
    padding-top: 0px;
    transition: 0.3s ease;
}

.float-panel-cover {
    position: fixed;
    width: 0;
    z-index: 3;
    top: 0;
    overflow-x: hidden;
    overflow-y: hidden;
    padding-top: 0px;
    transition: 0.3s ease;
}

/************************** Friend detail panel styles **************************/
.friend-profile {
    margin-top: 25px;
    padding: 10px;
}

.friend-image {
    text-align: center;
    margin-bottom: 10px;
}

.friend-details {
    padding: 5px;
}

/************************** Chat dialog styles **************************/
.chat-dialog {
    margin: 6px 10px 10px 10px;
}

.chat-conversation {
    background: #d8d6d6;
    width: 380px;
    height: 300px;
    min-width: 380px;
    max-width: 380px;
    min-height: 300px;
    max-height: 300px;
    margin-bottom: 5px;
    color: black;
    padding: 10px;
    overflow-y: scroll;
    overflow-x: hidden;
}

.chat-separator {
    margin-top: 25px;
    margin-bottom: 25px;
    text-align: center;
    border-bottom: 1px solid #fff;
    line-height: 0.1em;
}

.chat-separator span {
    background: #d8d6d6;
    padding: 10px;
}

.chat-bubble {
    border-radius: 5px;
    border: 1px solid white;
    background: white;
    padding: 5px;
    display: inline-block;
    max-width: 260px;
}

.chat-bubble-me {
    border-radius: 5px;
    border: 1px solid #455A64;
    color: white;
    background: #455A64;
    padding: 5px;
    display: inline-block;
    max-width: 260px;
    margin-left: auto;
    margin-right: 0;
}

.chat-message {
    min-width: 316px;
    max-width: 316px;
    min-height: 50px;
    max-height: 50px;
}

.chat-dialog button {
    min-width: 60px;
    max-width: 60px;
    min-height: 50px;
    max-height: 50px;
}

.chat-new-msg {
    color: #ffb300;
}

/************************** Sidebar styles **************************/
.sidebar {
    height: 100%;
    width: 0;
    position: fixed;
    z-index: 2;
    top: 0;
    left: 0;
    overflow-x: hidden;
    overflow-y: hidden;
    padding-top: 0px;
    transition: 0.3s ease;
}

.sidebar-cover {
    height: 100%;
    width: 0;
    position: fixed;
    z-index: 3;
    top: 0;
    left: 0;
    overflow-x: hidden;
    overflow-y: hidden;
    padding-top: 0px;
    transition: 0.3s ease;
}

.sidebar-close {
    z-index: 4;
    position: absolute;
    top: 8px;
    right: 8px;
}

.sidebar-toolbar {
    width: 100%;
    position: absolute;
    top: 8px;
    left: 8px;
}

.video-cam {
    margin: 50px 1px 0px 1px;
}

.video-cam .overlay-buttons {
    position: absolute;
    display: block;
    width: 100%;
    margin-left: 8px;
    text-align: left;
    top: 225px;
}

.video-cam .overlay-buttons a {
    border-style: solid;
    border-width: 1px;
    border-radius: 3px;
    font-size: 18px;
    padding: 5px;
}

@media screen and (max-height: 450px) {
    .sidebar {
        padding-top: 15px;
    }
    .sidebar a {
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
    position: relative;
}

.accordion-header-btns {
    font-weight: normal;
    position: absolute;
    top: 3px;
    right: 5px;
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

.accordion-btn .icon {
    margin-right: 20px;
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
    transition: opacity .3s ease;
}

.popup-wrapper {
    display: table-cell;
    vertical-align: middle;
}

.popup-container {
    position: relative;
    width: 300px;
    height: 150px;
    margin: 0px auto;
    background-color: #000;
    transition: all .3s ease;
}

.popup-header {
    position: relative;
    padding: 8px 0px 4px 10px;
    color: #fff;
    font-size: 18px;
}

.popup-body {
    padding: 20px;
    color: #fff;
    height: 100px;
    font-size: 14px;
    text-align: center;
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

.popup-close:hover {
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

.slide-in {
    transition: 0.4s ease;
    max-height: 0;
    padding: 0px 0px 0px 10px;
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

.bg-highlight-d {
    transition: 0.4s ease;
    color: white;
    background-color: #ffb300;
}

.bg-highlight-d:hover {
    transition: 0.4s ease;
    color: white;
    background-color: #37474f;
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
    color: white;
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

.bg-1976D2-d {
    transition: 0.4s ease;
    color: white;
    background-color: #1565C0;
}

.bg-1976D2-d:hover {
    color: white;
    background-color: #37474f;
}

.bg-455A64-s {
    color: #fff;
    background-color: #455A64;
}

.cl-ffffff-d {
    transition: 0.4s ease;
    color: #fff;
}

.cl-ffffff-d:hover {
    color: #f50057;
}

.cl-f50057-d {
    color: #f50057;
}

.cl-f50057-d:hover {
    color: #fff;
}
</style>
