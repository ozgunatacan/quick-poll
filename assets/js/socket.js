import {Socket} from "phoenix"

  //let socket = new Socket("/socket", {params: {token: window.userToken}})
  const socket = new Socket("/socket");

if (document.querySelector('#poll-results')) {
  socket.connect()
  
  const poll_id = document.querySelector("#poll-results").dataset.id

  const channel = socket.channel("results:" + poll_id, {})
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { 
      console.log("Unable to join", resp)
      if(resp.reason == "poll_not_found") {
        channel.leave()
      }
    })

  channel.on("results", (response) => {
    console.log(response)
  });
}

export default socket
