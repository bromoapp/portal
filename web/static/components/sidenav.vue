<template>
    <div class="togglebox">
        <div>
            <input id="radio1" type="radio" name="toggle" checked="checked"/>
            <label for="radio1">Online Friends</label>
            <div class="content">
            <p>Cupcake ipsum dolor sit. Amet candy chocolate bar croissant marzipan toffee danish. Chocolate cake jujubes liquorice topping marzipan.</p>
            <p>Macaroon bonbon sugar plum macaroon I love I love liquorice marzipan. Lemon drops I love caramels cheesecake croissant.</p>
            </div>
        </div>
        <div>
            <input id="radio2" type="radio" name="toggle"/>
            <label for="radio2">Offline Friends</label>
            <div class="content">
            <p>Cupcake ipsum dolor sit. Amet candy chocolate bar croissant marzipan toffee danish. Chocolate cake jujubes liquorice topping marzipan.</p>
            <p>Macaroon bonbon sugar plum macaroon I love I love liquorice marzipan. Lemon drops I love caramels cheesecake croissant.</p>
            </div>
        </div>
        <div>
            <input id="radio3" type="radio" name="toggle"/>
            <label for="radio3">Favorite Rooms</label>
            <div class="content">
            <p>Cupcake ipsum dolor sit. Amet candy chocolate bar croissant marzipan toffee danish. Chocolate cake jujubes liquorice topping marzipan.</p>
            <p>Macaroon bonbon sugar plum macaroon I love I love liquorice marzipan. Lemon drops I love caramels cheesecake croissant.</p>
            </div>
        </div>
        <div>
            <input id="radio4" type="radio" name="toggle"/>
            <label for="radio4">Public Rooms</label>
            <div class="content">
            <p>Cupcake ipsum dolor sit. Amet candy chocolate bar croissant marzipan toffee danish. Chocolate cake jujubes liquorice topping marzipan.</p>
            <p>Macaroon bonbon sugar plum macaroon I love I love liquorice marzipan. Lemon drops I love caramels cheesecake croissant.</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    
}
</script>

<style>
@import url("http://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.css");

:before,
:after {
    content: '';
    display: block;
    position: absolute;
    box-sizing: border-box;
}

.togglebox {
    width: 240px;
    height: 373px;
    margin: 0 auto;
    background: #3c566f;
}

input[type="radio"] {
    position: absolute;
    opacity: 0;
}

label {
    position: relative;
    display: block;
    height: 50px;
    line-height: 50px;
    padding: 0 20px;
    font-size: 14px;
    font-weight: bold;
    color: rgba(255, 255, 255, 0.5);
    background: #2e4155;
    cursor: pointer;
}

label:hover {
    background: #1f2d3a;
}

label:after {
    content: '\f078';
    top: 0px;
    right: 20px;
    font-family: fontawesome;
}

.content {
    height: 0;
    overflow: hidden;
}

input[type="radio"]:checked ~ label {
    color: rgba(255, 255, 255, 0.8);
}

input[type="radio"]:checked ~ label:after {
    transform: rotate(90deg);
    -moz-transform: rotate(90deg);
    -o-transform: rotate(90deg);
    -ms-transform: rotate(90deg);
    -webkit-transform: rotate(90deg);
}

input[type="radio"]:checked ~ .content {
    height: 150px;
}

p {
    margin: 15px 0;
    padding: 0 20px;
    font-size: 11px;
    line-height: 1.5;
    color: rgba(255, 255, 255, 0.8);
}
</style>
