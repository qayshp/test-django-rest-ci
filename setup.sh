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

cat <<DELIM | sed 's/^    //' >> hellodjango/settings.py
    # Parse database configuration from $DATABASE_URL
    import dj_database_url
    DATABASES['default'] =  dj_database_url.config()

    # Honor the 'X-Forwarded-Proto' header for request.is_secure()
    SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

    # Allow all host headers
    ALLOWED_HOSTS = ['*']

    # Static asset configuration
    import os
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))
    STATIC_ROOT = 'staticfiles'
    STATIC_URL = '/static/'

    STATICFILES_DIRS = (
        os.path.join(BASE_DIR, 'static'),
    )
DELIM

cat <<DELIM | sed 's/^    //' >> hellodjango/wsgi.py
    from django.core.wsgi import get_wsgi_application
    from dj_static import Cling

    application = Cling(get_wsgi_application())
DELIM

cat <<DELIM | sed 's/^    //' >> ../.gitignore
    venv
    *.pyc
    staticfiles
DELIM
