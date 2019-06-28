# Another Triple Triad Tracker
This is yet another application for tracking your Final Fantasy XIV Triple Triad card collection written in [Ruby on Rails](https://rubyonrails.org/) and powered by [Saint Coinach](https://github.com/ufx/SaintCoinach). This application strives to be as autonomous as possible by pulling its card and NPC data from the game files via [Saint Coinach](https://github.com/ufx/SaintCoinach). This ensures that manual data entry is only required for data not available on the client side, such as instance drop locations. Even if the card source is unknown, the cards themselves will still be created and the source can easily be updated later when it becomes known.

## API

All of this application's data is made available through a RESTful JSON API. See the [wiki](https://github.com/mattantonelli/ffxiv-triple-triad/wiki) for details.

## Dependencies
* Ruby (2.4.1)
* Rails (5.2.1)
* MySQL
* Redis

## Installation
#### Clone and initialize the repository
```
git clone https://github.com/mattantonelli/ffxiv-triple-triad
cd ffxiv-triple-triad
bundle install
bundle exec rake app:update:bin
```

#### Set up the database
Create the MySQL databases `triad_development` and `triad_test` as well as a database user with access to them

#### Create the necessary 3rd party applications
1. Create a new [Discord app](https://discordapp.com/developers/applications/) for user authentication. Take note of the **client ID** and **secret**.
    1. Set the redirect URI on the OAuth2 page of your app: `http://localhost:3000/users/auth/discord/callback`
2. Configure the credentials file to match the format below using your data.
```
rm config/credentials.yml.enc
rails credentials:edit
```
```yml
mysql:
  development:
    username: username
    password: password
discord:
  client_id: 123456789
  client_secret: abc123
google_analytics:
  tracking_id: GA-1234567-8
```

#### Load the database
```
bundle exec rake db:schema:load
bundle exec rake data:initialize
```

#### Schedule jobs
Run `whenever` to schedule the application's cronjobs.

```
bundle exec whenever -s 'environment=INSERT_ENV_HERE' --update-crontab
```

Please note that if you did not install your Ruby using rbenv, you will need to change the bundle command located in `config/schedule.rb`

#### Start the server
```
rails server
```

## Updating
When new cards & NPCs become available on patch day, they can be loaded into the database by running the `data:update` rake task.

```
bundle exec rake data:update
bundle exec rake assets:precompile
# Restart the application
bundle exec rails console
Card.where('created_at > ?', Date.current.beginning_of_day).update_all(patch: 'CURRENT PATCH')
NPC.where('created_at > ?', Date.current.beginning_of_day).update_all(patch: 'CURRENT PATCH')
exit
```

This data is available once the [data repository](https://github.com/mattantonelli/ffxiv-triple-triad-data) has been updated with the latest patch data.

More action may be required in the event of complex game updates (e.g. new card types, packs, etc.) Patch data must be populated manually.

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
