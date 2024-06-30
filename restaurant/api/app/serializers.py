from django.contrib.auth.models import User, Group
from rest_framework import serializers
from .models import MenuItem, Category, Cart, Order, OrderItem

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ['name']

class MenuItemSerializer(serializers.ModelSerializer):
    category = serializers.PrimaryKeyRelatedField(queryset=Category.objects.all())

    class Meta:
        model = MenuItem
        fields = ['id', 'title', 'price', 'category', 'featured', 'image_url', 'description']  

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)  
    groups = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'email', 'username', 'password', 'groups']

    def get_groups(self, obj):
        return [group.name for group in obj.groups.all()]

class CartSerializer(serializers.ModelSerializer):
    menuitem = MenuItemSerializer()

    class Meta:
        model = Cart
        fields = ['user','quantity', 'price', 'unit_price', 'menuitem']


class OrderItemSerializer(serializers.ModelSerializer):
    menuitem = MenuItemSerializer()
    class Meta:
        model = OrderItem
        fields = ['menuitem', 'quantity', 'unit_price', 'price']


class OrderSerializer(serializers.ModelSerializer):
    order_items = OrderItemSerializer(many=True, read_only=True, source='orderitem_set')

    class Meta:
        model = Order
        fields = ['id', 'user', 'delivery_crew', 'status', 'total', 'date', 'order_items']
        extra_kwargs = {
            'total': {'required': False},
            'user': {'required': False},
        }

    def validate_delivery_crew(self, user):
        """
        Validates the 'delivery_crew' field.

        Raises a ValidationError if the user with the given ID is not found
        or is not part of the 'delivery-crew' group.
        """
        if not user.groups.filter(name='delivery-crew').exists():
            raise serializers.ValidationError("delivery crew must belong to 'delivery-crew' group.")
        return user
    
    def to_representation(self, instance):
        data = super().to_representation(instance)
        if instance.delivery_crew is None and instance.status == 0:
          data['status'] = "pending"
        elif instance.delivery_crew is not None and instance.status == 0:
         data['status'] = "ongoing"
        else:
          data['status'] = "completed"
        return data