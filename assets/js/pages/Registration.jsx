import React, { Component } from 'react'

import RegisterForm from '../components/RegisterForm'
import RedirectUser from '../components/RedirectUser';

const Registration = () => (
  <div>
    <RedirectUser restrict_to_loggedout="true" />
    <RegisterForm />
  </div>
)

export default Registration
