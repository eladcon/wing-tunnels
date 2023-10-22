pub interface IWebSocketsApi {
  onConnect(fn: inflight (str): void);
  onDisconnect(fn: inflight (str): void);
  onMessage(fn: inflight (str, str): void);
  initialize();
  inflight send(connectionId: str, message: str): void;
  inflight url(): str;
}
