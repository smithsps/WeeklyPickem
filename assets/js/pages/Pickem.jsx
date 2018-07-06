import React, { Component } from 'react';

import Series from '../components/Series';
import RedirectUser from '../components/RedirectUser';

class Pickem extends Component {
  render() {
    return(
      <div>
        <RedirectUser restrict_to_loggedin="true" />
        
        <Series />
      </div>
    );
  }
}

export default Pickem;