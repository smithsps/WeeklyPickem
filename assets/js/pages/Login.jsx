import React, { Component } from 'react';

import LoginForm from '../components/LoginForm';
import RedirectUser from '../components/RedirectUser';

class About extends Component {
  render() {
    return(
      <div>
        <RedirectUser restrict_to_loggedout="true" />
        <LoginForm />
      </div>
    );
  }
}

export default About;
