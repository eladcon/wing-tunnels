bring util;
bring "./websockets.aws.w" as WebSocketsAws;
bring "./websockets.sim.w" as WebSocketsSim;
bring "./websockets.types.w" as types;

class WebSocketsApi impl types.IWebSocketsApi {
  api: types.IWebSocketsApi;
  init() {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      this.api = new WebSocketsSim.WebSocketApi();
    } elif target == "tf-aws" {
      this.api = new WebSocketsAws.WebSocketApi();
    } else {
      throw "unsupported target ${target}";
    }
  }

  pub onConnect(fn: inflight (str): void) {
    this.api.onConnect(fn);
  }

  pub onDisconnect(fn: inflight (str): void) {
    this.api.onDisconnect(fn);
  }

  pub onMessage(fn: inflight (str, str): void) {
    this.api.onMessage(fn);
  }

  pub initialize() {
    this.api.initialize();
  }

  pub inflight send(connectionId: str, message: str) {
    this.api.send(connectionId, message);
  }

  pub inflight url(): str {
    return this.api.url();
  }
}
