export const fromBase64 = (data: string) => {
  let buff = Buffer.from(data, "base64");
  return buff.toString("utf8");
}

export const toBase64 = (data: string) => {
  let buff = Buffer.from(data, "utf8");
  return buff.toString("base64");
}
