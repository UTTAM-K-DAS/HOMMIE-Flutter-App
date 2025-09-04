#!/bin/bash

# HOMMIE Firebase Setup Script
# This script provides comprehensive instructions to resolve all Firebase permission issues

echo "========================================================================================"
echo "                         HOMMIE FIREBASE SETUP GUIDE"
echo "========================================================================================"
echo ""
echo "Follow these steps to resolve the Firebase permission denied errors:"
echo ""

echo "STEP 1: Deploy Temporary Security Rules"
echo "----------------------------------------"
echo "1. Go to Firebase Console: https://console.firebase.google.com/"
echo "2. Select your project: hommie-ea778"
echo "3. Navigate to Firestore Database > Rules"
echo "4. Replace the current rules with these TEMPORARY rules:"
echo ""
echo "rules_version = '2';"
echo "service cloud.firestore {"
echo "  match /databases/{database}/documents {"
echo "    // TEMPORARY RULES FOR ADMIN SETUP - REPLACE AFTER ADMIN CREATION"
echo "    match /{document=**} {"
echo "      allow read, write: if true;"
echo "    }"
echo "  }"
echo "}"
echo ""
echo "5. Click 'Publish' to deploy the rules"
echo ""

echo "STEP 2: Create Admin Account"
echo "----------------------------"
echo "1. In your running admin panel, go to the Firebase Setup screen"
echo "2. Use these credentials:"
echo "   Email: admin@hommie.com"
echo "   Password: admin123456"
echo "   Name: HOMMIE Admin"
echo "3. Click 'Create Admin Account'"
echo "4. Then click 'Sign In as Admin'"
echo ""

echo "STEP 3: Create Sample Data"
echo "--------------------------"
echo "1. While signed in as admin, click 'Create Sample Data'"
echo "2. This will create categories, services, and sample providers"
echo ""

echo "STEP 4: Deploy Production Security Rules"
echo "----------------------------------------"
echo "1. Go back to Firebase Console > Firestore Database > Rules"
echo "2. Replace the temporary rules with these PRODUCTION rules:"
echo ""
cat << 'EOF'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, write: if isAdmin();
      allow read, update: if isAuthenticated() && request.auth.uid == userId;
      allow create: if isAuthenticated();
      // Allow reading provider profiles for booking (main app needs this)
      allow read: if isAuthenticated() && resource.data.get('role', '') == 'provider';
    }
    
    // Providers collection (legacy - mainly for compatibility)
    match /providers/{providerId} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated();
    }
    
    // Services collection  
    match /services/{serviceId} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated(); // Allow all authenticated users to read services
    }
    
    // Service categories collection
    match /service_categories/{categoryId} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated(); // Allow all authenticated users to read categories
    }
    
    // Bookings collection
    match /bookings/{bookingId} {
      allow read, write: if isAdmin();
      allow read, create: if isAuthenticated();
      allow update: if isAuthenticated() && 
                       (request.auth.uid == resource.data.customerId || 
                        request.auth.uid == resource.data.providerId);
    }
    
    // Settings collection
    match /settings/{document} {
      allow read, write: if isAdmin();
      allow read: if isAuthenticated(); // Allow reading app settings
    }
    
    // Analytics collection
    match /analytics/{document} {
      allow read, write: if isAdmin();
    }
    
    // Allow reading public data for unauthenticated users (optional)
    match /public/{document} {
      allow read: if true;
    }
  }
}
EOF
echo ""
echo "3. Click 'Publish' to deploy the production rules"
echo ""

echo "STEP 5: Create Required Composite Indexes"
echo "-----------------------------------------"
echo "1. Go to Firebase Console > Firestore Database > Indexes"
echo "2. Create these composite indexes:"
echo ""
echo "For 'users' collection:"
echo "  - Fields: role (Ascending), isActive (Ascending)"
echo "  - Query scope: Collection"
echo ""
echo "For 'providers' collection:"
echo "  - Fields: category (Ascending), isActive (Ascending)"
echo "  - Query scope: Collection"
echo ""
echo "For 'services' collection:"
echo "  - Fields: category (Ascending), isAvailable (Ascending)"
echo "  - Query scope: Collection"
echo ""
echo "For 'bookings' collection:"
echo "  - Fields: customerId (Ascending), createdAt (Descending)"
echo "  - Fields: providerId (Ascending), createdAt (Descending)"
echo "  - Fields: status (Ascending), createdAt (Descending)"
echo "  - Query scope: Collection"
echo ""

echo "STEP 6: Update Main App Provider Service"
echo "----------------------------------------"
echo "Make sure your main app's provider service queries the 'users' collection"
echo "with role='provider' instead of the separate 'providers' collection."
echo ""

echo "STEP 7: Test the Solution"
echo "------------------------"
echo "1. Refresh your admin panel"
echo "2. Navigate to Provider Management - should now work"
echo "3. Navigate to User Management - should now work"
echo "4. Navigate to Users section - should now work"
echo "5. Test creating new providers and services"
echo ""

echo "TROUBLESHOOTING:"
echo "----------------"
echo "- If you still get permission errors, ensure you're signed in as admin"
echo "- If indexes are missing, wait 5-10 minutes after creating them"
echo "- If rules don't work, double-check the syntax in Firebase Console"
echo "- Clear browser cache if needed"
echo ""

echo "ADMIN CREDENTIALS:"
echo "------------------"
echo "Email: admin@hommie.com"
echo "Password: admin123456"
echo ""

echo "========================================================================================"
echo "                              SETUP COMPLETE!"
echo "Your HOMMIE admin panel should now work without Firebase permission errors."
echo "========================================================================================"
