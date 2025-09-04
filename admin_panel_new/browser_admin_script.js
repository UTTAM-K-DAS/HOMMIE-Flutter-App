// COPY AND PASTE THIS IN BROWSER CONSOLE (F12 → Console)
// This will make your current user an admin

// First, make sure you're signed in to Firebase Auth, then run this:

import { getAuth } from 'firebase/auth';
import { getFirestore, doc, setDoc, serverTimestamp } from 'firebase/firestore';

const auth = getAuth();
const db = getFirestore();

const createAdminUser = async () => {
  const user = auth.currentUser;
  if (!user) {
    console.error('No user signed in');
    return;
  }

  try {
    await setDoc(doc(db, 'users', user.uid), {
      uid: user.uid,
      email: user.email,
      name: user.displayName || 'HOMMIE Admin',
      role: 'admin',
      isAdmin: true,
      isActive: true,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
      permissions: [
        'read_all',
        'write_all',
        'delete_all',
        'manage_users',
        'manage_providers',
        'manage_services',
        'manage_bookings',
        'view_analytics',
        'system_config',
      ],
      adminLevel: 'super_admin',
    });

    console.log('✅ Admin user created successfully!');
    console.log('🔄 Refresh the page to see changes');
  } catch (error) {
    console.error('❌ Error creating admin user:', error);
  }
};

// Run the function
createAdminUser();
