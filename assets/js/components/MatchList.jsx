import React, { Component } from 'react'
import { graphql, Mutation, Query } from 'react-apollo'
import Moment from 'react-moment'
import gql from 'graphql-tag'

import Match from './Match'

const GROUP_SIZE = 10

class MatchTab extends Component {
    render() {
        return (
            <ul className="matchTab">
                {this.props.matches.map(match => (
                    <div key={match.id}>
                        <li >
                            <Match match={match} />
                        </li>
                        <hr/>
                    </div>
                ))}
            </ul>
        )
    }
}

class MatchList extends Component {

    state = {
        currentTab: 0
    }

    render() {
        return (
            <Query query={ALL_MATCHES}>
                {({ loading, error, data }) => {
                    if (loading) return <span className="loader"></span>;
                    if (error) return `Error! ${error.message}`;

                    const matches = data.allMatches

                    // Build match groups of group size
                    const matchTabs = matches
                        .map( (e, i) => {
                            if (i % GROUP_SIZE === 0) {
                                return {
                                    id: i / GROUP_SIZE,
                                    tabName: `Week ${i / GROUP_SIZE + 1}`,
                                    matches: matches.slice(i, i + GROUP_SIZE)
                                }
                            }
                            return null
                        })
                        .filter((item) => {return item})

                    return (
                        <div>
                            <div className="matchList tabs is-boxed">
                                <ul>
                                    {matchTabs.map(tab => (
                                        <li key={tab.id} 
                                            className={this.state.currentTab === tab.id ? "is-active" : ""}
                                        >
                                            <a onClick={e => this.setState({currentTab: tab.id})}>{tab.tabName}</a>
                                        </li>
                                    ))}
                                </ul>
                            </div>
                            <MatchTab matches={matchTabs[this.state.currentTab].matches}/>
                        </div>
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

export default MatchList
