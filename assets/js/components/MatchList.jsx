import React, { Component } from 'react'
import { graphql, Mutation, Query } from 'react-apollo'
import gql from 'graphql-tag'


class Match extends Component {


    updatePick(cache, submitUserPick) {
        console.log(submitUserPick)

        const data = cache.readFragment({
            id: `Match:${submitUserPick.matchId}`,
            fragment: MatchList.fragments.match,                                    
            fragmentName: "MatchListMatch",
        })

        cache.writeFragment({ 
            id: `Match:${submitUserPick.matchId}`,
            fragment: MatchList.fragments.match,
            data: {
                ...data,
                teamOne: {
                    ...data.teamOne, 
                    isPick: submitUserPick.teamId == data.teamOne.data.id
                },
                teamTwo: {
                    ...data.teamTwo,
                    isPick: submitUserPick.teamId == data.teamTwo.data.id
                }
            }
        })
    }

    render() {
        return (
            <div className="match columns">
            
                <div className="column has-text-centered">
                    <div className="matchTeamName">
                        {this.props.match.teamOne.data.name}
                    </div>
                    <div className="matchBody">
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

                                if (this.props.match.teamOne.isPick) {
                                    return (
                                        <button type="submit" className="button is-link" disabled>
                                            You have this team picked to win
                                        </button>
                                    )
                                } else {
                                    return (
                                        <button type="submit" className="button is-link"
                                                onClick={e => {
                                                    e.preventDefault();
                                                    submitPick({ variables: { 
                                                        teamId: this.props.match.teamOne.data.id, 
                                                        matchId: this.props.match.id,
                                                        teamName: this.props.match.teamOne.data.name
                                                    }})
                                                }}
                                            >
                                            Pick this Team
                                        </button>
                                    )
                                }
                            }}
                        </Mutation>
                    </div>
                </div>

                <div className="column has-text-centered">
                    <h3 className="is-size-4">vs</h3>
                    <p className="is-size-7">{this.props.match.time}</p>
                </div>

                <div className="column has-text-centered">
                    <div className="matchTeamName">
                        {this.props.match.teamTwo.data.name}
                    </div>
                    <div className="matchBody">
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

                                if (this.props.match.teamTwo.isPick) {
                                    return (
                                        <button type="submit" className="button is-link" disabled>
                                            You have this team picked to win
                                        </button>
                                    )
                                } else {
                                    return (
                                        <button type="submit" className="button is-link"
                                                onClick={e => {
                                                    e.preventDefault();
                                                    submitPick({ variables: { 
                                                        teamId: this.props.match.teamTwo.data.id, 
                                                        matchId: this.props.match.id,
                                                        teamName: this.props.match.teamTwo.data.name
                                                    }})
                                                }}
                                            >
                                            Pick this Team
                                        </button>
                                    )
                                }
                            }}
                        </Mutation>
                    </div>
                </div>
            </div>
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

MatchList.fragments = {
    match: gql`
        fragment MatchListMatch on Match {
            id
            time
            teamOne {
                data {
                    id
                    name
                    acronym
                }
                isPick
                isWinner
            }
            teamTwo {
                data {
                    id
                    name
                    acronym
                }
                isPick
                isWinner
            }
        }
    `
} 

const ALL_MATCHES = gql`
    query allMatches {
        allMatches {
            ...MatchListMatch
        }
    }
    ${MatchList.fragments.match}
`

const GET_MATCH = gql`
    query getMatch {
        getMatch @client {
            ...MatchListMatch
        }
    }
    ${MatchList.fragments.match}
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
        matchId
        teamId
      }
    }
`

export default MatchList;
