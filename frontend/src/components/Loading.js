import React from "react";
import Jumbotron from "react-bootstrap/Jumbotron";
import Spinner from 'react-bootstrap/Spinner';

const Loading = () => (
	<div>
		<Jumbotron>
			<Spinner className="align-items-center" animation="border" role="status">
			  <span className="sr-only">Loading...</span>
			</Spinner>
		</Jumbotron>
	</div>
);

export default Loading;
