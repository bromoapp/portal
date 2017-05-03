let lobby = {
    init(socket, element) {
        if (!element) {
            return
        } else {
            socket.connect()

            let roomsChannel = socket.channel("channel:rooms")
            roomsChannel.join()
        }
    }
}
export default lobby