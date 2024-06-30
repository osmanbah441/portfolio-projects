## Restaurant Management System API Documentation

This API provides functionalities for managing a restaurant, including categories, menu items, user groups, carts, orders, and user authentication (using django-djoser).

**Authentication**

This API uses django-djoser for authentication. Please refer to the djoser documentation for details on available endpoints: [https://djoser.readthedocs.io/](https://djoser.readthedocs.io/)

**Resources**

| Resource | Method | URI | Description | Permission |
|---|---|---|---|---|
| **Categories** | GET | `/categories` | Retrieves a list of all categories. | manager |
| | POST | `/categories` | Creates a new category. | manager |
| **Menu Items** | GET | `/menu-items` | Retrieves a list of all menu items (supports search, category filter, and price sorting). | customer |
| | POST | `/menu-items` | Creates a new menu item. | manager |
| | GET | `/menu-items/<int:pk>` | Retrieves details of a specific menu item by its ID. | customer |
| | PUT | `/menu-items/<int:pk>` | Updates details of a specific menu item by its ID. | manager |
| | DELETE | `/menu-items/<int:pk>` | Deletes a specific menu item by its ID. | manager |
| **User Groups** | GET | `/groups/<str:group_name>/users` | Retrieves a list of users belonging to a specific group. | manager |
| | POST | `/groups/<str:group_name>/users` | Adds a user to a specified group. Requires `username` in the request data. | manager |
| | DELETE | `/groups/<str:group_name>/users/<int:pk>` | Removes a user from a specified group. | manager |
| **Cart** | GET | `/cart/menu-items` | Retrieves a list of menu items currently in the user's cart. | customer |
| | POST | `/cart/menu-items` | Adds a menu item to the user's cart or updates the quantity of an existing item. Requires `menuitem_id` and `quantity` (optional, defaults to 1) in the request data. | customer |
| | DELETE | `/cart/menu-items` | Clears all items from the user's cart. | customer |
| **Orders** | GET | `/orders` | Retrieves a list of orders. Managers see all orders, delivery crew see their assigned orders, and customers see their own orders. | customers |
| | POST | `/orders` | Creates a new order from the user's cart. The cart will be emptied after a successful order creation. | customer |
| | GET | `/orders/<int:pk>` | Retrieves details of a specific order by its ID. | customer |
| | PATCH | `/orders/<int:pk>` | Updates the status of an order (only delivery crew can patch). Requires `status` set to 0 (pending) or 1 (completed) in the request data. | manager, delivery-crew |
| **Users** | POST | `/api/users/` | Register a new user | - |
|  | POST | `/token/login` | Log in an existing user | - |
|  | POST | `/token/logout` | Log out the currently authenticated user | Customer |
|  | GET | `/users/me` | Access details of the currently authenticated user | Customer |


### Other feature.

**Pagination**
The API shows data in pages. By default, you see 10 items per page. Use the page and page_size query parameter to specify the page and the page_size or number of item to be return. e.g `/menu-items?page=2&&page_size=15`

**Searching**
Need a specific menu item? Use the search query parameter to narrow things down `/menu-items?search=pizza` shows items containing "pizza" in the name or description.

**Filtering**
Want to see only appetizers? Use the category query parameter to filter `/menu-items?category=appetizers` shows only appetizer items.
**Error Handling**

The API returns appropriate error codes (e.g., 400 for bad request, 404 for not found) and informative error messages.