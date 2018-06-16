import React, { Component } from 'react';

import MatchList from '../components/MatchList';
import RedirectUser from '../components/RedirectUser';

class Pickem extends Component {
  render() {
    return(
      <div>
        <RedirectUser restrict_to_loggedin="true" />
        
        <p className="title is-3 is-spaced has-text-white">Your Pick'em</p>
        <MatchList />
      </div>
    );
  }
}

export default Pickem;