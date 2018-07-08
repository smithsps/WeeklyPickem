import React, { Component } from 'react';

import Navbar from '../components/Navbar'
import Series from '../components/Series';

class Pickem extends Component {
  render() {
    return(
      <div className="container">
        <Navbar privateOnly={true} />
        <Series />
      </div>
    );
  }
}

export default Pickem;