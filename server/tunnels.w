bring cloud;
bring util;
bring "./websockets/websockets.types.w" as types;
bring "./websockets/websockets.w" as websockets;
bring "./connections.w" as conn;
bring "./proxyapi/proxyapi.w" as proxyapi;
bring "./proxyapi/proxyapi.types.w" as proxytypes;

struct Message {
  action: str;
}

struct InitializeMessage extends Message {
  subdomain: str?;
}

struct InitializedMessage extends Message {
  domain: str;
}

struct ForwardRequestMessage extends Message {
  requestId: str;
  path: str;
  method: str;
  headers: Map<str>?;
  body: str?;
}

struct ForwardResponseMessage extends Message {
  requestId: str;
  status: num;
  path: str;
  method: str;
  headers: Map<str>?;
  body: str?;
}

pub class TunnelsApi {
  ws: types.IWebSocketsApi;
  api: proxyapi.ProxyApi;
  init(props: proxytypes.ProxyApiProps) {
    let connections = new conn.Connections();
    this.ws = new websockets.WebSocketsApi();

    this.api = new proxyapi.ProxyApi(inflight (event: proxytypes.IProxyApiEvent): proxytypes.IProxyApiResponse => {
      let connection = connections.findConnectionBySubdomain(event.subdomain);
      if connection == nil {
        return {
          statusCode: 404,
          body: "Subdomain Not Found",
        };
      }

      let requestId = util.nanoid();
      let var body = event.body;
      if let b = body {
        body = TunnelsApi.toBase64(b);
        log("forward body ${body}");
      }
      this.ws.send(connection?.connectionId ?? "", Json.stringify(ForwardRequestMessage{
        action: "FORWARD_REQUEST",
        requestId: requestId,
        path: event.path,
        method: event.httpMethod,
        headers: event.headers,
        body: body
      }));
      
      log("${event}");

      let found = util.waitUntil(inflight () => {
        let req = connections.findResponseForRequest(requestId);
        return req != nil;
      }, timeout: 10s);

      if (!found) {
        return {
          statusCode: 500,
          body: "No Server Response",
        };
      }

      let req = MutJson connections.findResponseForRequest(requestId);
      if let body = req.tryGet("body") {
        req.set("body", TunnelsApi.fromBase64(body.asStr()));
      }
      let response = ForwardResponseMessage.fromJson(req);
      connections.removeResponseForRequest(requestId);

      return {
        statusCode: response.status,
        body: response.body,
        headers: response.headers
      };
    }, props) as "tunnels public endpoint";
    
    
    this.ws.onConnect(inflight (connectionId: str) => {
      connections.addConnection(connectionId);
    });
    
    this.ws.onDisconnect(inflight (connectionId: str) => {
      connections.removeConnection(connectionId);
    });
    
    this.ws.onMessage(inflight (connectionId: str, message: str) => {
      log("onMessage: ${connectionId} ${message}");
    
      let jsn = Json.tryParse(message);
      if jsn == nil {
        return;
      }
    
      let msg = Message.tryFromJson(jsn);
      if msg == nil {
        return;
      }
    
      if msg?.action == "INITIALIZE" {
        let initialize = InitializeMessage.fromJson(jsn);
        let subdomain = initialize.subdomain ?? util.nanoid(alphabet: "0123456789abcdefghij", size: 10);
        connections.updateConnectionWithSubdomain(conn.Connection{
          connectionId: connectionId,
          subdomain: subdomain
        });
        
        this.ws.send(connectionId, Json.stringify(InitializedMessage{
          action: "INITIALIZED",
          domain: subdomain
        }));
      } elif msg?.action == "FORWARD_RESPONSE" {
        let response = ForwardResponseMessage.fromJson(jsn);
        connections.addResponseForRequest(response.requestId, response);
      }
    });

    this.ws.initialize();
  }

  pub inflight wsUrl(): str {
    return this.ws.url();
  }

  pub inflight apiUrl(): str {
    return this.api.url();
  }

  extern "./base64.mts" static inflight fromBase64(data: str): str;
  extern "./base64.mts" static inflight toBase64(data: str): str;
}
