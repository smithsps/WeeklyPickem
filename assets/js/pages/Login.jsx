import React, { Component } from 'react';

import Navbar from '../components/Navbar'
import LoginForm from '../components/LoginForm';

class Login extends Component {
  render() {
    return(
      <div className="container">
        <Navbar publicOnly={true} />
        <LoginForm />
      </div>
    );
  }
}

export default Login;
