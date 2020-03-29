import React, { Component } from "react";
import PropTypes from "prop-types";
import Modal from "react-bootstrap/Modal";
import Button from "react-bootstrap/Button";

class VerticallyCenteredModal extends Component {
  state = {
    show:  true
  }

  handleClose = () => {
    this.setState({show: false});
  }

  render() {
     return (
      <Modal
        show={ this.state.show }
        onHide={ this.handleClose }
        size="lg"
        aria-labelledby="contained-modal-title-vcenter"
        centered
      >
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            Error
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>
            { this.props.message }
          </p>
        </Modal.Body>
        <Modal.Footer>
          <Button onClick={ this.handleClose }>Close</Button>
        </Modal.Footer>
      </Modal>
    );
  }
}

// Render runtime errors, including GraphQL errors and network errors.
//
// The error passed as a prop to this component is an Apollo Client
// 'QueryResult' object that has 'graphQLErrors' and 'networkError' properties.

class Error extends Component {
  render() {
    const { error } = this.props;
    // const [modalShow, setModalShow] = React.useState(false);

    if (!error || !error.message) return null;

    const isNetworkError =
      error.networkError &&
      error.networkError.message &&
      error.networkError.statusCode;

    const hasGraphQLErrors = error.graphQLErrors && error.graphQLErrors.length;

    let errorMessage;

    if (isNetworkError) {
      if (error.networkError.statusCode === 404) {
        errorMessage = (
          <h3>
            <code>404: Not Found</code>
          </h3>
        );
      } else {
        errorMessage = (
          <>
            <h3>Network Error!</h3>
            <code>
              {error.networkError.statusCode}: {error.networkError.message}
            </code>
          </>
        );
      }
    } else if (hasGraphQLErrors) {
      errorMessage = (
        <>
          <ul>
            {error.graphQLErrors.map(({ message, details }, i) => (
              <li key={i}>
                <span className="message">{message}</span>
                {details && (
                  <ul>
                    {Object.keys(details).map(key => (
                      <li key={key}>
                        {key} {details[key]}
                      </li>
                    ))}
                  </ul>
                )}
              </li>
            ))}
          </ul>
        </>
      );
    } else {
      console.log('ERROR (misc): ' + error.message);
      errorMessage = (
        <>
          <h3>Whoops!</h3>
          <p>{error.message}</p>
        </>
      );
    }

    return (
      <VerticallyCenteredModal
        message={errorMessage}
      />
    );
  }
};

Error.propTypes = {
  error: PropTypes.object
};

Error.defaultProps = {
  error: {}
};

export default Error;
