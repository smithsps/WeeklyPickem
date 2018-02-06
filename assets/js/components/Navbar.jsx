import React, { Component } from 'react';

import logo from 'static/logo.png';

class Navbar extends Component {
  render() {
    return(
      <nav className="navbar is-dark" role="navigation" aria-label="main navigation">
        <div className="navbar-brand">
          <a className="navbar-item" href="#">
            <img src={logo} alt="Weekly League Pick'em" height="28"/>
          </a>

          <button className="button navbar-burger">
            <span></span>
            <span></span>
            <span></span>
          </button>
        </div>
        <div className="navbar-menu">
          <div className="navbar-start">
            <a className="navbar-item">About</a>
          </div>

          <div className="navbar-end">
            <a className="navbar-item">Register</a>
            <a className="navbar-item">Login</a>
          </div>
        </div>
      </nav>
    );
  }
}

export default Navbar;
