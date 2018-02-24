import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import logo from 'static/logo.png';

class Navbar extends Component {
  render() {
    return(
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
            <Link className="navbar-item" to="/signup">Register</Link>
            <Link className="navbar-item" to="/login">Login</Link>
          </div>
        </div>
      </nav>
    );
  }
}

export default Navbar;
