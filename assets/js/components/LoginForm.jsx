import React, { Component } from 'react';
import { graphql } from 'react-apollo'
import gql from 'graphql-tag'

import EmailIcon from 'mdi-react/EmailOutlineIcon';
import PasswordIcon from 'mdi-react/LockIcon';

class LoginForm extends Component {

  state = {
    email: "",
    password: ""
  };

  handleSubmit(event) {
    event.preventDefault();
  }

  render() {
    return(
      <div className="container is-fluid login-form">
        <span className="title is-4 has-text-white"> Login </span>

        <div className="field">
          <p className="control has-icons-left has-icons-right">
            <input
              className="input"
              type="email"
              placeholder="Email"
              value={this.state.email}
              onChange={e => this.setState({ email: e.target.value })}
            />
            <span className="icon is-small is-left">
              <i className="fas fa-envelope"></i>
            </span>
            <span className="icon is-small is-left">
              <EmailIcon />
            </span>
          </p>
        </div>
        <div className="field">
          <p className="control has-icons-left">
            <input
              className="input"
              type="password"
              placeholder="Password"
              value={this.state.email}
              onChange={e => this.setState({ email: e.target.value })}
            />
            <span className="icon is-small is-left">
              <PasswordIcon />
            </span>
          </p>
        </div>


        <span> GraphQL Status: {this.props.feedQuery && this.props.feedQuery.error} </span>

        <div className="field">
          <p className="control">
            <button className="button is-link">
              Login
            </button>
          </p>
        </div>
      </div>
    );
  }

  _loginUser = async () => {
    console.log("test");

  }


  _saveUserData = accessToken => {
    localStorage.setItem(REFRESH_TOKEN, accessToken)
    localStorage.setItem(ACCESS_TOKEN, accessToken)
  }
}

const LOGIN_QUERY = gql`
  query loginUser (
      $email: String!,
      $password: String!
    ) {
    refreshToken {
      token
      expiration
    }
    accessToken {
      token
    }
    user {
      id
      name
      email
    }
  }
`

export default LoginForm;
