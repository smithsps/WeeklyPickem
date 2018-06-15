import React, { Component } from 'react';

import MatchList from '../components/MatchList';
import RedirectUser from '../components/RedirectUser';

class Pickem extends Component {
  render() {
    return(
      <div>
        <RedirectUser restrict_to_loggedin="true" />
        <MatchList />
      </div>
    );
  }
}

export default Pickem;