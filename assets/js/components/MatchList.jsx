import React, { Component } from 'react'
import { graphql, Mutation } from 'react-apollo'
import gql from 'graphql-tag'

class MatchList extends Component {

    state = {
      name: "",
      email: "",
      emailConfirmation: "",
      password: "",
      passwordConfirmation: ""
    };

    render() {
        return (
            <p>Test</p>
        )
    }
};

const CREATE_USER = gql`
    {
        matches {
            id
        }
    }
`

export default MatchList;
