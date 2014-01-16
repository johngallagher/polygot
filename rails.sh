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

alias gps='git push origin `git rev-parse --abbrev-ref HEAD`'

function bundle_install {
  count_of_gemfiles=`ls | grep '^Gemfile$' | wc -l`
  if [[ count_of_gemfiles -eq 0 ]] then return; fi

  gemfile_changes=`git diff HEAD~1 Gemfile`
  if [[ "$gemfile_changes" != "" ]] then
    echo "Gemfile has changed - running bundle install."
    bundle install
  fi
}

function migrate_db {
  database_present=`ls | grep '^db$' | wc -l`
  if [[ database_present -eq 0 ]] then return; fi

  migration_changes=`git diff HEAD~1 db`
  if [[ "$migration_changes" != "" ]] then
    echo "Migration detected - migrating database."
    rdbm
  fi
}

function gpl {
  git pull origin `git rev-parse --abbrev-ref HEAD`

  bundle_install
  migrate_db
}

function push_current_branch {
  echo "All tests pass. Pushing..."
  git push origin `git rev-parse --abbrev-ref HEAD`
}

function gprs {
  echo "Running rspec tests..."
  bundle exec rspec
  if [[ $? == 0 ]];
    then
    cucumber_gem=`cat Gemfile | grep "cucumber-rails"`
    if [[ "$cucumber_gem" != "" ]];
      then
      echo "Running cucumber features..."
      bundle exec cucumber
      if [[ $? == 0 ]];
        then
        push_current_branch
      else
        echo "Cucumber tests fail. Not pushing."
      fi
    else
      push_current_branch
    fi
  else
    echo "Rspec tests fail. Not pushing."
  fi
}

function gpprs {
  echo "Pulling..."
  gpl
  echo "Pushing..."
  gprs
    }