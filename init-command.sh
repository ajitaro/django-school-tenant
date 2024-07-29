# create venv
python -m venv venv
venv\Scripts\activate

# pip install
pip install Django
pip install django-tenants
pip install psycopg2 # database connector (Django and PostgreSQL)
pip install python-decouple # for .env

pip freeze > requirements.txt


django-admin startproject tenant_project .

django-admin startapp schools
django-admin startapp students
django-admin startapp dashboard


# django-tenants setup, https://django-tenants.readthedocs.io/en/latest/install.html


# postgresql setup, https://stackpython.medium.com/how-to-start-django-project-with-a-database-postgresql-aaa1d74659d8
# bikin database dulu
# tambahin di settings.py beserta env nya di .env
# DATABASES = {
#     'default': {
#         'ENGINE': 'django_tenants.postgresql_backend',
#         'NAME': config('DB_NAME'),
#         'USER': config('DB_USER'),
#         'PASSWORD': config('DB_PASSWORD'),
#         'HOST': config('DB_HOST'),
#         'PORT': config('DB_PORT'),
#     }
# }


python manage.py makemigrations
python manage.py migrate_schemas --shared
# make sure database dalam keadaan kosong ketika command ini dijalankan pertama kali
# this will create the shared apps on the public schema. Note: your database should be empty if this is the first time you’re running this command

# You might need to run makemigrations and then migrate_schemas --shared again for your app.Models to be created in the database.
# ketika ada perubahan models di schools, jalankan makemigrations dan migrate_schemas --shared



# Bikin public tenant, untuk client yg belum punya schools
python manage.py shell
from schools.models import Client, Domain

# create your public tenant
tenant = Client(schema_name='public', name='Public')
tenant.save()

# Add one or more domains for the tenant
domain = Domain(domain='localhost', tenant=tenant, is_primary=True)
# domain.domain = 'localhost' # don't add your port or www here! on a local server you'll want to use localhost here
# domain.tenant = guest
# domain.is_primary = True
domain.save()

# Bikin tenant, untuk client yg daftar
tenant = Client(schema_name='pgri3', name='SMP PGRI 3')
tenant.save()
domain = Domain(domain='pgri3.localhost', tenant=tenant, is_primary=True)
domain.save()
# exit()
python manage.py runserver



# Admin ditaro di public schema (schools)
# tambahin ini di settings.py
# untuk public schema pakai schools urls, untuk yang lainnya gunakan project urls
PUBLIC_SCHEMA_URLCONF = 'schools.urls'
# jadi kalo ada yg akses root '/', bakal pakai urls di schools.


# buat model Student di app students
python manage.py makemigrations
python manage.py migrate_schemas