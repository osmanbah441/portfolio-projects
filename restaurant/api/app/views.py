from django.contrib.auth.models import Group, User
from django.shortcuts import get_object_or_404
from rest_framework.response import Response
from rest_framework import status
from rest_framework import generics
from rest_framework.views import APIView

from .models import MenuItem, OrderItem, Order, Cart, Category
from .serializers import MenuItemSerializer, UserSerializer, OrderSerializer, CartSerializer,CategorySerializer
from .security import CustomPageNumberPagination
from . import permissions

class CategoryListView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticatedReadOnlyAndManagerWrite]
    serializer_class = CategorySerializer
    queryset = Category.objects.all()

class MenuItemListView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticatedReadOnlyAndManagerWrite]
    serializer_class = MenuItemSerializer
    pagination_class = CustomPageNumberPagination
    

    def get_queryset(self):
        queryset = MenuItem.objects.all()
       
        # Filter by search
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(title__icontains=search)
        
        # Filter by category
        category_name = self.request.query_params.get('category')
        if category_name:
            queryset = queryset.filter(category__name__icontains=category_name)

        # Sort by price
        sort_by_price = self.request.query_params.get('price')
        if sort_by_price == 'asc':
            queryset = queryset.order_by('price')
        elif sort_by_price == 'desc':
            queryset = queryset.order_by('-price')

        return queryset


class MenuItemDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = MenuItem.objects.all()
    permission_classes = [permissions.IsAuthenticatedReadOnlyAndManagerWrite]
    serializer_class = MenuItemSerializer


class UserGroupListView(generics.ListCreateAPIView):
    permission_classes = [permissions.IsManager]
    serializer_class = UserSerializer

    def get_queryset(self):
        group_name = self.kwargs['group_name']
        group = Group.objects.get(name=group_name)
        return group.user_set.all()

    def create(self, request, *args, **kwargs):
        username = request.data.get('username', None)
        if username is None:
            return Response({"error": "username is required"}, status=status.HTTP_400_BAD_REQUEST)

        user = self.get_existing_user(username)
        if user:
            return self.add_user_to_group(user)
        else:
            return Response({"error": "user does not exist"}, status=status.HTTP_400_BAD_REQUEST)

    def get_existing_user(self, username):
        try:
            return User.objects.get(username=username)
        except User.DoesNotExist:
            return None

    def add_user_to_group(self, user):
        group_name = self.kwargs['group_name']
        group = Group.objects.get(name=group_name)
        if user.groups.filter(name=group_name).exists():
            return Response({"error": f"user is already in the {group_name} group"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            group.user_set.add(user)
            return Response({"message": f"user added to the {group_name} group"},status=status.HTTP_201_CREATED)
        

class UserGroupDeleteView(generics.DestroyAPIView):
    permission_classes = [permissions.IsManager]
    queryset = User.objects.all()  
    serializer_class = UserSerializer

    def perform_destroy(self, instance):
        group_name = self.kwargs['group_name']
        group = Group.objects.get(name=group_name)

        if instance.groups.filter(name=group_name).exists():
            group.user_set.remove(instance)
            return Response({"success": f"user removed from {group_name} group"}, status=status.HTTP_204_NO_CONTENT)
        else:
            return Response({"error": f"user is not a member of the group"}, status=status.HTTP_400_BAD_REQUEST)


class UserCartView(APIView):
    permission_classes = [permissions.IsCustomer]

    def get_queryset(self, *args, **kwargs):
        return Cart.objects.filter(*args, **kwargs)

    def create_or_update_cart_item(self, user, menuitem_id, quantity):
        menuitem = get_object_or_404(MenuItem, pk=menuitem_id)
        existing_item = self.get_queryset(user=user, menuitem=menuitem).first()
        if existing_item:
            existing_item.quantity += quantity
            existing_item.price = existing_item.unit_price * existing_item.quantity
            existing_item.save()
            return existing_item
        
        unit_price = menuitem.price
        total_price = unit_price * quantity
        return Cart.objects.create(user=user, menuitem=menuitem, quantity=quantity, price=total_price, unit_price=unit_price)
        

    def get(self, request):
        cart_items = self.get_queryset(user=request.user)
        serializer = CartSerializer(cart_items, many=True)
        return Response(serializer.data)

    def post(self, request):
        quantity = request.data.get('quantity', 1)
        menuitem_id = request.data.get("menuitem_id")
        if not menuitem_id:
            return Response({'detail': 'Missing menuitem_id in request data.'}, status=400)
        
        cart_item =  self.create_or_update_cart_item(request.user, menuitem_id, quantity)
        serializer = CartSerializer(cart_item)
        return Response(serializer.data)

    def delete(self, request):
        self.get_queryset(user=request.user).delete()
        return Response(status=200)


class OrderListView(APIView):
    permission_classes = [permissions.IsCustomer]

    def get(self, request):
        if permissions.is_manager_member(request):
            orders = Order.objects.all()
        elif permissions.is_delivery_crew_member(request):
            orders = Order.objects.filter(delivery_crew=request.user)
        else:
            orders = Order.objects.filter(user=request.user)

        status = self.request.query_params.get('status')
        if status:
            print(f'status was sent {status}')
            if status.lower() == 'pending':
                orders = orders.filter(status=0, delivery_crew__isnull=True)
            elif status.lower() == 'ongoing':
                orders = orders.filter(status=0, delivery_crew__isnull=False)
            elif status.lower() == 'completed':
                orders = orders.filter(status=1)
                
        
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)

    def post(self, request):
        cart_items = Cart.objects.filter(user=request.user)
        if not cart_items.exists():
            return Response({"details": "cart must not be empty"}, status=status.HTTP_400_BAD_REQUEST)

        order_total = sum(item.price for item in cart_items)
        order = Order.objects.create(user=request.user, total=order_total)
        for cart_item in cart_items:
            OrderItem.objects.create(
                order=order,
                menuitem=cart_item.menuitem,
                quantity=cart_item.quantity,
                unit_price=cart_item.unit_price,
                price=cart_item.price
            )

        cart_items.delete()

        serializer = OrderSerializer(order)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class OrderDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = OrderSerializer
    permission_classes = [permissions.IsAuthenticatedReadOnlyAndManagerWriteAndDeliveryPatch]

    def get_queryset(self):
        if permissions.is_manager_member(self.request):
            return Order.objects.all()
        
        if permissions.is_delivery_crew_member(self.request):
            return Order.objects.filter(delivery_crew=self.request.user)
        
        return Order.objects.filter(user=self.request.user)
    
    def patch(self, request, *args, **kwargs):
        if permissions.is_delivery_crew_member(request):
            status_value = request.data.get('status', None)
            if status_value in [0, 1]:
                instance = self.get_object()
                instance.status = status_value
                instance.save()
                return Response({"success": f"status updated to {status_value}"})
            
            return Response({"error": "status must be set to 1 or 0"}, status=status.HTTP_400_BAD_REQUEST)

        return super().patch(request, *args, **kwargs)