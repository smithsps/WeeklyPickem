import React, { Component } from 'react'


class LeaderboardTable extends Component {
  
  state = {
    order: {
      field: 0,
      ordering: -1
    }
  }

  render() {
    return (
      <div className="leaderboard-table">
        <table className="table">
          <thead>
            <th>Pos</th>
            <th>Name</th>
            <th>Correct</th>
            <th>Total</th>
            <th>Percentage</th>
          </thead>
          <tbody>
            {this.props.users.map((user, i) => (
                <tr key={user.id}>
                    <th>{i}</th>
                    <td>{user.name}</td>
                    <td>{user.stats[0].correct}</td>
                    <td>{user.stats[0].total}</td>
                    <td>{ratioToPercentage(user.stats[0].correct, user.stats[0].total)}%</td>
                </tr>
            ))}
          </tbody>
        </table>
      </div>
    )
  }
}

function ratioToPercentage(a, b) {
  return Math.floor(a / b * 1000) / 10
}


export default LeaderboardTable