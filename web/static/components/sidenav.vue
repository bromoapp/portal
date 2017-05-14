<template>
    <div class="acc-root">
        <button class="acc-btn" 
            v-on:click="onPanelHeaderClick">Section 1</button>
        <div class="acc-panel">
            <p>Lorem ipsum...</p>
        </div>
        <button class="acc-btn" 
            v-on:click="onPanelHeaderClick">Section 2</button>
        <div class="acc-panel">
            <p>Lorem ipsum...</p>
        </div>
        <button class="acc-btn" 
            v-on:click="onPanelHeaderClick">Section 3</button>
        <div class="acc-panel">
            <p>Lorem ipsum...</p>
        </div>
        <button class="acc-btn" 
            v-on:click="onPanelHeaderClick">Section 4</button>
        <div class="acc-panel">
            <p>Lorem ipsum...</p>
        </div>
        <button class="acc-btn" 
            v-on:click="onPanelHeaderClick">Section 5</button>
        <div class="acc-panel">
            <p>Lorem ipsum...</p>
        </div>
    </div>
</template>

<script>
let curr_panel = null

export default {
    methods: {
        onPanelHeaderClick(event) {
            if (curr_panel) {
                if (curr_panel.style.display === "block") {
                    curr_panel.style.display = "none"
                } else {
                    curr_panel.style.display = "block"
                }
            }
            let el = event.target
            el.classList.toggle("active")

            var panel = el.nextElementSibling
            if (panel.style.display === "block") {
                panel.style.display = "none"
            } else {
                panel.style.display = "block"
            }
            curr_panel = panel
        }
    }
}
</script>

<style>
.acc-root {
    overflow: hidden;
}
 /* Style the buttons that are used to open and close the accor-btn-panel panel */
button.acc-btn {
    background-color: #eee;
    color: #444;
    cursor: pointer;
    height: 30px;
    width: 100% !important;
    text-align: left;
    border: none;
    outline: none;
    transition: 0.4s;
}

/* Add a background color to the button if it is clicked on (add the .active class with JS), and when you move the mouse over it (hover) */
button.acc-btn.active, button.acc-btn:hover {
    background-color: #ddd;
}

/* Style the accordion panel. Note: hidden by default */
div.acc-panel {
    background-color: white;
    display: none;
}
</style>
