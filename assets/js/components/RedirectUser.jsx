import React, { Component } from 'react'
import { Redirect } from 'react-router'
import { graphql, Query } from 'react-apollo'
import gql from 'graphql-tag'

class RedirectUser extends Component {
  render() {
    return (
        <Query query={CURRENT_USER_QUERY}>
            {({ client, data }) => {
                var loggedIn = data && data.currentUser;

                // Redirect not logged-in users to main page
                if (this.props.restrict_to_loggedin && !loggedIn) {
                    return <Redirect push to="/" />;
                } 

                // Redirect logged-in users to pickem main page
                // Like from the Login and Registration page
                if (this.props.restrict_to_loggedout && loggedIn) {
                    return <Redirect push to="/pickem" />;
                }

                // User is ok to be in this area
                return null;
            }}
        </Query>
    );
  }
}

const CURRENT_USER_QUERY = gql`
  query CurrentUser {
    currentUser {
      id
    }
  }
`;

export default RedirectUser;
