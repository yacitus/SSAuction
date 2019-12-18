import React from 'react';
import { BrowserRouter, Route, Switch } from "react-router-dom";
import Home from "./pages/Home";
import Auction from "./pages/Auction";
import Team from "./pages/Team";
import Signin from "./pages/Signin";
import NotFound from "./pages/NotFound";

const App = () => (
  <BrowserRouter>
    <div id="app">
      <div id="content">
        <Switch>
          <Route path="/" exact component={Home} />
          <Route path="/auction/:auctionId" component={Auction} />
          <Route path="/team/:teamId" component={Team} />
          <Route path="/sign-in" component={Signin} />
          <Route component={NotFound} />
        </Switch>
      </div>
    </div>
  </BrowserRouter>
);

export default App;
