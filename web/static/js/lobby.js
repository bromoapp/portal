let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            socket.connect()
            let username = element.getAttribute("data-username")
            let lobbyChannel = socket.channel("lobby:" + username)
            lobbyChannel.join()
        }
    }
}
export default lobby