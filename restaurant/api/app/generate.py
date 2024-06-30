from .models import Category, MenuItem

def create_categories():
  """
  Creates categories in the database based on a list of names.
  """
  categories = [
    'Main Courses',
    'Fast Food',
    'Appetizers',
    'Desserts',
    'Drinks',
]
  
  print('---creating the categories...')
  
  for category_name in categories:
      category, created = Category.objects.get_or_create(name=category_name)
      if created:
          print(f"Created category: {category.name}")

def create_menu_items(items_data):
  """
  Creates menu items in the database for a given category.
  """
  print('---creating new menu items...')

  for item_data in items_data:
      menu_item, created = MenuItem.objects.get_or_create(**item_data)
      if created:
          print(f"Created menu item: {menu_item.title} ({menu_item.category})")

def create_main_courses():
   category = Category.objects.get(name='Main Courses')
   main_course_items = [
        {'title': 'Jollof Rice (Seafood)', 'description': 'Spicy tomato-based rice with seafood', 'price': 60.00, 'featured': True, 'category': category, 'image_url': 'assets/images/jollof-rice.jpeg'}, 
        {'title': 'Benachin (Chicken & Vegetables)', 'description': 'Savory rice dish with chicken and vegetables', 'price': 50.00, 'featured': False, 'category': category, 'image_url': 'assets/images/benachin.jpeg'},
        {'title': 'Vegetable Fried Rice', 'description': 'Stir-fried rice with colorful vegetables', 'price': 40.00, 'featured': True, 'category': category, 'image_url': 'assets/images/vegetable-fried-rice.jpeg'}, 
        {'title': 'Chicken Curry with Rice', 'description': 'Creamy and flavorful curry with chicken', 'price': 55.00, 'featured': False, 'category': category, 'image_url': 'assets/images/chicken-curry-with-rice.jpeg'},
        {'title': 'Stew with Rice (Cassava Leaf)', 'description': 'Classic dish with rich stew and cassava leaves', 'price': 35.00, 'featured': False, 'category': category, 'image_url': 'assets/images/stew-with-rice.jpeg'},
    ]
   create_menu_items(main_course_items)

def create_fast_food():
   category = Category.objects.get(name='Fast Food')
   fast_food_items = [
        {'title': 'Shawarma (Chicken)', 'description': 'Marinated chicken with vegetables and tahini sauce in pita bread', 'price': 45.00, 'featured': False,'category': category, 'image_url': 'assets/images/shawarma.jpeg'},
        {'title': 'Patty (Meat Pie)', 'description': 'Savory pastry filled with spiced ground meat and vegetables', 'price': 25.00, 'featured': True,'category': category, 'image_url': 'assets/images/meat-pie.jpeg'}, 
        {'title': 'Chicken & Chips', 'description': 'Fried chicken pieces served with French fries', 'price': 40.00, 'featured': False,'category': category, 'image_url': 'assets/images/chicken-and-chip.jpeg'},
        {'title': 'Agege & Stew (Mini)', 'description': 'Small fried dough balls with flavorful stew', 'price': 35.00, 'featured': True,'category': category, 'image_url': 'assets/images/agege-and-stew.jpeg'}, 
        {'title': 'Pizza (Margherita)', 'description': 'Classic pizza with tomato sauce, mozzarella cheese, and basil', 'price': 50.00, 'featured': False,'category': category, 'image_url': 'assets/images/pizza.jpeg'},
    ]
   
   create_menu_items(fast_food_items)

