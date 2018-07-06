import React, { Component } from 'react'
import { Link } from 'react-router-dom'
import { graphql, Query } from 'react-apollo'
import gql from 'graphql-tag'

import logo from 'static/images/logo.png';

class Navbar extends Component {
  render() {
    return (
      <nav className="navbar" role="navigation" aria-label="main navigation">
        <div className="navbar-brand">
          <Link className="navbar-item" to="/">
            <img src={logo} alt="Weekly League Pick'em" height="28"/>
          </Link>

          <button className="button navbar-burger">
            <span></span>
            <span></span>
            <span></span>
          </button>
        </div>
        <div className="navbar-menu">
          <div className="navbar-start">
            <Link className="navbar-item" to="/about">About</Link>
          </div>

          <div className="navbar-end">
            <Query query={CURRENT_USER_QUERY} fetchPolicy="network-only">
              {({ client, loading, data }) => {
                if (loading) {
                  return (
                    <div className="navbar-end">
                      <div className="navbar-item">Loading..</div>
                    </div>
                  );
                }
                
                if (data && data.currentUser.id) {
                  return (
                    <div className="navbar-end">
                      <Link className="navbar-item" to="/leaderboard">Leaderboard</Link>
                      <Link className="navbar-item" to="/pickem">Your Pick'em</Link>
                      <a 
                        className="navbar-item"
                        onClick={() => {
                          localStorage.clear()
                          client.resetStore()
                          window.location.reload()
                        }}
                      >
                        Log out
                      </a>
                    </div>
                  );
                }

                return (
                  <div className="navbar-end">
                    <Link className="navbar-item" to="/signup">Register</Link>
                    <Link className="navbar-item" to="/login">Login</Link>
                  </div>
                );
              }}
            </Query>
          </div>
        </div>
      </nav>
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

export default Navbar;
