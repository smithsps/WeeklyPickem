import React, { Component } from 'react'
import { graphql, Mutation, Query } from 'react-apollo'
import Moment from 'react-moment'
import gql from 'graphql-tag'

import TeamImage from "./TeamImage"

import CheckIcon from 'mdi-react/CheckIcon';

class PickButton extends Component {

  updatePick(cache, submitUserPick) {
    const data = cache.readFragment({
        id: `Match:${submitUserPick.matchId}`,
        fragment: Match.fragments.match,                                    
        fragmentName: "MatchListMatch",
    })

    cache.writeFragment({ 
        id: `Match:${submitUserPick.matchId}`,
        fragment: Match.fragments.match,
        data: {
            ...data,
            teamOne: {
                ...data.teamOne, 
                isPick: submitUserPick.teamId === data.teamOne.data.id
            },
            teamTwo: {
                ...data.teamTwo,
                isPick: submitUserPick.teamId === data.teamTwo.data.id
            }
        }
    })
  }

  render() {
    return (
      <Mutation mutation={SUBMIT_USER_PICK} 
        errorPolicy="all"
        update={ (cache, { data: { submitUserPick } }) => {
            this.updatePick(cache, submitUserPick)
        }}
      >
        {(submitPick, { loading, data, error }) => {
          if (loading) {
            return (
              <button type="submit" className="button is-link">
                  <span className="loader"></span>
              </button>
            )
          }

          if (this.props.team.isPick) {
            return (
              <button type="submit" className="button is-picked">
                <span className="icon is-small is-left has-text-white">
                  <CheckIcon color="#fff"/>
                </span>
                <span>Picked</span>
              </button>
            )
          }

          return (
            <button type="submit" className="button is-link"
                onClick={e => {
                    e.preventDefault();
                    submitPick({ variables: { 
                        teamId: this.props.team.data.id, 
                        matchId: this.props.match,
                        teamName: this.props.team.data.name
                    }})
                }}
            >
              <span className="is-hidden-mobile">Pick this Team</span>
              <span className="is-hidden-tablet">Pick</span>
            </button>
          )
        }}
      </Mutation>
    )
  }
}

class Match extends Component {
    render() {
        const isPickingAllowed = (Date.parse(this.props.match.time) - Date.now()) > 0

        const teamOne = this.props.match.teamOne
        const teamTwo = this.props.match.teamTwo


        return (
            <div className="match level is-mobile">
              <div className="level-left match-team">
                <TeamImage className="match-team-logo" team={teamOne.data} />
                <div>
                  <div className="match-team-name">
                    <h3 className="acronym">{teamOne.data.acronym}&nbsp;
                      <span className="has-text-grey">({teamOne.data.stats.wins}-{teamOne.data.stats.total - teamOne.data.stats.wins})</span>
                    </h3>
                    <h3 className="name">{teamOne.data.name}&nbsp;
                      <span className="has-text-grey">({teamOne.data.stats.wins}-{teamOne.data.stats.total - teamOne.data.stats.wins})</span>
                    </h3>
                    
                  </div>
                  <div className="match-body">
                    <div>
                      { isPickingAllowed ?
                        <PickButton match={this.props.match.id} team={teamOne} />
                        :
                        teamOne.isPick ? <span className="tag is-success">Picked</span> : ""
                      }
                      {teamOne.isWinner ? <span className="tag is-link">Winner</span> : ""}
                    </div>
                  </div>
                </div>
              </div>

              <div className="level">
                <div className="has-text-centered">
                  <h3 className="is-size-4">vs</h3>
                  <p className="match-time-long is-size-7">{<Moment format="dddd, MMMM Do, h A">{this.props.match.time}</Moment>}</p>
                  <p className="match-time-short is-size-7">{<Moment format="M/D, h A">{this.props.match.time}</Moment>}</p>
                  <p className="is-size-7">{<Moment fromNow>{this.props.match.time}</Moment>}</p>
                </div>
              </div>

              <div className="level-right match-team">
                <div>
                  <div className="match-team-name has-text-right">
                  <h3 className="acronym">
                    <span className="has-text-grey">({teamTwo.data.stats.wins}-{teamTwo.data.stats.total - teamTwo.data.stats.wins})</span>&nbsp;  
                    {teamTwo.data.acronym}
                  </h3>
                    <h3 className="name">
                      <span className="has-text-grey">({teamTwo.data.stats.wins}-{teamTwo.data.stats.total - teamTwo.data.stats.wins})</span>&nbsp;    
                      {teamTwo.data.name}
                    </h3>
                  </div>
                  <div className="match-body is-pulled-right">
                    <div>
                      { isPickingAllowed ?
                        <PickButton match={this.props.match.id} team={teamTwo} />
                        :
                        teamTwo.isPick ? <span className="tag is-success">Picked</span> : ""
                      }
                      {teamTwo.isWinner ? <span className="tag is-link">Winner</span> : ""}
                    </div>
                  </div>
                </div>
                <TeamImage className="match-team-logo" team={teamTwo.data} />
              </div>
          </div>
        )
    }
}

Match.fragments = {
  match: gql`
      fragment MatchListMatch on Match {
          id
          time
          teamOne {
              data {
                  id
                  name
                  acronym
                  stats {
                      id
                      wins
                      total
                  }
              }
              isPick
              isWinner
          }
          teamTwo {
              data {
                  id
                  name
                  acronym
                  stats {
                      id
                      wins
                      total
                  }
              }
              isPick
              isWinner
          }
      }
  `
} 

const SUBMIT_USER_PICK = gql`
    mutation submitUserPick (
      $teamName: String!,
      $teamId: String!,
      $matchId: String!
    ) {
      submitUserPick (
        teamName: $teamName, 
        teamId: $teamId, 
        matchId: $matchId
      ) {
        matchId
        teamId
      }
    }
`

export default Match