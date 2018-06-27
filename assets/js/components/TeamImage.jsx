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
  "FOX": team88,
  "FLY": team149,
  "TL": team289,
  "CLG": team290,
  "TSM": team291,
  "C9": team340,
  "100": team476,
  "CG": team477,
  "GGS": team478,
  "OPT": team512
}

class TeamImage extends Component {
  render() {
    if (team_image[this.props.team.acronym]) {
      return (
        <figure class="match-team-logo image">
          <img
            src={team_image[this.props.team.acronym]}
            alt=""
          />
        </figure>
      )
    }

    return null
  }
}

export default TeamImage