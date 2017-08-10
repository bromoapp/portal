<template>
    <div v-if="panel_visible">
        <div id="gchat_dialog_panel_window" class="float-panel bg-455A64-s">
            <div class="chat-dialog">
                <div style="text-align: right">
                    <span>
                        <a href="javascript:" class="cl-ffffff-d" v-on:click="_close">
                            <i class="fa fa-close"></i>
                        </a>
                    </span>
                </div>
                <div>
                    <label id="chat_to"></label>
                </div>
                <div>
                    <div id="messages" class="chat-conversation"></div>
                </div>
                <div class="inline">
                    <a title="Smiley" href="javascript:" class="btn btn-sm bg-263238-d" v-on:click="onSmiley">
                        <i class="fa fa-smile-o"></i>
                    </a>
                    <a title="Attachment" href="javascript:" class="btn btn-sm bg-263238-d" v-on:click="onAttachment">
                        <i class="fa fa-paperclip"></i>
                    </a>
                </div>
                <div class="form-inline">
                    <textarea id="message" class="chat-message form-control"></textarea>
                    <button class="btn bg-f50057-d" v-on:click="sendMessage">Send</button>
                </div>
            </div>
        </div>
        <div id="gchat_dialog_panel_cover" class="float-panel-cover bg-455A64-s"></div>
    </div>
</template>
<script>
export default {
    data() {
        return {
            currGroup: null,
            height: "450px",
            maxWidth: "400px",
            panel_visible: false
        }
    },
}
</script>

<style>

</style>
