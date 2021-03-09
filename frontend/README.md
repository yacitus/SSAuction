# TODO

# urgent

# Known Bugs
- changing Hidden High Bid just makes a new bid?
- Keep Bidding Up To just bids the full amount?
- when you are out of funds and hit +1, it silently fails--preferred UI is to throw up a dialog box saying something like "Not enough cash available to make this bid"
- the past Time Nominations Expire is shown when the next New Nominations Open At is in the future
- $ Bid doesn't update in auction page teams table when players are bid up under a hidden max bid without changing the team with the high bid
- toggle switch (on auction page) to make auction active/inactive doesn't auto-update
- bid buttons have a dark outline (still focused?) after the modal is closed
- have to refresh (more than once) to display buttons in Auction page Bids table if sign out and sign back in on that page

# To Test

# Fixed?

# 2020 Winter League Urgent Features
- mutation to change user data: username, email, slack_display_name, password
- mutation to change auction data, especially bid_timeout_seconds
- allow people to file tickets on GitHub or a Trello project

# MVP Unfinished Features
- rosters sortable by time sold (easy with bid history)
- a $/Player column in the Teams table on the auction page
- paginate auction page Rostered Players table
- when a year_range is displayed (main page, auction page under auction info) where both ends of the range are the same (eg. "2020-2020-BL"), convert it to just one year for display ("2020-BL"——use last 7 characters of range string)
- add a guardrail, like an "Are you sure?" confirmation if a bid is more than some percentage (5%?) higher than the existing bid or some percentage (15%?) higher than the total dollars per team (eg. $1,000)
- add a non-abbreviated position hidden field to player records, so one can search for "catcher" in the nomination list
- teams can be in more than one auction
- team names need only be unique within an auction (checked when added to an auction)
- team page URLs include auction number
- add player to AllPlayer table GraphQL mutation
- create auction GraphQL mutation
- show max bid allowed in team info on team page (if current user in team)
- show max bid allowed in the modal bid forms
- add team name to the top of the "Team Info" table (on the team page)
- show "$ Bid (including hidden max bids)" and "$ Bid publicly" separately on "Team Info" table if logged in user is an owner of the team being displayed
- make pages (especially header when rotated) look better on my iPhone
- tweak whitespace, margins, etc.
- auction invitation system for creating logins and teams
- site admin page (or at least GraphQL mutation) for creating new auctions
- allow change to number of players shown on Rostered Players table on auction page--like how the player selection table works under the nomination queue on the team pages
- download rosters as a CSV
- display team info differently when "authorized" - included hidden bids in "$ Remaining for Bids"

# Pre MVP-Deploy Fixes
- fix `http://localhost:4000/...` in Header.js Image src

# Post MVP Technical Debt Cleanup
- run `npm audit` and `npm audit fix`
- remove duplicated code in BidButton.js and NominateButton.js
- use Dataloader wherever possible
- (re-)enable authentication and authorization checks for nominationQueue field of queries returning team info
- (re-)enable authentication and authorization checks for hidden_high_bid field in all queries and subscriptions
- Supervisor.Spec module used in backend/lib/ssauction/application.ex is deprecated: https://stackoverflow.com/a/61312844/4766

# Post MVP Feature Priority
- "collapse" repeated +1 presses in the bid history into either one database table record or one list element through the GraphQL query
- bids sortable by most recent high bid (easy with bid history)
- ability to re-order (or remove players from) a team nomination queue
- a team setting to enabled/disable auto-nomination from ordered team nomination queue
- user invitations (including to new or existing team)
- create new auction mutation
- database backup
- auction auto-nomination queue
- site admin page (with create new auction, create team, create invites)
- add Team page feature to add invited user to team
- auction admin page (that allows invites, shows nomination status)
- archive auction mutation (and add to site admin page)
- database backup and restore
- sounds when a user is outbid on a player
- emails when a user is outbid on a player
- a Hide checkbox (per user) in the Auction page Bids table, plus an Show All (/Hide) toggle button
- separate pages for Bids and Rostered Players that allow filtering
- (optionally) show only the most recent Bids on the auction page
- show only the most recently rostered players on the auction page
- note icons beside bids that allow owners to make notes

----

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br>
You will also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.<br>
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.<br>
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br>
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `npm run eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Learn More

You can learn more in the [Create React App documentation](https://facebook.github.io/create-react-app/docs/getting-started).

To learn React, check out the [React documentation](https://reactjs.org/).

### Code Splitting

This section has moved here: https://facebook.github.io/create-react-app/docs/code-splitting

### Analyzing the Bundle Size

This section has moved here: https://facebook.github.io/create-react-app/docs/analyzing-the-bundle-size

### Making a Progressive Web App

This section has moved here: https://facebook.github.io/create-react-app/docs/making-a-progressive-web-app

### Advanced Configuration

This section has moved here: https://facebook.github.io/create-react-app/docs/advanced-configuration

### Deployment

This section has moved here: https://facebook.github.io/create-react-app/docs/deployment

### `npm run build` fails to minify

This section has moved here: https://facebook.github.io/create-react-app/docs/troubleshooting#npm-run-build-fails-to-minify
