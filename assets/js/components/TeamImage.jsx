import React, { Component } from 'react'

import team88 from 'static/images/team88.png';
import team149 from 'static/images/team149.png';
import team289 from 'static/images/team289.png';
import team290 from 'static/images/team290.png';
import team291 from 'static/images/team291.png';
import team340 from 'static/images/team340.png';
import team476 from 'static/images/team476.png';
import team477 from 'static/images/team477.png';
import team478 from 'static/images/team478.png';
import team512 from 'static/images/team512.png';

const team_image = {
  88: team88,
  149: team149,
  289: team289,
  290: team290,
  291: team291,
  340: team340,
  476: team476,
  477: team477,
  478: team478,
  512: team512
}

class TeamImage extends Component {
  render() {
    if (team_image[this.props.team.id]) {
      return (
        <figure class="match-team-logo image is-1by1">
          <img
            src={team_image[this.props.team.id]}
            alt=""
          />
        </figure>
      )
    }

    return null
  }
}

export default TeamImage