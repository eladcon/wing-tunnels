export type Action = "INITIALIZE" | "INITIALIZED" | "FORWARD_REQUEST" | "FORWARD_RESPONSE";

export interface InitializeMessage {
  action: "INITIALIZE";
  subdomain: string | undefined;
}

export interface InitializedMessage {
  action: "INITIALIZED";
  domain: string;
}

export interface ForwardRequestMessage {
  action: "FORWARD_REQUEST";
  requestId: string;
  path: string;
  method: string;
  headers: Record<string, string | string[] | undefined>;
  body: string | undefined;
}

export interface ForwardResponseMessage {
  action: "FORWARD_RESPONSE";
  requestId: string;
  status: number | undefined;
  path: string;
  method: string;
  headers: Record<string, string | string[] | undefined>;
  body: string | undefined;
}
