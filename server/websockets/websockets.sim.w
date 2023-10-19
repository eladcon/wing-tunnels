bring cloud;
bring util;
bring "./websockets.types.w" as types;

interface StartWebSocketApiResult {
  inflight close(): inflight(): void;
  inflight url(): str;
}

class WebSocketApi impl types.IWebSocketsApi {
  var connectFn: inflight (str): void;
  var disconnectFn: inflight (str): void;
  var onmessageFn: inflight (str, str): void;
  bucket: cloud.Bucket;
  init() {
    this.connectFn = inflight () => {};
    this.disconnectFn = inflight () => {};
    this.onmessageFn = inflight () => {};
    this.bucket = new cloud.Bucket();
  }

  pub onConnect(fn: inflight (str): void) {
    this.connectFn = fn;
  }

  pub onDisconnect(fn: inflight (str): void) {
    this.disconnectFn = fn;
  }

  pub onMessage(fn: inflight (str, str): void) {
    this.onmessageFn = fn;
  }

  // TODO: https://github.com/winglang/wing/issues/4324
  pub initialize() {
    new cloud.Service(inflight () => {
      let res = WebSocketApi.startWebSocketApi(this.connectFn, this.disconnectFn, this.onmessageFn);
      this.bucket.put("url.txt", res.url());
      return () => {
        res.close();
      };
    });
  }

  pub inflight send(connectionId: str, message: str) {
    WebSocketApi.sendMessage(connectionId, message);
  }

  pub inflight url(): str {
    util.waitUntil(inflight () => {
      return this.bucket.exists("url.txt");
    });
    return this.bucket.get("url.txt");
  }

  extern "./websockets-api-local.mts" static inflight startWebSocketApi(
    connectFn: inflight (str): void,
    disconnectFn: inflight (str): void,
    onmessageFn: inflight (str, str): void
  ): StartWebSocketApiResult;
  extern "./websockets-api-local.mts" static inflight sendMessage(
    connectionId: str,
    message: str,
  ): inflight(): void;
}
