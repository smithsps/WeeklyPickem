import React, { Component } from 'react';
import { graphql, Query } from 'react-apollo'
import gql from 'graphql-tag'

import RedirectUser from '../components/RedirectUser';
import LeaderboardTable from '../components/LeaderboardTable';

class Leaderboard extends Component {
  render() {
    return (
      <div>
        <RedirectUser restrict_to_loggedin="true" />
        
        <div>
          <div className="series-title">
            <p className="heading">Leaderboard for</p>
            <p className="title is-5 is-spaced has-text-white">2018 NA LCS Summer Split</p>
          </div>
        </div>
        <Query query={GET_SERIES_USER_STATS} variables={{ series_tag: "na-lcs-summer-2018"}}>
          {({ loading, error, data }) => {
            if (loading) return <span className="loader"></span>;
            if (error) return `Error! ${error.message}`;

            return (
              <LeaderboardTable users={data.getSeriesUserStats}/>
            )
          }}
        </Query>
      </div>
    )
  }
}

const GET_SERIES_USER_STATS = gql`
    query getSeriesUserStats($series_tag: String!) {
      getSeriesUserStats(series_tag: $series_tag) {
        id
        name
        stats {
          id
          correct
          total
        }
        
      }
    }
`

export default Leaderboard;