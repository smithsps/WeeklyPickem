import React, { Component } from 'react'


class LeaderboardTable extends Component {
  
  state = {
    order: {
      field: "correct",
      ordering: -1
    }
  }

  render() {
    var users = this.props.users.slice()
    users = users.sort(ordering_sort(this.state.order.field, this.state.order.ordering))

    return (
      <div className="leaderboard-table">
        <table className="table is-fullwidth">
          <thead>
            <tr>
              <th>Pos</th>
              <th>Name</th>
              <th>Correct</th>
              <th>Total</th>
              <th>Percentage</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user, i) => (
                <tr key={user.id}>
                    <th>{i + 1}</th>
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

function ordering_sort(field, ordering) {
  if (field === "percentage") {
    return (a, b) => {
      const a_percentage = ratioToPercentage(a.stats.correct, a.stats.total);
      const b_percentage = ratioToPercentage(b.stats.correct, b.stats.total);
      if (a_percentage > b_percentage) {
        return ordering;
      }
      if (a_percentage < b_percentage) {
        return -1 * ordering;
      }
      return 0
    }
  } else {
    return (a, b) => {
      if (a.stats[0][field] > b.stats[0][field]) {
        return ordering;
      }
      if (a.stats[0][field] < b.stats[0][field]) {
        return -1 * ordering;
      }
      return 0
    }
  }
}


export default LeaderboardTable