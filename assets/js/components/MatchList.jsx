import React, { Component } from 'react'
import { graphql, Query } from 'react-apollo'
import gql from 'graphql-tag'


class Match extends Component {
    render() {
        return (
            <div className="match box">
                {`${this.props.match.teamOne.name} vs ${this.props.match.teamTwo.name}`}
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
                                <li key={match.id}>
                                    <Match match={match} />
                                </li>
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
        }
    }
`

export default MatchList;
