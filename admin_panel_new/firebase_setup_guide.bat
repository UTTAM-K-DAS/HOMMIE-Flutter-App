@echo off
echo ========================================================================================
echo                          HOMMIE FIREBASE SETUP GUIDE
echo ========================================================================================
echo.
echo Follow these steps to resolve the Firebase permission denied errors:
echo.

echo STEP 1: Deploy Temporary Security Rules
echo ----------------------------------------
echo 1. Go to Firebase Console: https://console.firebase.google.com/
echo 2. Select your project: hommie-ea778
echo 3. Navigate to Firestore Database ^> Rules
echo 4. Replace the current rules with these TEMPORARY rules:
echo.
echo rules_version = '2';
echo service cloud.firestore {
echo   match /databases/{database}/documents {
echo     // TEMPORARY RULES FOR ADMIN SETUP - REPLACE AFTER ADMIN CREATION
echo     match /{document=**} {
echo       allow read, write: if true;
echo     }
echo   }
echo }
echo.
echo 5. Click 'Publish' to deploy the rules
echo.

echo STEP 2: Create Admin Account
echo ----------------------------
echo 1. In your running admin panel, go to the Firebase Setup screen
echo 2. Use these credentials:
echo    Email: admin@hommie.com
echo    Password: admin123456
echo    Name: HOMMIE Admin
echo 3. Click 'Create Admin Account'
echo 4. Then click 'Sign In as Admin'
echo.

echo STEP 3: Create Sample Data
echo --------------------------
echo 1. While signed in as admin, click 'Create Sample Data'
echo 2. This will create categories, services, and sample providers
echo.

echo STEP 4: Deploy Production Security Rules
echo ----------------------------------------
echo 1. Go back to Firebase Console ^> Firestore Database ^> Rules
echo 2. Replace the temporary rules with the PRODUCTION rules
echo    (Copy from firebase_setup_guide.txt for full rules)
echo.

echo STEP 5: Create Required Composite Indexes
echo -----------------------------------------
echo 1. Go to Firebase Console ^> Firestore Database ^> Indexes
echo 2. Create composite indexes as detailed in the guide
echo.

echo STEP 6: Test the Solution
echo ------------------------
echo 1. Refresh your admin panel
echo 2. Navigate to Provider Management - should now work
echo 3. Navigate to User Management - should now work
echo 4. Navigate to Users section - should now work
echo.

echo ADMIN CREDENTIALS:
echo ------------------
echo Email: admin@hommie.com
echo Password: admin123456
echo.

echo ========================================================================================
echo                              SETUP COMPLETE!
echo Your HOMMIE admin panel should now work without Firebase permission errors.
echo ========================================================================================

pause
