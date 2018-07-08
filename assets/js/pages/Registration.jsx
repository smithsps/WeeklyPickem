import React, { Component } from 'react'

import Navbar from '../components/Navbar'
import RegisterForm from '../components/RegisterForm'

const Registration = () => (
  <div className="container">
    <Navbar publicOnly={true} />
    <RegisterForm />
  </div>
)

export default Registration
