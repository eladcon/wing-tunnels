import type WebSocket from "ws";
import { ForwardResponseMessage } from "./messages.mjs";

export interface ForwardRequestMessageProps {
  ws: WebSocket;
  message: ForwardResponseMessage;
}

export const forwardResponse = ({ws, message}: ForwardRequestMessageProps) => {
  ws.send(JSON.stringify(message));
}
