import WebSocket from 'ws';
import { initialize } from './initialize.mjs';
import { eventHandler, Events } from './events.mjs';
import { onMessage } from './onmessage.mjs';

export interface ConnectProps {
  port: number;
  subdomain?: string;
  wsServer?: string;
  hostname?: string;
}

export const connect = (props: ConnectProps) => {
  return new Promise((resolve, reject) => {
    const ws = new WebSocket(props.wsServer ?? "ws://127.0.0.1:8080");
    if (ws.readyState === 1) {
      initialize({ ws, subdomain: props.subdomain });
    } else {
      ws.on("open", () => {
        initialize({ ws, subdomain: props.subdomain });
      });
    }

    ws.on("message", (data) => {
      const onMessageImpl = onMessage({ ws, port: props.port, hostname: props.hostname });
      onMessageImpl(data);
    });

    eventHandler.on(Events.DomainAssigned, (domain: string) => {
      resolve({ domain, close: () => {
        ws.close();
      } });
    });
  })
};
