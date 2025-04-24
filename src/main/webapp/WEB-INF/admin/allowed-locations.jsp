<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Allowed Locations" scope="request" />
<c:set var="userRole" value="${user.role.toLowerCase()}" scope="request" />

<c:set var="additionalHead">
    <script>
        function confirmDelete(locationId, locationName) {
            if (confirm('Are you sure you want to delete the location "' + locationName + '"?')) {
                document.getElementById('deleteLocationId').value = locationId;
                document.getElementById('deleteForm').submit();
            }
        }

        function initMap() {
            // Initialize the map if the map container exists
            const mapContainer = document.getElementById('location-map');
            if (!mapContainer) return;

            // Default center (can be overridden by form values)
            let center = { lat: 27.7172, lng: 85.3240 }; // Default to Kathmandu
            let zoom = 13;

            // Get values from form if in edit mode
            const latInput = document.getElementById('latitude');
            const lngInput = document.getElementById('longitude');
            const radiusInput = document.getElementById('radius');

            if (latInput && latInput.value && lngInput && lngInput.value) {
                center = {
                    lat: parseFloat(latInput.value),
                    lng: parseFloat(lngInput.value)
                };
            }

            // Create the map
            const map = new google.maps.Map(mapContainer, {
                center: center,
                zoom: zoom,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                mapTypeControl: true,
                streetViewControl: true,
                fullscreenControl: true
            });

            // Create a marker for the location
            const marker = new google.maps.Marker({
                position: center,
                map: map,
                draggable: true,
                title: 'Location'
            });

            // Create a circle to represent the radius
            const circle = new google.maps.Circle({
                map: map,
                radius: radiusInput ? parseInt(radiusInput.value) : 100,
                fillColor: '#3B82F6',
                fillOpacity: 0.2,
                strokeColor: '#3B82F6',
                strokeOpacity: 0.8,
                strokeWeight: 2
            });

            // Bind the circle to the marker
            circle.bindTo('center', marker, 'position');

            // Update form values when marker is dragged
            google.maps.event.addListener(marker, 'dragend', function() {
                const position = marker.getPosition();
                if (latInput && lngInput) {
                    latInput.value = position.lat().toFixed(6);
                    lngInput.value = position.lng().toFixed(6);
                }
            });

            // Update circle radius when radius input changes
            if (radiusInput) {
                radiusInput.addEventListener('input', function() {
                    const radius = parseInt(this.value) || 100;
                    circle.setRadius(radius);
                });
            }

            // Add click event to map to move marker
            google.maps.event.addListener(map, 'click', function(event) {
                marker.setPosition(event.latLng);
                if (latInput && lngInput) {
                    latInput.value = event.latLng.lat().toFixed(6);
                    lngInput.value = event.latLng.lng().toFixed(6);
                }
            });
        }
    </script>
    <!-- Google Maps API - No API key needed for development -->
    <script src="https://maps.googleapis.com/maps/api/js?callback=initMap" async defer></script>
</c:set>

