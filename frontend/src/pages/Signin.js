import React from "react";
import Container from "react-bootstrap/Container";
import Header from "../components/Header";
import SigninForm from "../components/SigninForm";

const Signin = () => (
	<Container>
      <Header
        home='signin'
      />
	  <SigninForm />
	</Container>
);

export default Signin;
