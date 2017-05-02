let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            socket.connect()

            let username = element.getAttribute("data-username")
            let userChannel = socket.channel("room:" + username)
            userChannel.join()
        }
    }
}
export default lobby