def create_appetizers():    
   category = Category.objects.get(name='Appetizers')
   appetizer_items = [
        {'title': 'Boli (Roasted Plantains)', 'description': 'Sweet and caramelized roasted plantains', 'price': 20, 'featured': True, 'category': category, 'image_url': 'assets/images/boli.jpeg'}, 
        {'title': 'Fried Cassava', 'description': 'Deep-fried cassava pieces with crispy exterior', 'price': 15, 'featured': False, 'category': category, 'image_url': 'assets/images/fried-cassava.jpeg'},
        {'title': 'Agege (Fried Dough Balls)', 'description': 'Fluffy and slightly sweet fried dough balls', 'price': 10, 'featured': False, 'category': category, 'image_url': 'assets/images/agege.jpeg'},
        {'title': 'Spicy Cole Slaw', 'description': 'Shredded cabbage salad with a refreshing and spicy twist', 'price': 15, 'featured': True, 'category': category, 'image_url': 'assets/images/spicy-cole-slaw.jpeg'}, 
        {'title': 'Fried Plantains with Black Eyed Peas', 'description': 'Flavorful combination of fried plantains and stewed black-eyed peas', 'price': 25, 'featured': False, 'category': category, 'image_url': 'assets/images/fried-plantains-with-black-eyed-peas.jpeg'},
    ]
   create_menu_items(appetizer_items)
   
def create_dessert():
   category = Category.objects.get(name='Desserts')
   dessert_items = [
        {'title': 'Butter Cake', 'description': 'Dense and moist cake with a buttery flavor', 'price': 30, 'featured': False, 'category': category, 'image_url': 'assets/images/butter-cakes.jpeg'},
        {'title': 'Plantain Fritters', 'description': 'Sweet and crispy fritters made with mashed plantains', 'price': 25, 'featured': True, 'category': category, 'image_url': 'assets/images/plantain-fitters.jpeg'}, 
        {'title': 'Pine Balls (Sweetened Dough Balls)', 'description': 'Small balls of dough flavored with pineapple', 'price': 15, 'featured': False, 'category': category, 'image_url': 'assets/images/pine-balls.jpeg'},
        {'title': 'Coconut Candy', 'description': 'Traditional sweet made with grated coconut, sugar, and spices', 'price': 10, 'featured': True, 'category': category, 'image_url': 'assets/images/coconut-candy.jpeg'}, 
        {'title': 'Fried Dough with Honey (Zagbogi)', 'description': 'Light and fluffy deep-fried dough drizzled with honey', 'price': 15, 'featured': False, 'category': category, 'image_url': 'assets/images/fired-dough-with-honey.jpeg'},
    ]
   create_menu_items(dessert_items)

def create_drinks():
   category = Category.objects.get(name='Drinks')
   drink_items = [
        {'title': 'Bissap (Hibiscus Tea)', 'description': 'Vibrant red tea with a tart and refreshing taste', 'price': 15,'featured': True, 'category': category, 'image_url': 'assets/images/bissap.jpeg'},
        {'title': 'Poyo (Palm Wine)', 'description': 'Fermented palm sap with a slightly sweet and alcoholic taste', 'price': 20,'featured': False, 'category': category, 'image_url': 'assets/images/poyo.jpeg'},  
        {'title': 'Ginger Beer', 'description': 'Spicy and refreshing ginger-based drink', 'price': 10,'featured': True, 'category': category, 'image_url': 'assets/images/ginger-beer.jpeg'},
        {'title': 'Tombe Juice (Tamarind)', 'description': 'Sweet and tangy juice made from tamarind pulp', 'price': 12,'featured': True, 'category': category, 'image_url': 'assets/images/tombe-juice.jpeg'},
        {'title': 'Mango Juice', 'description': 'Fresh and tropical juice made from ripe mangoes', 'price': 18,'featured': False, 'category': category, 'image_url': 'assets/images/mango-juice.jpeg'},  
        {'title': 'Mineral Water', 'description': 'Bottled water', 'price': 5,'featured': True, 'category': category, 'image_url': 'assets/images/mineral-water.jpeg'},
        {'title': 'Soft Drinks (Selection)', 'description': 'Assorted popular soft drinks', 'price': 10,'featured': True, 'category': category, 'image_url': 'assets/images/soft-drinks.jpeg'},  
    ]
   create_menu_items(drink_items)

   
def generate():
   create_categories()
   create_main_courses()
   create_fast_food()
   create_appetizers()
   create_dessert()
   create_drinks()

