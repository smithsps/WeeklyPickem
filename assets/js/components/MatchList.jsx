import React, { Component } from 'react'
import { graphql, Mutation, Query } from 'react-apollo'
import gql from 'graphql-tag'


class Match extends Component {

    state = {
        userPick: null
    }

    getUserPick() {
        if (this.state.userPick) {
            return this.state.userPick
        } else if (this.props.match.userPick) {
            return this.props.match.userPick.id
        } 

        return null
    }

    render() {
        return (
            <Mutation mutation={SUBMIT_USER_PICK} errorPolicy="all">
                {(submitPick, { loading, data, error }) => {

                    return (
                        <div className="match columns">
                        
                            <div className="column has-text-centered">
                                <div className="matchTeamName">
                                    {this.props.match.teamOne.name}
                                </div>
                                <div className="matchTeamName">
                                    {(this.getUserPick() === this.props.match.teamOne.id ? 
                                        <button type="submit" className="button is-link" disabled>
                                            You have this team picked to win
                                        </button>
                                        : 
                                        <button type="submit" className="button is-link"
                                            onClick={e => {
                                                e.preventDefault();
                                                submitPick({ variables: { 
                                                    teamId: this.props.match.teamOne.id, 
                                                    matchId: this.props.match.id,
                                                    teamName: this.props.match.teamOne.name
                                                }})
                                                this.setState( { userPick: this.props.match.teamOne.id })
                                            }}
                                        >
                                            Pick this Team to Win!
                                        </button>
                                    )}
                                </div>
                            </div>

                            <div className="column has-text-centered">
                                <h3 className="is-size-4">vs</h3>
                                <p className="is-size-7">{this.props.match.time}</p>
                            </div>

                            <div className="column has-text-centered">
                                <div className="matchTeamName">
                                    {this.props.match.teamTwo.name}
                                </div>
                                <div className="matchTeamName">
                                    {(this.getUserPick() === this.props.match.teamTwo.id ? 
                                        <button type="submit" className="button is-link" disabled>
                                            You have this team picked to win
                                        </button>
                                        :
                                        <button type="submit" className="button is-link"
                                            onClick={e => {
                                                e.preventDefault();
                                                submitPick({ variables: { 
                                                    teamId: this.props.match.teamTwo.id, 
                                                    matchId: this.props.match.id,
                                                    teamName: this.props.match.teamTwo.name
                                                }})
                                                this.setState( { userPick: this.props.match.teamTwo.id })
                                            }
                                        }>
                                            Pick this Team to Win!
                                        </button>
                                    )}
                                </div>
                            </div>
                        </div>
                    )
                }}
            </Mutation>
        )
    }
}

class MatchList extends Component {

    state = {
      matches: []
    };

    render() {
        return (
            <Query query={ALL_MATCHES}>
                {({ loading, error, data }) => {
                    if (loading) return "Loading...";
                    if (error) return `Error! ${error.message}`;

                    return (
                        <ul className="matchList">
                            {data.allMatches.map(match => (
                                <div key={match.id}>
                                    <li >
                                        <Match match={match} />
                                    </li>
                                    <hr/>
                                </div>
                            ))}
                        </ul>
                    );
                }}
            </Query>
        )
    }
};

const ALL_MATCHES = gql`
    query allMatches {
        allMatches {
            id
            time
            teamOne {
                id
                acronym
                name
            }
            teamTwo {
                id
                acronym
                name
            }
            winner {
                id
            }
            userPick {
                id
                name
            }
        }
    }
`

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
        message
      }
    }
`

export default MatchList;
