# Django School Tenant

This project is a Django application set up to use multi-tenancy with `django-tenants` and PostgreSQL. It includes three Django apps: `schools`, `students`, and `dashboard`.

## Getting Started

Follow these steps to set up your development environment and run the project.

### 1. Create and Activate Virtual Environment

```bash
python -m venv venv
```

On Windows

```bash
venv\Scripts\activate
```

On macOS/Linux:

```bash
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install Django
pip install django-tenants
pip install psycopg2
pip install python-decouple
```

Generate the requirements.txt file:

```bash
pip freeze > requirements.txt
```

### 3. Set Up the Django Project

Create the Django project and apps:

```bash
django-admin startproject tenant_project .
django-admin startapp schools
django-admin startapp students
django-admin startapp dashboard
```

### 4. Configure Django-Tenants

Follow the setup instructions for `django-tenants` [here](https://django-tenants.readthedocs.io/en/latest/install.html).

### 5. Set Up PostgreSQL

Follow the PostgreSQL setup guide [here](https://stackpython.medium.com/how-to-start-django-project-with-a-database-postgresql-aaa1d74659d8).

1. **Create a PostgreSQL Database**

   - Use a PostgreSQL client or command-line tools to create a new database.
   - Example using `psql` command-line tool:

     ```bash
     psql -U postgres
     CREATE DATABASE mydatabase;
     ```

2. **Configure Database Settings**

   - Open `settings.py` and configure the `DATABASES` setting to use `django-tenants` with PostgreSQL.
   - Add the following configuration:

     ```python
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
     ```

3. **Add Environment Variables**

   - Create a `.env` file in the root directory of your project to store sensitive information.
   - Add the following environment variables to the `.env` file:

     ```env
     DB_NAME=mydatabase
     DB_USER=myuser
     DB_PASSWORD=mypassword
     DB_HOST=localhost
     DB_PORT=5432
     ```

   - Install `python-decouple` if you haven’t already, to manage environment variables:

     ```bash
     pip install python-decouple
     ```

   - Ensure you have the following in your `settings.py` to read from the `.env` file:

     ```python
     from decouple import config
     ```

### 6. Apply Migrations

Create and apply initial migrations:

```bash
python manage.py makemigrations
python manage.py migrate_schemas --shared
```

_Ensure that the database is empty when running the `migrate_schemas --shared` command for the first time._

### 7. Create Public and Tenant Data

Create a public tenant and a new tenant using Django's shell:

```bash
python manage.py shell
```

In the shell:

```python
from schools.models import Client, Domain

# Create public tenant
tenant = Client(schema_name='public', name='Public')
tenant.save()

# Add domain for public tenant
domain = Domain(domain='localhost', tenant=tenant, is_primary=True)
domain.save()

# Create a tenant for a new client
tenant = Client(schema_name='maplehigh', name='Maple High School')
tenant.save()
domain = Domain(domain='maplehigh.localhost', tenant=tenant, is_primary=True)
domain.save()
exit()
```

### 8. Run the Development Server

```bash
python manage.py runserver
```

### 9. Configure Public Schema URL Configuration

In settings.py, add the following to use the schools URLs for the public schema:

```bash
PUBLIC_SCHEMA_URLCONF = 'schools.urls'
```

### 10. Create Models

Create the Student model in the students app:

```bash
python manage.py makemigrations
python manage.py migrate_schemas
```

## Notes

- For changes in models, always run `makemigrations` followed by `migrate_schemas --shared`.
- _Make sure to properly configure your PostgreSQL database and update your `.env` file accordingly._

## Additional Resources

- [Django Documentation](https://docs.djangoproject.com/)
- [django-tenants Documentation](https://django-tenants.readthedocs.io/en/latest/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

_These resources are useful for further reading and understanding the technologies used in this project._
