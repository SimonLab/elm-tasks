# elm-tasks
Elm application to manage tasks

## Heroku deployement

- Create a new Heroku application
- In the settings, add the following link as buildpack: https://github.com/heroku/heroku-buildpack-static.git
- Make sure to have the latest version of your Elm app compiled with: `elm make src/Main.elm --output elm.js --optimize`
- Commit your latest changes to Github
- On Heroku, deploy your branch containing the latest change.