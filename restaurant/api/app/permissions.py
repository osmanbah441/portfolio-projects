from rest_framework.permissions import BasePermission

class IsCustomer(BasePermission):
    def has_permission(self, request, view):
        return bool(
            request.user and
            request.user.is_authenticated
            )


class IsManager(BasePermission):
    def has_permission(self, request, view):
        return bool(
            request.user and
            request.user.is_authenticated and
            is_manager_member(request)
            )


class IsDeliveryCrew(BasePermission):
    def has_permission(self, request, view):
        return bool(
            request.user and
            request.user.is_authenticated and
            is_delivery_crew_member(request)
            )
    

class IsAuthenticatedReadOnlyAndManagerWrite(BasePermission):
    def has_permission(self, request, view):
        if request.method == "GET":
            return IsCustomer().has_permission(request, view)
        else:
            return IsManager().has_permission(request, view)

class IsAuthenticatedReadOnlyAndManagerWriteAndDeliveryPatch(BasePermission):
    def has_permission(self, request, view):
        if request.method == "GET":
            return IsCustomer().has_permission(request, view)
        if request.method == "PATCH":
            return bool (
                IsDeliveryCrew().has_permission(request,view) or 
                IsManager().has_permission(request, view)
                )
        else:
            return IsManager().has_permission(request, view)

def is_manager_member(request):
    return request.user.groups.filter(name='manager').exists()

def is_delivery_crew_member(request):
    return request.user.groups.filter(name='delivery-crew').exists()