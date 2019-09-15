import React from 'react';
import { BrowserRouter, Route, Switch } from "react-router-dom";
import './App.css';
import Home from "./pages/Home";
import Auction from "./pages/Auction";
import NotFound from "./pages/NotFound";

const App = () => (
  <BrowserRouter>
    <div id="app">
      <div id="content">
        <Switch>
          <Route path="/" exact component={Home} />
          <Route path="/auction/:auctionId" component={Auction} />
          <Route component={NotFound} />
        </Switch>
      </div>
    </div>
  </BrowserRouter>
);

export default App;
