from django.urls import path
from .views import index

urlpatterns = [
    path('', index, name='students_index')
]
