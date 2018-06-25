import React, { Component } from 'react'
import { Redirect } from 'react-router'
import { graphql, Mutation } from 'react-apollo'
import gql from 'graphql-tag'

import EmailIcon from 'mdi-react/EmailOutlineIcon';
import PasswordIcon from 'mdi-react/LockIcon';

class LoginForm extends Component {

  state = {
    email: "",
    password: ""
  };

  render() {
    return (
      <Mutation mutation={LOGIN_MUTATION} errorPolicy="all">
        {(loginUser, { error, data, loading }) => {

          if (data && data.loginUser) {
            const refreshToken = data.loginUser.refreshToken.token
            const accessToken = data.loginUser.accessToken.token

            this._saveUserData(refreshToken, accessToken)

            //Hack because the NavBar doesn't update its state naturally
            //TODO: combine RedirectUser and NavBar
            window.location.reload()

            return (<Redirect push to="/pickem" />)
          }

          return (
            <div className="container is-fluid login-form">
              <form>
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
                      value={this.state.password}
                      onChange={e => this.setState({ password: e.target.value })}
                    />
                    <span className="icon is-small is-left">
                      <PasswordIcon />
                    </span>
                  </p>
                </div>
                { error &&
                    error.graphQLErrors.map(({ message }, i) => (
                      <div key={i} className="notification is-danger">{message}</div>
                    ))
                }

                <div className="field">
                  <p className="control">
                    <button type="submit" className="button is-link"
                      onClick={e => {
                        e.preventDefault();
                        const { email, password } = this.state
                        loginUser({ variables: { email: email, password: password }})
                        this.setState({ password: "" })
                      }
                    }>
                      {loading ? <span className="loader"></span> : 'Login'}
                    </button>
                  </p>
                </div>
              </form>
            </div>
          )}
        }
      </Mutation>
    );
  }

  _saveUserData = (refreshToken, accessToken) => {
    console.log(refreshToken)

    localStorage.setItem("refresh-token", refreshToken)
    localStorage.setItem("access-token", accessToken)
  }
}


const LOGIN_MUTATION = gql`
    mutation loginMutation($email: String!, $password: String!) {
      loginUser(email: $email, password: $password) {
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
  }
`

export default LoginForm;