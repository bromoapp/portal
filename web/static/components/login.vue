<template>
    <div class="container-login-register">
        <h1 class="form-label">Login</h1>
        <div class="form-group">
            <input class="form-control"
                id="session_username" 
                v-bind:name="unameFieldName" 
                v-bind:placeholder="unamePlaceholder" 
                v-bind:type="unameFieldType">
        </div>
        <div class="form-group">
            <input class="form-control"
                id="session_password" 
                v-bind:name="paswdFieldName" 
                v-bind:placeholder="paswdPlaceholder" 
                v-bind:type="paswdFieldType">
        </div>
        <span class="pull-right">
            <a class="btn btn-danger"
                v-on:click="doSubmit">Submit</a>
            <a class="btn btn-default" 
                v-on:click="doCancel">Cancel</a>
        </span>
    </div>
</template>

<script>
export default {
    computed: {
        unameFieldName() {
            return this.$parent.unameFieldName
        },
        unamePlaceholder() {
            return this.$parent.unamePlaceholder
        },
        unameFieldType() {
            return this.$parent.unameFieldType
        },
        paswdFieldName() {
            return this.$parent.paswdFieldName
        },
        paswdPlaceholder() {
            return this.$parent.paswdPlaceholder
        },
        paswdFieldType() {
            return this.$parent.paswdFieldType
        },
    },
    methods: {
        doCancel() {
            this.$parent.doCancel()
        },
        doSubmit() {
            this.$parent.doSubmit()
        }
    }
}
</script>

<style>
</style>