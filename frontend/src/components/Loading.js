import React from "react";
import Container from "react-bootstrap/Container";
import Jumbotron from "react-bootstrap/Jumbotron";
import Spinner from 'react-bootstrap/Spinner';

const Loading = () => (
	<Container>
		<Jumbotron>
			<Spinner className="align-items-center" animation="border" role="status">
			  <span className="sr-only">Loading...</span>
			</Spinner>
		</Jumbotron>
	</Container>
);

export default Loading;
