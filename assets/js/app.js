// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
//import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative

// import socket from "./socket"


import React from 'react';
import ReactDOM from 'react-dom';
import { BrowserRouter, Route} from 'react-router-dom';
import { createStore, combineReducers, applyMiddleware } from 'redux';
import { Provider } from 'react-redux';
import thunkMiddleware from 'redux-thunk';

import { ApolloProvider } from 'react-apollo';
import { ApolloClient } from 'apollo-client';
import { ApolloLink, from } from 'apollo-link';
import { onError } from "apollo-link-error";
import { HttpLink } from 'apollo-link-http';
import { InMemoryCache } from 'apollo-cache-inmemory';


import css from 'css/app.scss';

import Home from './pages/Home';
import About from './pages/About';
import Login from './pages/Login';

import Navbar from './components/Navbar';


import fetch from 'isomorphic-fetch';
import GraphiQL from 'graphiql';
import graphiql_css from 'css/graphiql.css';
function graphQLFetcher(graphQLParams) {
  return fetch(window.location.origin + '/api', {
    method: 'post',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(graphQLParams),
  }).then(response => response.json());
}


const httpLink = new HttpLink({ uri: "/api" });

const authMiddleware = new ApolloLink((operation, forward) => {
  const token = localStorage.getItem("access-token")
  const authorizationHeader = token ? `Bearer ${token}` : null
  operation.setContext({
    headers: {
      authorization: authorizationHeader
    }
  })
  return forward(operation)
})

const errorMiddleware = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors)
    graphQLErrors.map(({ message, locations, path }) =>
      console.log(
        `[GraphQL error]: Message: ${message}, Location: ${locations}, Path: ${path}`,
      ),
    )

  if (networkError) console.log(`[Network error]: ${networkError}`);
})

const client = new ApolloClient({
  link: from([errorMiddleware, authMiddleware, httpLink]),
  cache: new InMemoryCache()
});

ReactDOM.render((
  <BrowserRouter>
    <ApolloProvider client={client}>
      <div>
        <Navbar />

        <Route exact path="/" component={Home} />
        <Route path="/about" component={About} />
        <Route path="/login" component={Login} />

        <Route path="/graphiql" component={GraphiQL} />
      </div>
    </ApolloProvider>
  </BrowserRouter>
),
  document.getElementById('root')
);
