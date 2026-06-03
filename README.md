# JUNED - Portal Kuisioner & Voting Digital

**JUNED** (Jaringan Umum Nasional Elektronik Demokrasi) adalah prototipe website *e-voting* dan kuisioner digital generasi baru yang mengutamakan transparansi dan integritas. Aplikasi ini dirancang sebagai solusi atas krisis kepercayaan publik dalam proses demokrasi dengan menghadirkan antarmuka pengguna yang elegan, modern, dan mudah digunakan.

Proyek ini dibangun sebagai **Final Project** oleh:
**Kelompok 8 - Rekayasa Perangkat Lunak A081**  
**UPN "Veteran" Jawa Timur**

---

## Fitur Utama

- **Desain UI/UX Modern & Animasi Elegan**: Mulai dari *Splash Screen* dengan efek partikel, tirai transisi (*curtain reveal*), hingga animasi *floating* yang memberikan kesan premium.
- **Form Biodata & Kuisioner Interaktif**: Validasi formulir interaktif dan sistem multi-langkah (CBT-style) untuk mengisi kuisioner.
- **Sistem Transparansi (Live Voters)**: Fitur yang memungkinkan publik melihat daftar anonim partisipan yang telah berpartisipasi secara *real-time*.
- **Penyimpanan Berbasis Local Storage**: Seluruh data riwayat pengisian dan partisipan disimulasikan menggunakan penyimpanan lokal browser, sehingga data tidak hilang saat *refresh*.
- **Export Data Admin (CSV)**: Sistem khusus admin (dengan password `admin123`) untuk mengunduh rekapitulasi data seluruh partisipan dalam bentuk file Excel/CSV.

---

## Cara Menjalankan Proyek (Setup Lokal)

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi JUNED secara lokal di komputer Anda.

### Prasyarat
Pastikan Anda sudah menginstal **[Node.js](https://nodejs.org/)** di komputer Anda.

### Instalasi & Menjalankan

1. **Clone repositori ini:**
   ```bash
   git clone https://github.com/AnandaHariadi/Portal-Kuisioner-Final-Project-Juned.git
   cd Portal-Kuisioner-Final-Project-Juned
   ```

2. **Instal dependensi (packages):**
   ```bash
   npm install
   ```

3. **Jalankan server pengembangan (development server):**
   ```bash
   npm run dev
   ```

4. **Buka di Browser:**
   Buka URL lokal yang muncul di terminal (biasanya `http://localhost:5173`) di browser Anda.

---

## Panduan Penggunaan Admin

Jika Anda ingin melihat cara kerja fitur unduh data (CSV) sebagai Admin:
1. Isi form kuisioner sebagai *user* setidaknya satu kali hingga halaman akhir (Terima Kasih).
2. Di halaman awal (*Splash Screen*) atau halaman akhir, klik tombol **"Lihat Siapa Saja Yang Mengisi"** atau **"Lihat Semua Data Transparansi"**.
3. Di dalam modal tabel yang muncul, klik tombol **"Download Data (Admin Only)"**.
4. Masukkan password: `admin123` lalu klik **Verifikasi & Download**.
5. File `data_voting_juned.csv` akan otomatis diunduh ke komputer Anda.

---

## Teknologi yang Digunakan

- **Framework Frontend**: [Vue 3](https://vuejs.org/) (Composition API / `<script setup>`)
- **Build Tool**: [Vite](https://vitejs.dev/)
- **Styling**: Vanilla CSS3 (Custom Properties, Keyframes, Flexbox/Grid)
- **State & Storage**: Vue Reactivity System & Browser `localStorage`

---

*Dibuat dengan ❤️ untuk Masa Depan Demokrasi Digital Indonesia.*
