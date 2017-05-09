<template>
    <form accept-charset="UTF-8" action="/web/users" method="post">
        <input name="_csrf_token" v-bind:value="csrf_token" type="hidden">
        <input name="_utf8" value="✓" type="hidden">
        <div class="container-login-register">
            <h1 class="form-label">New User</h1>
            <div class="form-group">
                <input class="form-control" 
                    id="user_name" 
                    name="user[name]" 
                    placeholder="Name" 
                    type="text">            
            </div>
            <div class="form-group">
                <input class="form-control" 
                    id="user_username" 
                    name="user[username]" 
                    placeholder="Username" 
                    type="text">            
            </div>
            <div class="form-group">
                <input class="form-control" 
                    id="user_password" 
                    name="user[password]" 
                    placeholder="Password" 
                    type="password">            
            </div>
            <span class="pull-right">
                <button class="btn btn-primary" 
                    type="submit">Create</button>
                <a class="btn btn-default" 
                    href="/web">Cancel</a>
            </span>
        </div>
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