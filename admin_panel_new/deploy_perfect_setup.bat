@echo off
cls
echo ========================================================================
echo                    HOMMIE FIREBASE PERFECT SETUP
echo ========================================================================
echo.
echo This script will help you deploy the perfect Firestore security rules
echo and set up your admin account to resolve ALL permission issues.
echo.

echo STEP 1: Deploy Perfect Security Rules
echo =====================================
echo.
echo 1. Go to Firebase Console: https://console.firebase.google.com/project/hommie-ea778/firestore/rules
echo.
echo 2. Copy and paste these PERFECT RULES (replacing all existing rules):
echo.
echo ---- COPY FROM HERE ----
type firestore_perfect_rules.rules
echo ---- COPY TO HERE ----
echo.
echo 3. Click "PUBLISH" to deploy the rules
echo.
pause

echo.
echo STEP 2: Create Required Composite Indexes
echo =========================================
echo.
echo Click these direct links to create indexes automatically:
echo.
echo For USERS collection:
echo https://console.firebase.google.com/v1/r/project/hommie-ea778/firestore/indexes?create_composite=Ckpwcm9qZWN0cy9ob21taWUtZWE3NzgvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL3VzZXJzL2luZGV4ZXMvXxAAGAEiCgoEcm9sZRABGAEiDAoIaXNBY3RpdmUQARgBKAA
echo.
echo For BOOKINGS collection:
echo https://console.firebase.google.com/v1/r/project/hommie-ea778/firestore/indexes?create_composite=ClJwcm9qZWN0cy9ob21taWUtZWE3NzgvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL2Jvb2tpbmdzL2luZGV4ZXMvXxAAGAEiDAoIc3RhdHVzEAEYASIOCgpjcmVhdGVkQXQQAhgBKAA
echo.
echo For PROVIDERS collection:
echo https://console.firebase.google.com/v1/r/project/hommie-ea778/firestore/indexes?create_composite=ClJwcm9qZWN0cy9ob21taWUtZWE3NzgvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL3Byb3ZpZGVycy9pbmRleGVzL18QABIAABIAA
echo.
echo For SERVICES collection:
echo https://console.firebase.google.com/v1/r/project/hommie-ea778/firestore/indexes?create_composite=ClFwcm9qZWN0cy9ob21taWUtZWE3NzgvZGF0YWJhc2VzLyhkZWZhdWx0KS9jb2xsZWN0aW9uR3JvdXBzL3NlcnZpY2VzL2luZGV4ZXMvXxAAEgASAAKAA
echo.
pause

echo.
echo STEP 3: Create Admin Account
echo ============================
echo.
echo 1. Open your admin panel: http://localhost:8080
echo 2. Navigate to Firebase Setup screen (or add /firebase-setup to URL)
echo 3. Use these credentials:
echo    Email: admin@hommie.com
echo    Password: admin123456
echo    Name: HOMMIE Admin
echo 4. Click "Create Admin Account"
echo 5. Click "Sign In as Admin"
echo.
pause

echo.
echo STEP 4: Create Sample Data
echo =========================
echo.
echo 1. In the Firebase Setup screen, click "Create Sample Data"
echo 2. This will populate your database with:
echo    - Service categories (cleaning, plumbing, electrical, etc.)
echo    - Sample services
echo    - Sample provider accounts
echo 3. Wait for "Sample data created successfully" message
echo.
pause

echo.
echo STEP 5: Test Your Admin Panel
echo =============================
echo.
echo 1. Navigate to Provider Management - should work without errors
echo 2. Navigate to User Management - should work without errors  
echo 3. Navigate to Bookings - should work without errors
echo 4. Test creating new providers using the + button
echo 5. Test all CRUD operations
echo.
echo If you see any errors, wait 5-10 minutes for indexes to build completely.
echo.

echo ========================================================================
echo                          SETUP COMPLETE!
echo ========================================================================
echo.
echo Your HOMMIE admin panel should now work perfectly with:
echo ✓ Proper security rules deployed
echo ✓ Required composite indexes created  
echo ✓ Admin account configured
echo ✓ Sample data populated
echo ✓ All permission errors resolved
echo.
echo Admin Credentials:
echo Email: admin@hommie.com
echo Password: admin123456
echo.
echo Admin Panel: http://localhost:8080
echo Firebase Console: https://console.firebase.google.com/project/hommie-ea778
echo.
pause
