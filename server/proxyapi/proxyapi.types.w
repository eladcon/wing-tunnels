struct ProxyApiProps {
  zoneName: str;
  subDomain: str;
}

interface IProxyApi {
  inflight url(): str;
}

struct IProxyApiEvent {
  subdomain: str;
  body: str?;
  headers: Map<str>?;
  httpMethod: str;
  isBase64Encoded: bool;
  path: str;
  queryStringParameters: Map<str>?;
}

struct IProxyApiResponse {
  statusCode: num;
  body: str?;
  headers: Map<str>?;
}

struct IProxyApiAwsRequestContext {
  domainName: str;
}

struct IProxyApiAwsRequest {
  requestContext: IProxyApiAwsRequestContext;
  path: str;
  httpMethod: str;
  body: str?;
  headers: Map<str>?;
  isBase64Encoded: bool;
  queryStringParameters: Map<str>?;
}
