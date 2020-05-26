import React from "react";
import Header from "../components/Header";
import SigninForm from "../components/SigninForm";

const Signin = () => (
	<div>
      <Header
        home='signin'
      />
	  <SigninForm />
	</div>
);

export default Signin;
