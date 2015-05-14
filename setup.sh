#!/bin/zsh

#####################
# https://devcenter.heroku.com/articles/python-runtimes
#####################
cat <<DELIM | sed 's/^    //' > runtime.txt
    python-3.4.2
DELIM

#####################
# https://devcenter.heroku.com/articles/getting-started-with-django
#####################
mkdir hellodjango && cd hellodjango
virtualenv venv -p python3
source venv/bin/activate

# sudo find / -name "pg_config" -print
PATH=$PATH:/Library/PostgreSQL/9.3/bin/

pip install django-toolbelt

django-admin.py startproject hellodjango .

cat <<DELIM | sed 's/^    //' > Procfile
    web: gunicorn hellodjango.wsgi --log-file -
DELIM

pip freeze > requirements.txt
