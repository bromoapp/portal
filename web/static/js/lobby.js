let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            socket.connect()

            let lobbyChannel = socket.channel("channel:lobby")
            lobbyChannel.join()
        }
    }
}
export default lobby