import React, { Component } from 'react'
import { graphql, Query } from 'react-apollo'
import gql from 'graphql-tag'

import MatchList from './MatchList'

const GROUP_SIZE = 10

class Series extends Component {

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
                    const threeHours = 1000 * 60 * 60 * 3;
                    var startingTab = 0;
                    for (var tab of matchTabs) {
                        var lastMatch = tab.matches[tab.matches.length - 1]
                        var timeUntil = (Date.parse(lastMatch.time) - Date.now())
                        if (timeUntil > -threeHours) {
                            startingTab = tab.id
                            break
                        }
                    }
                    
                    return (
                        <div>
                            <MatchList matchTabs={matchTabs} startingTab={startingTab} /> 
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

export default Series
