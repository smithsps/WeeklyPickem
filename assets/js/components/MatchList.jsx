import React, { Component } from 'react'
import { graphql, Mutation, Query } from 'react-apollo'
import Moment from 'react-moment'
import gql from 'graphql-tag'

import Match from './Match'


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
        currentTab: this.props.startingTab
    }

    render() {
        return (
            <div>
                <div className="matchList tabs is-boxed">
                    <ul>
                        {this.props.matchTabs.map(tab => (
                            <li key={tab.id} 
                                className={this.state.currentTab === tab.id ? "is-active" : ""}
                            >
                                <a onClick={e => this.setState({currentTab: tab.id})}>{tab.tabName}</a>
                            </li>
                        ))}
                    </ul>
                </div>
                <MatchTab matches={this.props.matchTabs[this.state.currentTab].matches}/>
            </div>
        );
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

export default MatchList
