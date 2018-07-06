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
            <Query query={GET_SERIES} variables={{ series_tag: "na-lcs-summer-2018"}}>
                {({ loading, error, data }) => {
                    if (loading) return <span className="loader"></span>;
                    if (error) return `Error! ${error.message}`;

                    const matches = data.getSeries.matches

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

                    // Find currentTab by taking last match in tab and seeing if it is 3 hours old
                    // const threeHours = 1000 * 60 * 60 * 3;
                    // for (var tab of MatchTabs) {
                    //     var lastMatch = tab.matches[tab.matches.length - 1]
                    //     var timeUntil = (Date.parse(this.props.match.time) - Date.now())
                    //     if (timeUntil > -threeHours) {
                    //         currentTab = tab.id
                    //         break
                    //     }
                    // }
                    
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

const GET_SERIES = gql`
    query getSeries($series_tag: String!) {
        getSeries(series_tag: $series_tag) {
            id
            name
            startAt
            matches {
                ...MatchListMatch
            }
            pickStats {
                id
                correct
                total
            }
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
