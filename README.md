# Another Triple Triad Tracker
This is yet another application for tracking your Final Fantasy XIV Triple Triad card collection written in [Ruby on Rails](https://rubyonrails.org/) and powered by [XIVAPI](https://xivapi.com/). This application strives to be as autonomous as possible by pulling its card and NPC data from the game files via [XIVAPI](https://xivapi.com/). This ensures that manual data entry is only required for data not available on the client side, such as instance drop locations. Even if the card source is unknown, the cards themselves will still be created and the source can easily be updated later when it becomes known.

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
  2. Create a new [XIVAPI app](https://xivapi.com/app) for retrieving the data. Take note of the application **key**.
  3. Configure the credentials file to match the format below using your data.
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
  xivapi_key: def456
  ```

#### Load the database
```
bundle exec rake db:schema:load
bundle exec rake all:load card_sources:set card_packs:create
```

#### Start the server
```
rails server
```

## Updating
When new cards & NPCs become available on patch day, they can be loaded into the database by rerunning the `all:load` rake task.

```
bundle exec rake db:schema:load
```

More action may be required in the event of complex game updates (e.g. new card types, packs, etc.)

---

FINAL FANTASY is a registered trademark of Square Enix Holdings Co., Ltd.

FINAL FANTASY XIV © SQUARE ENIX CO., LTD.
