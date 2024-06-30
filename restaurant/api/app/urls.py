from django.urls import path, include
from . import views

urlpatterns = [
    path('categories', views.CategoryListView.as_view()),
    path('menu-items', views.MenuItemListView.as_view()),
    path('menu-items/<int:pk>', views.MenuItemDetailView.as_view()),
    path('groups/<str:group_name>/users', views.UserGroupListView.as_view()),
    path('groups/<str:group_name>/users/<int:pk>', views.UserGroupDeleteView.as_view()),
    path('cart/menu-items', views.UserCartView.as_view()),
    path('orders', views.OrderListView.as_view()),
    path('orders/<int:pk>', views.OrderDetailView.as_view()),

    path('', include('djoser.urls')),

]