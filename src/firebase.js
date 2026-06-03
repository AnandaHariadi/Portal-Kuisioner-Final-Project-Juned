import { initializeApp } from "firebase/app";
import { getDatabase, ref, push, set, onValue, get, child } from "firebase/database";

// TODO: Ganti konfigurasi di bawah ini dengan konfigurasi dari Firebase Console Anda
// 1. Buka https://console.firebase.google.com/
// 2. Buat project baru
// 3. Tambahkan aplikasi Web (icon </>)
// 4. Copy konfigurasi firebaseConfig ke bawah ini
// 5. Aktifkan "Realtime Database" di menu kiri, dan set Rules menjadi true untuk read/write sementara waktu:
//    { "rules": { ".read": true, ".write": true } }

const firebaseConfig = {
  apiKey: "API_KEY_ANDA",
  authDomain: "PROJECT_ID.firebaseapp.com",
  databaseURL: "https://PROJECT_ID-default-rtdb.firebaseio.com",
  projectId: "PROJECT_ID",
  storageBucket: "PROJECT_ID.appspot.com",
  messagingSenderId: "SENDER_ID",
  appId: "APP_ID"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Realtime Database and get a reference to the service
export const db = getDatabase(app);
export { ref, push, set, onValue, get, child };
