import { ApolloClient } from "apollo-client";
import { ApolloLink } from "apollo-link";
import { InMemoryCache } from "apollo-cache-inmemory";
import { createHttpLink } from "apollo-link-http";
import { setContext } from "apollo-link-context";
import { hasSubscription } from "@jumpn/utils-graphql";
import * as AbsintheSocket from "@absinthe/socket";
import { createAbsintheSocketLink } from "@absinthe/socket-apollo-link";
import { Socket as PhoenixSocket } from "phoenix";

console.log('process.env.NODE_ENV: ' + process.env.NODE_ENV);

// const HTTP_ENDPOINT = "https://compassionate-live-arrowworm.gigalixirapp.com/api";
const HTTP_ENDPOINT =
  process.env.NODE_ENV === "production"
    ? "https://compassionate-live-arrowworm.gigalixirapp.com/api"
    : "http://localhost:4000/api";

console.log('HTTP_ENDPOINT: ' + HTTP_ENDPOINT);

// const WS_ENDPOINT = "wss://compassionate-live-arrowworm.gigalixirapp.com/socket";
const WS_ENDPOINT =
  process.env.NODE_ENV === "production"
    ? "wss://compassionate-live-arrowworm.gigalixirapp.com/socket"
    : "ws://localhost:4000/socket";

console.log('WS_ENDPOINT: ' + WS_ENDPOINT);

// Create an HTTP link to the Phoenix app's HTTP endpoint URL.
const httpLink = createHttpLink({
  uri: HTTP_ENDPOINT
});

// Create a WebSocket link to the Phoenix app's socket URL.
const socketLink = createAbsintheSocketLink(
  AbsintheSocket.create(new PhoenixSocket(WS_ENDPOINT))
);

// If an authentication token exists in local storage, put
// the token in the "Authorization" request header.
// Returns an object to set the context of the GraphQL request.
const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem("auth-token");
  return {
    headers: {
      ...headers,
      authorization: token ? `Bearer ${token}` : ""
    }
  };
});

// Create a link that "splits" requests based on GraphQL operation type.
// Queries and mutations go through the HTTP link.
// Subscriptions go through the WebSocket link.
const link = new ApolloLink.split(
  operation => hasSubscription(operation.query),
  socketLink,
  authLink.concat(httpLink)
);

// Create the Apollo Client instance.
const client = new ApolloClient({
  link: link,
  cache: new InMemoryCache()
});

export default client;
