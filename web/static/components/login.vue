<template>
    <div class="container-login-register">
        <h1>Login</h1>
        <div class="form-group">
            <input class="form-control" 
                id="session_username" 
                name="session[username]" 
                placeholder="Username" 
                type="text">
        </div>
        <div class="form-group">
            <input class="form-control" 
                id="session_password" 
                name="session[password]" 
                placeholder="Password" 
                type="password">
        </div>
        <span class="pull-right">
            <button class="btn btn-primary" 
                type="submit" 
                v-on:click="submit">Submit</button>
            <a class="btn btn-default" href="/web">Cancel</a>
        </span>
    </div>
</template>

<script>
export default {}
</script>

<style>
</style>