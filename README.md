# partybot 🍺

Partybot is a micro-service to interact with nightclub websites. Currently, it supports some of the most relevant nightclubs from [Porto Alegre](http://bit.ly/1pxkFsR): [Beco](http://beco203.com.br), [Cucko](http://cucko.com.br), & [Lab](http://www.labpoa.com.br).

## API

- `GET /parties` - retrieves information about the upcoming parties;
- `POST /subscriptions` - creates subcriptions for an user in the discount lists;

## Running

Partybot depends on [MongoDB](https://www.mongodb.org/), [Ruby](https://rvm.io/), and [Bundler](http://bundler.io/). Make sure you have them all installed and follow these steps:

1. `sudo mongod`
2. `bundle install`
3. `bundle exec rackup`

Partybot will be running on `http://localhost:9292/`

## Extending

If you want to add a nightclub to partybot you just need to define a new driver class for it under the `lib/drivers` directory. Each running instance of the service must specify a single driver class in a `DRIVER` environment variable.

## Deploying

So far, we tried partybot only on [Heroku](https://www.heroku.com/) and the deployment steps are automated in the `deploy` task (in `Rakefile`). If you want to re-use the same task make sure you have: (a) exported an environment variable with your application name; (b) added an environment variable on Heroku with your driver class name.
