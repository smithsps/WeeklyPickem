import React, { Component } from 'react'
import { Redirect } from 'react-router'
import { Link } from 'react-router-dom'
import { graphql, Query } from 'react-apollo'
import gql from 'graphql-tag'

import logo from 'static/images/logo.png';


const inclusive_pages = [
  {name: "About", url: "/about"}
]

const public_pages = [
  {name: "Register", url: "/signup"},
  {name: "Login", url: "/login"}
]

const private_pages = [
  {name: "Leaderboard", url: "/leaderboard"},
  {name: "Your Pick'em", url: "/pickem"},
  {name: "Logout", url: "/logout"}
]

class Navbar extends Component {

  state = {
    burgerVisible: false
  }

  renderNavLinks(loggedIn) {
    if (loggedIn) {
      return private_pages.map((page, i) => (
        <Link className="navbar-item" key={i} to={page.url}>{page.name}</Link>
      ))
    } 

    return public_pages.map((page, i) => (
      <Link className="navbar-item" key={i} to={page.url}>{page.name}</Link>
    ))
  }

  render() {
    return (
      <Query query={CURRENT_USER_QUERY} errorPolicy="ignore">
        {({ client, loading, data }) => {
          const loggedIn = data && data.currentUser;

          // Redirect not logged-in users to main page
          if (this.props.privateOnly && !loggedIn) {
              return <Redirect push to="/" />;
          } 

          // Redirect logged-in users to pickem main page
          // Like from the Login and Registration page
          if (this.props.publicOnly && loggedIn) {
              return <Redirect push to="/pickem" />;
          }

          return (
            <nav className="navbar" role="navigation" aria-label="main navigation">
              <div className="navbar-brand">
                <Link className="navbar-item" to="/">
                  <img src={logo} alt="Weekly League Pick'em" height="28"/>
                </Link>
                
                <button 
                  className={`button navbar-burger ${this.state.burgerVisible ? "is-active" : ""}`} 
                  aria-label="menu" 
                  aria-expanded="false"
                  onClick={() => this.setState({burgerVisible: !this.state.burgerVisible})}
                >
                  <span></span>
                  <span></span>
                  <span></span>
                </button>
              </div>
              <div className={`navbar-menu ${this.state.burgerVisible ? "is-active" : ""}`}>
                <div className="navbar-start">
                  {inclusive_pages.map((page, i) => (
                      <Link className="navbar-item" key={i} to={page.url}>{page.name}</Link>
                  ))}
                </div>

                <div className="navbar-end">
                  {this.renderNavLinks(loggedIn)}
                </div>
              </div>
            </nav>
          )
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

export default Navbar;
