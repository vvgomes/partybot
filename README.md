# partybot 🍺

Partybot is a micro-service to interact with nightclub websites. Currently supports some relevant nightclubs from [Porto Alegre](http://bit.ly/1pxkFsR):
- [Beco](http://beco203.com.br)
- [Cucko](http://cucko.com.br)
- [Lab](http://www.labpoa.com.br)

## API

- `GET /parties` - retrieves information about the upcoming parties;
- `POST /subscriptions` - subscribes an user to party discount lists;

## Running

Partybot depends on [MongoDB](https://www.mongodb.org/), [Ruby](https://rvm.io/), and [Bundler](http://bundler.io/). After making sure you have both installed, go about the follwoing steps:

1. `sudo mongod`
1. `bundle install`
2. `bundle exec rackup`

Partybot will be runnin on `http://localhost:9292/`

## Extending

If you want to add a nightclub to partybotyou just need to define a new driver class for it under the `lib/drivers` directory. Each running instance of the service must specify a single driver class in a `DRIVER` environment variable.

## Deploying

We only tested partybot on [Heroku](https://www.heroku.com/) so far. The deployiment steps are automated in taks the `Rakefile`. If you want to use the same task, make sure you have: (a) exported an environment variable with your application name; (b) exported an environment variable with your driver class name on Heroku.