<c:set var="mainContent">
    <div class="flex justify-between items-center mb-6">
        <h1 class="text-2xl font-semibold text-gray-900">Manage Allowed Locations</h1>
        <button id="add-location-btn" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
            </svg>
            Add New Location
        </button>
    </div>

    <!-- Location Form -->
    <div id="location-form" class="bg-white shadow overflow-hidden sm:rounded-lg mb-8 ${editMode ? '' : 'hidden'}">
        <div class="px-4 py-5 sm:px-6 bg-gray-50">
            <h3 class="text-lg leading-6 font-medium text-gray-900">${editMode ? 'Edit' : 'Add'} Location</h3>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">
                ${editMode ? 'Update the details of an existing location' : 'Add a new allowed location for attendance check-ins'}
            </p>
        </div>
        <div class="border-t border-gray-200 px-4 py-5 sm:p-6">
            <form action="${pageContext.request.contextPath}/${userRole}/locations" method="post" class="space-y-6">
                <input type="hidden" name="action" value="${editMode ? 'update' : 'add'}">
                <c:if test="${editMode}">
                    <input type="hidden" name="locationId" value="${location.id}">
                </c:if>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="col-span-1">
                        <div class="space-y-6">
                            <div>
                                <label for="name" class="block text-sm font-medium text-gray-700">Location Name</label>
                                <div class="mt-1">
                                    <input type="text" name="name" id="name" value="${location.name}" required
                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"
                                        placeholder="e.g., Main Office">
                                </div>
                                <p class="mt-1 text-sm text-gray-500">A descriptive name for this location</p>
                            </div>

                            <div>
                                <label for="latitude" class="block text-sm font-medium text-gray-700">Latitude</label>
                                <div class="mt-1">
                                    <input type="text" name="latitude" id="latitude" value="${location.latitude}" required
                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"
                                        placeholder="e.g., 27.7172">
                                </div>
                                <p class="mt-1 text-sm text-gray-500">Decimal latitude coordinate</p>
                            </div>

                            <div>
                                <label for="longitude" class="block text-sm font-medium text-gray-700">Longitude</label>
                                <div class="mt-1">
                                    <input type="text" name="longitude" id="longitude" value="${location.longitude}" required
                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"
                                        placeholder="e.g., 85.3240">
                                </div>
                                <p class="mt-1 text-sm text-gray-500">Decimal longitude coordinate</p>
                            </div>

                            <div>
                                <label for="radius" class="block text-sm font-medium text-gray-700">Radius (meters)</label>
                                <div class="mt-1">
                                    <input type="number" name="radius" id="radius" value="${location.radius}" min="10" max="5000" required
                                        class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"
                                        placeholder="e.g., 100">
                                </div>
                                <p class="mt-1 text-sm text-gray-500">Allowed radius in meters (10-5000)</p>
                            </div>

                            <div class="flex items-start">
                                <div class="flex items-center h-5">
                                    <input id="isActive" name="isActive" type="checkbox" ${location.active ? 'checked' : ''}
                                        class="focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300 rounded">
                                </div>
                                <div class="ml-3 text-sm">
                                    <label for="isActive" class="font-medium text-gray-700">Active</label>
                                    <p class="text-gray-500">Enable this location for verification</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-span-1">
                        <label class="block text-sm font-medium text-gray-700 mb-2">Location Map</label>
                        <div id="location-map" class="w-full h-80 bg-gray-100 rounded-lg"></div>
                        <p class="mt-1 text-sm text-gray-500">Click on the map to set location or drag the marker</p>
                    </div>
                </div>

                <div class="flex justify-end space-x-3">
                    <button type="button" id="cancel-btn" class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                        Cancel
                    </button>
                    <button type="submit" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                        ${editMode ? 'Update' : 'Add'} Location
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Locations List -->
    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
        <div class="px-4 py-5 sm:px-6 bg-gray-50">
            <h3 class="text-lg leading-6 font-medium text-gray-900">Allowed Locations</h3>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">
                List of locations where employees can check in
            </p>
        </div>
        <div class="border-t border-gray-200">
            <c:choose>
                <c:when test="${empty locations}">
                    <div class="px-4 py-5 sm:p-6 text-center">
                        <p class="text-gray-500">No locations have been added yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Coordinates</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Radius</th>
                                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="location" items="${locations}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm font-medium text-gray-900">${location.name}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">${location.latitude}, ${location.longitude}</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900">${location.radius} meters</div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <c:choose>
                                                <c:when test="${location.active}">
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                                        Active
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                                        Inactive
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                            <a href="${pageContext.request.contextPath}/${userRole}/locations?id=${location.id}" class="text-primary-600 hover:text-primary-900 mr-3">Edit</a>
                                            <a href="javascript:void(0);" onclick="confirmDelete(${location.id}, '${location.name}')" class="text-red-600 hover:text-red-900">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Delete Form (Hidden) -->
    <form id="deleteForm" action="${pageContext.request.contextPath}/${userRole}/locations" method="post" class="hidden">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" id="deleteLocationId" name="locationId" value="">
    </form>
</c:set>

<c:set var="additionalScripts">
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const addLocationBtn = document.getElementById('add-location-btn');
        const cancelBtn = document.getElementById('cancel-btn');
        const locationForm = document.getElementById('location-form');

        if (addLocationBtn) {
            addLocationBtn.addEventListener('click', function() {
                locationForm.classList.remove('hidden');
                // Scroll to form
                locationForm.scrollIntoView({ behavior: 'smooth' });
            });
        }

        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                // If in edit mode, redirect to locations page
                if (${editMode}) {
                    window.location.href = '${pageContext.request.contextPath}/${userRole}/locations';
                } else {
                    // Otherwise just hide the form
                    locationForm.classList.add('hidden');
                }
            });
        }
    });
</script>
</c:set>

<jsp:include page="/WEB-INF/components/layout.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
    <jsp:param name="userRole" value="${userRole}" />
    <jsp:param name="mainContent" value="${mainContent}" />
    <jsp:param name="additionalHead" value="${additionalHead}" />
    <jsp:param name="additionalScripts" value="${additionalScripts}" />
</jsp:include>
