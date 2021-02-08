import React, { Component } from "react";
import { NavLink } from "react-router-dom";
import Breadcrumb from 'react-bootstrap/Breadcrumb'
import CurrentUser from "../components/CurrentUser";
import Signout from "./Signout";
import Image from 'react-bootstrap/Image'

class Header extends Component {
  render() {
    const { home } = this.props;

    let breadcrumbs;
    if (home === 'auctionlist') {
      breadcrumbs = (<Breadcrumb>
                       <Breadcrumb.Item active>Auction List</Breadcrumb.Item>
                     </Breadcrumb>);
    } else if (home === 'auction') {
      breadcrumbs = (<Breadcrumb>
                       <Breadcrumb.Item active>
                         Auction: {this.props.data.name} (#{this.props.data.id})
                       </Breadcrumb.Item>
                     </Breadcrumb>);
    } else if (home === 'team') {
      breadcrumbs = (<Breadcrumb>
                       <Breadcrumb.Item href={"/auction/" + this.props.data.auction.id}>
                         Auction: {this.props.data.auction.name} (#{this.props.data.auction.id})
                       </Breadcrumb.Item>
                       <Breadcrumb.Item active>Team: {this.props.data.name}</Breadcrumb.Item>
                     </Breadcrumb>);
    } else if (home === 'player') {
      breadcrumbs = (<Breadcrumb>
                       <Breadcrumb.Item href={"/auction/" + this.props.data.auction.id}>
                         Auction: {this.props.data.auction.name} (#{this.props.data.auction.id})
                       </Breadcrumb.Item>
                       <Breadcrumb.Item active>Player: {this.props.data.name}</Breadcrumb.Item>
                     </Breadcrumb>);
    } else if (home === 'signin') {
      breadcrumbs = (<Breadcrumb>
                       <Breadcrumb.Item active>Sign In</Breadcrumb.Item>
                     </Breadcrumb>);

    } else {
      breadcrumbs = <Breadcrumb />;
    }

    return (
      <CurrentUser>
        {currentUser => (
          <header>
            <nav>
              <NavLink className="logo" to="/">
                <Image className="icon" src="/ship-steering-wheel-32.png" />
                <span className="head">SS</span>
                <span className="tail">auction</span>
              </NavLink>
              {breadcrumbs}
              <ul>
                {currentUser && (
                  <>
                    <li>
                      <Signout />
                    </li>
                    <li className="user">
                      <i className="far fa-user" />
                      {currentUser.username}
                    </li>
                  </>
                )}
                {!currentUser && (
                  <>
                    <li>
                      <NavLink to="/sign-in">Sign In</NavLink>
                    </li>
                  </>
                )}
              </ul>
            </nav>
          </header>
        )}
      </CurrentUser>
    );
  }
}

export default Header;
