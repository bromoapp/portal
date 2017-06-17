<template>
    <form id="logout_form" action="/web/sessions/signout" class="link" method="post">
        <input name="_method" type="hidden" value="delete">
        <input name="_csrf_token" type="hidden" v-bind:value="csrf_token">
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