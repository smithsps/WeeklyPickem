import React, { Component } from 'react';

class About extends Component {
  render() {
    return(
      <div className="container">
        <div>
          <h1 className="title is-3 is-spaced has-text-white">About this Project</h1>
        </div>
        <br/>
        <div className="content is-medium has-text-white">
          <p>Predict the winner of every game (currently only NA LCS), every week. 
            Challenge your friends and unveil your time machine to your advantage!
            <br/> Or something of that sort.
          </p>
          <p>This project is currently under heavy development and is currently open sourced on  
            <a href="https://github.com/smithsps/WeeklyPickem"> Github!</a>
          </p>
          <p>A running inspiration is the <a href="http://weeklypickem.fantasy.nfl.com/">NFL Weekly Pickem Website</a></p>
          <br/>
          <h1 className="title is-4 is-spaced has-text-white">Contact Information:</h1>
          <p>Feel free to email me for absolutely any reason at: <br/> smithsps -at- gmail.com</p>
        </div>
      </div>
    );
  }
}

export default About;
