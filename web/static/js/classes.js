'use strict'

class GroupChat {
    constructor() {
        this.group = null
        this.channel = null
    }

    init(group, channel) {
        this.group = group
        this.channel = channel
    }

    join() {
        this.channel.join()
            .receive("ok", () => { console.log("Succeed to join user group channel") })
            .receive("error", () => { console.log("Failed to join user group channel") })
    }

    leave() {
        this.channel.leave()
    }
}

export { GroupChat }