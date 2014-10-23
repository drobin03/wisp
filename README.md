# WISP

## Installation

Clone the repository
```
git clone https://github.com/drobin03/wisp.git
```
Setup your Ruby on Rails Environment

Try this one-step installer: http://railsinstaller.org/en

Now prepare your environment
```
cd wisp
bundle
```

The bundle command should take a little bit of time. Once it is finished start the server
```
rails s
```

## Pulling updates

Pull the latest changes from github
```
git pull
```

Apply any database migrations to your local database
```
rake db:migrate
```

If the Gemfile has changed, run the bundler, otherwise skip this step
```
bundle
```

Start the server
```
rails s
```