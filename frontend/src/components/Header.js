import React from "react";
import { NavLink } from "react-router-dom";
import CurrentUser from "../components/CurrentUser";
import Signout from "./Signout";

const Header = () => (
  <CurrentUser>
    {currentUser => (
      <header>
        <nav>
          <NavLink className="logo" to="/">
            <span className="head">SS</span>
            <span className="tail">auction</span>
          </NavLink>
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

export default Header;
