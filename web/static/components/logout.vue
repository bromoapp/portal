<template>
    <form action="/web/sessions/signout" class="link" method="post">
        <input name="_method" type="hidden" value="delete">
        <input name="_csrf_token" type="hidden" v-bind:value="csrf_token">
        <a class="pull-right btn btn-danger" data-submit="parent" href="#" id="btn_out" rel="nofollow">Sign out</a>
    </form>
</template>

<script>
export default {
    data() {
        return {
            csrf_token: window.csrfToken
        }
    }
}
</script>

<style>
</style>