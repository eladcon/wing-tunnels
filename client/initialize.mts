import type WebSocket from 'ws';
import { InitializeMessage } from './messages.mjs';

export interface InitializeProps {
  subdomain: string | undefined;
  ws: WebSocket;
}

export const initialize = ({ ws, subdomain }: InitializeProps) => {
  const message: InitializeMessage = {
    action: "INITIALIZE",
    subdomain
  }

  ws.send(JSON.stringify(message));
}
