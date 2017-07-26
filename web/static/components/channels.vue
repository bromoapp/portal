<template>
    <div v-if="visible">
        <div class="panel accordion">
            <div class="panel-heading accordion-header bg-37474f-s">
                Channels
                <div class="accordion-header-btns">
                    <a title="Add new channel" id="add_channel_btn" href="javascript:" v-on:click="addChannel" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-plus"></i>
                    </a>
                    <a title="Search channel" id="src_channel_btn" href="javascript:" v-on:click="seekChannel" class="btn bg-37474f-d">
                        <i id="header_btn" class="fa fa-search"></i>
                    </a>
                </div>
            </div>
            <div v-if="src_form_visible" id="seek_channel" class="bg-212121-s slide-in">
                <div style="margin: 0px 17px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Channel's name:</span>
                    <input id="search_args" class="form-control" type="text" placeholder="Name">
                </div>
            </div>
            <div v-if="add_form_visible" id="add_channel" class="bg-212121-s slide-in">
                <div style="margin: 0px 15px 0px 19px; padding: 10px 15px 10px 0px">
                    <span style="color: white">Search channel:</span>
                    <div class="form-inline">
                        <input id="chname_args" class="form-control" type="text" placeholder="Email">
                        <a title="Search channel" v-on:click="doSearch" class="btn bg-1976D2-d">
                            <i class="fa fa-search"></i>
                        </a>
                    </div>
                </div>
            </div>
            <div id="items_list" class="accordion-body">
                <ul>
                    <li v-for="ch in channels" v-bind:key="ch">
                        <div v-on:click="onChannelClicked(ch)" class="accordion-btn bg-263238-d">
                            <span>{{ ch }}</span>
                            <span class="pull-right icon">
                                <i class="fa fa-window-maximize"></i>
                            </span>
                        </div>
                    </li>
                    <li v-if="channels.length > 2">
                        <div class="accordion-btn bg-212121-s">&nbsp;</div>
                    </li>
                    <li v-else>
                        <div style="height: 150px;" class="accordion-btn bg-212121-s">&nbsp;</div>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    <div v-else></div>
</template>

<script>
export default {
    data() {
        return {
            channels: ["Classic 90's Songs",
                "Classic Balads", "Tiesto Concert",
                "Double Six Bali", "Ex Komplek Zeni",
                "Jakarta Indie TV", "Keluarga Sarya"],
            visible: false,
            src_form_visible: false,
            add_form_visible: false,
        }
    },
    created() {
        this.$events.$on(this.WINDOW_RESIZING, () => { this._onWindowResizing() })
        this.$events.$on(this.OPEN_CHANNELS, () => { this._openChannelsList() })
        this.$events.$on(this.CLOSE_CHANNELS, () => { this._closeChannelsList() })
        this.$events.$on(this.UPDATE_CHANNELS_LIST, (list) => { this._updateChannelsList(list) })
    },
    methods: {
        _onWindowResizing() {
            let body = document.getElementById("items_list")
            body.style.display = "none"
            setTimeout(() => {
                body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                body.style.overflowY = "auto"
                body.style.display = "block"
            }, 200)
        },
        _updateChannelsList(list) {
            this.channels = list
        },
        _closeChannelsList() {
            setTimeout(() => {
                this.visible = false
                this.src_form_visible = false
                this.add_form_visible = false
            }, 300)
        },
        _openChannelsList() {
            setTimeout(() => {
                this.visible = true
                setTimeout(() => {
                    let body = document.getElementById("items_list")
                    body.style.maxHeight = (window.innerHeight - this.TOP_MARGIN) + "px"
                }, 200)
            }, 300)
        },
        addChannel() {
            document.getElementById("add_channel_btn").blur()
            if (this.add_form_visible) {
                let div = document.getElementById("add_channel")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.add_form_visible = false
                }, 200)
            } else {
                if (this.src_form_visible) {
                    this.seekChannel()
                }
                setTimeout(() => {
                    this.add_form_visible = true
                    setTimeout(() => {
                        let div = document.getElementById("add_channel")
                        div.style.maxHeight = "100px"

                        let inputEl = document.getElementById("chname_args")
                        inputEl.focus()
                    }, 150)
                }, 150);
            }
        },
        doSearch() {

        },
        seekChannel() {
            document.getElementById("src_channel_btn").blur()
            if (this.src_form_visible) {
                let div = document.getElementById("seek_channel")
                div.style.maxHeight = "0px"
                setTimeout(() => {
                    this.src_form_visible = false
                }, 200)
            } else {
                if (this.add_form_visible) {
                    this.addChannel()
                }
                setTimeout(() => {
                    this.src_form_visible = true
                    setTimeout(() => {
                        let div = document.getElementById("seek_channel")
                        div.style.maxHeight = "100px"

                        let inputEl = document.getElementById("search_args")
                        inputEl.focus()
                    }, 150)
                }, 150);
            }
        },
        onChannelClicked(ch) {
            if (this.src_form_visible) {
                this.seekChannel()
            }
        }
    }
}
</script>

<style>

</style>
