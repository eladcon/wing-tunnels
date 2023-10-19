import {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand,
} from "@aws-sdk/client-apigatewaymanagementapi";

export const postToConnection = async (endpoint: string, connectionId: string, data: string) => {
  const apiGatewayManagementApi = new ApiGatewayManagementApiClient({
    apiVersion: "2018-11-29",
    endpoint
  });
  
  await apiGatewayManagementApi.send(
    new PostToConnectionCommand({
      Data: data,
      ConnectionId: connectionId,
    })
  );
};
