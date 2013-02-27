function rails-new {
  if [[ -z $1 ]]
  then
    echo "Please supply a project name" >&2
    return 1
  elif [[ -d $1 ]]
  then
    echo "$1 already exists" >&2
    return 2
  fi

  project_name=$1

  echo "Creating $project_name"
  rails new $project_name -T -m https://raw.github.com/edgecase/ecrails_templates/master/rails_templates/ecuk_standard_app.rb
  [[  $? -eq 0 ]] || return 3

  cd $project_name
  for d in models views helpers controllers
  do
    echo "Creating spec/$d"
    mkdir -p spec/$d
  done
  echo "Creating spec helper"
  touch spec/spec_helper.rb
}

function restart {
  [[ ! -z $(git remote) ]] && git pull origin
  bundle install &&
  bundle exec rake db:migrate db:test:prepare &&
  bundle exec rspec &&
  bundle exec rails s
}

alias rdbm='echo Migrating db and prepping test db; bundle exec rake db:migrate db:test:prepare'

alias tb='torquebox'

alias rsp='clear; bundle exec rspec'

alias trsp='clear; date; bundle exec rspec; date'

alias gprs='echo "bundle exec rspec"; bundle exec rspec; rc=$?; if [[ $rc == 0 ]]; then echo "All tests pass. Pushing..."; git push origin `git rev-parse --abbrev-ref HEAD`; else echo "Tests fail. Not pushing."; fi'

alias gps='git push origin `git rev-parse --abbrev-ref HEAD`'

function gpl {
  git pull origin `git rev-parse --abbrev-ref HEAD`
  gemfile_changes=`git diff HEAD~1 Gemfile`
  if [[ "$gemfile_changes" != "" ]]
    then
    echo "Gemfile has changed - running bundle install."
    bundle install
  fi

  migration_changes=`git diff HEAD~1 db`
  if [[ "$migration_changes" != "" ]]
    then
    echo "Migration detected - migrating database."
    rdbm
  fi
}