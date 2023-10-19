import type WebSocket from 'ws';
import { Action, ForwardRequestMessage, InitializedMessage } from './messages.mjs';
import { Events, eventHandler } from './events.mjs';
import forwardRequest from './forward-request.mjs';

export interface OnMessageProps {
  ws: WebSocket;
  port: number;
  hostname?: string;
}

export const onMessage = ({ ws, port, hostname }: OnMessageProps) => {
  return (data: WebSocket.RawData) => {
    const raw = data.toString("utf8");
    try {
      const json = JSON.parse(raw);
      const action: Action = json.action;
      if (action === "INITIALIZED") {
        const msg = json as InitializedMessage;
        eventHandler.emit(Events.DomainAssigned, msg.domain);
      } else if (action === "FORWARD_REQUEST") {
        const msg = json as ForwardRequestMessage;
        forwardRequest({ message: msg, ws, port, hostname });
      }
    } catch (err) {
      console.error("onMessage failure", raw, err.toString());
    }
  }
}
