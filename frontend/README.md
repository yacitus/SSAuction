## Known Bugs
- bid buttons have a dark outline (still focused?) after the modal is closed
- have to refresh (more than once) to display buttons in Auction page Bids table if sign out and sign back in on that page

# To Test

# MVP Unfinished Features
- put breadcrumbs in the header
- put a ships wheel icon in the header
- make table background white
- change auction info and team info cards to tables
- show max bid in team info on team page (if current user in team)
- show max bid in the modal bid forms

# Post MVP Technical Debt Cleanup
- run `npm audit` and `npm audit fix`
- remove duplicated code in BidButton.js and NominateButton.js
- use Dataloader wherever possible
- (re-)enable authentication and authorization checks for nominationQueue field of queries returning team info
- (re-)enable authentication and authorization checks for hidden_high_bid field in all queries and subscriptions

# Post MVP Feature Priority
- user invitations (including to new or existing team)
- create new auction mutation
- database backup
- auction auto-nomination queue
- site admin page (with create new auction, create team, create invites)
- add Team page feature to add invited user to team
- auction admin page (that allows invites, shows nomination status)
- archive auction mutation (and add to site admin page)
- database backup and restore

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
