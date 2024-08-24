# Create a virtual environment
python -m venv venv
venv\Scripts\activate

# Install required packages
pip install Django
pip install django-tenants
pip install psycopg2 # Database connector (Django and PostgreSQL)
pip install python-decouple # For managing environment variables in .env

# Save the installed packages to requirements.txt
pip freeze > requirements.txt

# Start a new Django project
django-admin startproject tenant_project .

# Create Django apps
django-admin startapp schools
django-admin startapp students
django-admin startapp dashboard

# Set up django-tenants following the guide: https://django-tenants.readthedocs.io/en/latest/install.html

# Set up PostgreSQL following the guide: https://stackpython.medium.com/how-to-start-django-project-with-a-database-postgresql-aaa1d74659d8

# First, create the database
# Then, add the following to your settings.py along with environment variables in .env
DATABASES = {
    'default': {
        'ENGINE': 'django_tenants.postgresql_backend',
        'NAME': config('DB_NAME'),
        'USER': config('DB_USER'),
        'PASSWORD': config('DB_PASSWORD'),
        'HOST': config('DB_HOST'),
        'PORT': config('DB_PORT'),
    }
}

# Make migrations and migrate schemas
python manage.py makemigrations
python manage.py migrate_schemas --shared
# Ensure the database is empty when running this command for the first time.
# This will create the shared apps on the public schema. Note: Your database should be empty if this is the first time you're running this command.

# You might need to run makemigrations and then migrate_schemas --shared again for your app models to be created in the database.
# Whenever there's a change in models within the schools app, run makemigrations and migrate_schemas --shared

# Create a public tenant for clients who do not have schools yet
python manage.py shell
from schools.models import Client, Domain

# Create your public tenant
tenant = Client(schema_name='public', name='Public')
tenant.save()

# Add one or more domains for the tenant
domain = Domain(domain='localhost', tenant=tenant, is_primary=True)
# domain.domain = 'localhost' # Don't add your port or www here! On a local server, you'll want to use 'localhost' here
# domain.tenant = guest
# domain.is_primary = True
domain.save()

# Create a tenant for a client who registers
tenant = Client(schema_name='maplehigh', name='Maple High School')
tenant.save()
domain = Domain(domain='maplehigh.localhost', tenant=tenant, is_primary=True)
domain.save()

# Exit the shell
exit()

# Run the development server
python manage.py runserver

# Set up the admin to be located in the public schema (schools)
# Add the following to your settings.py
# Use the schools URLs for the public schema and the project URLs for others
PUBLIC_SCHEMA_URLCONF = 'schools.urls'
# Therefore, if someone accesses the root '/', it will use the URLs in the schools app.

# Create the Student model in the students app
python manage.py makemigrations
python manage.py migrate_schemas
