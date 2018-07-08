import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { ApolloConsumer } from 'react-apollo';


class Logout extends Component {
  render() {
    return (
      <ApolloConsumer>
        {client => {
          localStorage.clear()
          client.resetStore()

          return <Redirect push to="/" />
        }}
      </ApolloConsumer>
    );
  }
}

export default Logout;
