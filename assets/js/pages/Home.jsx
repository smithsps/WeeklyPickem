import React, { Component } from 'react';

import LoginForm from '../components/LoginForm';

import lcs_image from 'static/home_image1.jpg';

class Home extends Component {
  render() {
    return(
      <div className="columns">
        <div className="column">
          <figure className="image is-16by9">
            <img src={lcs_image} />
          </figure>
          <p className="subtitle is-3 has-text-white">Welcome to the</p>
          <p className="title is-1 is-spaced has-text-white">Weekly League Pick'em</p>
        </div>
        <div className="column is-one-third home-login-signup">
          <LoginForm />
          <div className="home-signup">
            <p id="please" className="title is-4 has-text-white">Don't have an account?</p>
            <button className="button is-link is-medium">
              Signup Here
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default Home;