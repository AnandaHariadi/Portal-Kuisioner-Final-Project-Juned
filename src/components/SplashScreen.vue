<template>
  <div class="splash-wrapper">
    
    <!-- Elegant Animated Background Elements -->
    <div class="animated-bg">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>
      <div class="floating-particles">
        <div class="particle" v-for="i in 15" :key="i" :style="getParticleStyle(i)"></div>
      </div>
    </div>

    <!-- Top Bar -->
    <div class="splash-topbar">
      <div class="topbar-left">
        <img src="/logo.png" alt="JUNED Logo" class="topbar-logo" />
      </div>
    </div>

    <!-- Main Content Area -->
    <div class="splash-main">
      
      <!-- Left Content (Text) -->
      <div class="hero-left">
        <div class="live-data-btn-wrapper-left">
          <button class="btn-live-data" @click="showResults = true">
            <span class="pulse-dot"></span>
            Lihat Siapa Saja Yang Mengisi
          </button>
        </div>
        <h1 class="hero-title">
          Suaramu Penting,<br/>
          Wujudkan Bersama JUNED.
        </h1>
        <p class="hero-subtitle">
          Platform Voting Digital yang aman, transparan,<br class="hide-mobile"/>
          dan terpercaya untuk demokrasi Indonesia.
        </p>
        <div class="hero-buttons">
          <button class="btn-hero-primary" @click="handleStart">
            Mulai Kuisioner
          </button>
          <button class="btn-hero-secondary" @click="showAbout = true">
            <img src="/logo.png" alt="" class="btn-logo-small" />
            Tentang JUNED
          </button>
        </div>
      </div>

      <!-- Right Content (Mascot) -->
      <div class="hero-right">
        <div class="mascot-wrapper">
          <img src="/maskot-1.png" alt="Maskot JUNED Menyapa" class="hero-mascot mascot-blink-effect" />
        </div>
      </div>

    </div>

    <!-- Credits -->
    <div class="credits-bar">
      <strong>Dibuat Oleh :</strong> Kelompok 8 Rekayasa Perangkat Lunak A081 — UPN "Veteran" Jawa Timur
    </div>

    <!-- ABOUT MODAL -->
    <transition name="modal-fade">
      <div v-if="showAbout" class="modal-overlay" @click.self="showAbout = false">
        <div class="modal-content glass-card">
          <button class="modal-close" @click="showAbout = false">×</button>
          
          <img src="/logo.png" alt="JUNED Logo" class="modal-logo" />
          
          <div class="modal-text">
            <p><strong>JUNED</strong> adalah website e-voting generasi baru yang hadir untuk menjawab krisis kepercayaan publik terhadap sistem pemilihan. Di saat masyarakat meragukan transparansi dan integritas proses demokrasi, JUNED menawarkan solusi nyata dengan teknologi kriptografi mutakhir seperti <em>Zero-Knowledge Proofs</em>, <em>Merkle Tree</em>, dan <em>Nullifier</em>. Dengan kombinasi ini, setiap suara tetap anonim, namun tetap dapat diverifikasi secara publik tanpa membuka identitas pemilih.</p>
            
            <p>Website JUNED bukan sekadar platform digital, melainkan fondasi baru demokrasi Indonesia berbasis teknologi. Antarmuka yang elegan dan inklusif memastikan semua kalangan dapat berpartisipasi dengan mudah, sementara arsitektur sistem yang modular dan skalabel memungkinkan integrasi lintas lembaga. Hal ini menjadikan JUNED siap diadopsi mulai dari skala kampus hingga tingkat nasional.</p>
            
            <p>Pendanaan terhadap website JUNED adalah investasi strategis pada kepercayaan publik dan efisiensi pemerintahan. Dukungan finansial akan mempercepat pengembangan fitur, memperluas jangkauan implementasi, dan menjadikan JUNED sebagai benchmark nasional untuk sistem pemilihan digital. Ini bukan hanya proyek teknologi, tetapi gerakan menuju demokrasi yang bersih, efisien, dan beretika.</p>
            
            <p class="highlight-text">Mendanai website JUNED berarti mendukung masa depan demokrasi digital Indonesia yang lebih transparan, inklusif, dan terpercaya.</p>
          </div>

          <div style="display: flex; flex-direction: column; gap: 1rem; width: 100%; align-items: center;">
            <button class="btn-hero-primary modal-action-btn" @click="handleStartFromModal">
              Coba Webnya Sekarang
            </button>
            <button class="btn-hero-secondary modal-action-btn" @click="handleDemoClick" style="justify-content: center;">
              Gunakan Akun Demo
            </button>
          </div>
        </div>
      </div>
    </transition>

    <!-- RESULTS MODAL -->
    <ResultsModal :isOpen="showResults" @close="showResults = false" />

  </div>
</template>

<script setup>
import { ref } from 'vue'
import ResultsModal from './ResultsModal.vue'

const emit = defineEmits(['start'])

const showAbout = ref(false)
const showResults = ref(false)

const handleStart = () => {
  emit('start')
}

const handleStartFromModal = () => {
  window.location.href = 'https://laptdev.nxx.my.id/'
}

const handleDemoClick = () => {
  window.location.href = 'https://juned.nxx.my.id/voter/preapproved-demo'
}

// Generate random styles for particles
const getParticleStyle = (i) => {
  const size = Math.random() * 8 + 4;
  return {
    width: `${size}px`,
    height: `${size}px`,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    animationDuration: `${Math.random() * 10 + 10}s`,
    animationDelay: `${Math.random() * 5}s`
  }
}
</script>

<style scoped>
.splash-wrapper {
  display: flex;
  flex-direction: column;
  width: 100%;
  min-height: 100vh;
  position: relative;
  overflow: hidden;
  background: linear-gradient(180deg, rgba(255,255,255,0.9) 0%, rgba(209,250,229,0.6) 100%), url('/background.jpg') no-repeat center center;
  background-size: cover;
  border-radius: 24px;
  box-shadow: 0 20px 60px rgba(0,0,0,0.08);
}

/* ===== ANIMATED BACKGROUND ===== */
.animated-bg {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
  pointer-events: none;
  z-index: 0;
  overflow: hidden;
}

.blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.6;
  animation: blobDrift 20s infinite alternate ease-in-out;
}

.blob-1 {
  width: 400px; height: 400px;
  background: rgba(16, 185, 129, 0.2); /* Primary green */
  top: -10%; left: -10%;
}

.blob-2 {
  width: 500px; height: 500px;
  background: rgba(4, 120, 87, 0.15); /* Secondary green */
  bottom: -20%; right: -10%;
  animation-duration: 25s;
  animation-delay: -5s;
}

.blob-3 {
  width: 300px; height: 300px;
  background: rgba(110, 231, 183, 0.2); /* Light green */
  top: 40%; left: 60%;
  animation-duration: 18s;
  animation-delay: -10s;
}

@keyframes blobDrift {
  0% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(50px, 50px) scale(1.1); }
  100% { transform: translate(-30px, 80px) scale(0.9); }
}

.floating-particles {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
}

.particle {
  position: absolute;
  background: rgba(16, 185, 129, 0.4);
  border-radius: 50%;
  animation: floatUp linear infinite;
}

@keyframes floatUp {
  0% { transform: translateY(0) scale(1); opacity: 0; }
  10% { opacity: 1; }
  90% { opacity: 1; }
  100% { transform: translateY(-100vh) scale(1.5); opacity: 0; }
}

/* ===== TOP BAR ===== */
.splash-topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 1.5rem 3rem;
  z-index: 10;
}

.topbar-left {
  display: flex;
  align-items: center;
}

.topbar-logo {
  height: 80px; 
  width: auto;
  filter: drop-shadow(0 4px 10px rgba(0,0,0,0.15));
}

/* ===== MAIN CONTENT (SPLIT LAYOUT) ===== */
.splash-main {
  flex: 1;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 3rem;
  z-index: 5;
}

/* Left Side: Text */
.hero-left {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  text-align: left;
  padding-right: 2rem;
}

.hero-title {
  font-family: 'Outfit', sans-serif;
  font-weight: 900;
  font-size: 4.5rem;
  line-height: 1.1;
  color: #1f2937;
  margin-bottom: 1.5rem;
  letter-spacing: -1px;
}

.hero-subtitle {
  font-family: 'Inter', sans-serif;
  font-weight: 500;
  font-size: 1.25rem;
  line-height: 1.6;
  color: #1f2937;
  margin-bottom: 3rem;
  text-shadow: 0 2px 4px rgba(255, 255, 255, 0.8);
}

.hero-buttons {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.btn-hero-primary {
  font-family: 'Inter', sans-serif;
  font-weight: 600;
  font-size: 1.1rem;
  color: white;
  background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
  border: none;
  padding: 1rem 2.5rem;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 8px 25px rgba(16, 185, 129, 0.35);
}

.btn-hero-primary:hover {
  transform: translateY(-4px) scale(1.03);
  box-shadow: 0 14px 35px rgba(16, 185, 129, 0.5);
}

.btn-hero-secondary {
  font-family: 'Inter', sans-serif;
  font-weight: 600;
  font-size: 1.1rem;
  color: #374151;
  background: white;
  border: 2px solid #e5e7eb;
  padding: 0.9rem 2rem;
  border-radius: 50px;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 10px;
}

.btn-hero-secondary:hover {
  border-color: var(--primary-green);
  color: var(--secondary-green);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0,0,0,0.08);
}

.btn-logo-small {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  object-fit: contain;
}

/* Right Side: Mascot & Live Button */
.hero-right {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  align-items: flex-end;
  height: 100%;
  position: relative;
}

.live-data-btn-wrapper-left {
  margin-bottom: 2rem;
  z-index: 20;
}

.btn-live-data {
  display: flex;
  align-items: center;
  gap: 10px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(16, 185, 129, 0.3);
  padding: 0.8rem 1.5rem;
  border-radius: 50px;
  font-family: 'Inter', sans-serif;
  font-weight: 600;
  font-size: 1rem;
  color: #1e293b;
  cursor: pointer;
  box-shadow: 0 10px 25px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
  animation: floatBtn 4s infinite ease-in-out;
}

.btn-live-data:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 30px rgba(16, 185, 129, 0.2);
  border-color: var(--primary-green);
}

.pulse-dot {
  width: 12px;
  height: 12px;
  background-color: #ef4444;
  border-radius: 50%;
  display: inline-block;
  animation: pulseLive 1.5s infinite;
}

@keyframes floatBtn {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-8px); }
}

@keyframes pulseLive {
  0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7); }
  70% { box-shadow: 0 0 0 10px rgba(239, 68, 68, 0); }
  100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
}

.mascot-wrapper {
  position: relative;
  display: inline-block;
}

.hero-mascot {
  width: 100%;
  max-width: 650px; 
  height: auto;
  filter: drop-shadow(0 30px 60px rgba(0,0,0,0.25));
  animation: mascotWaveGreet 3s ease-in-out infinite;
  transform-origin: bottom center;
}

/* Simulated Blink Effect for Static PNG */
.mascot-blink-effect {
  /* Using a rapid scale transformation to simulate a blink/nod */
  animation: mascotWaveGreet 3s ease-in-out infinite, mascotBlink 4s infinite;
}

@keyframes mascotBlink {
  0%, 94%, 98%, 100% { transform: scaleY(1); }
  96% { transform: scaleY(0.97); } /* Quick squish resembling a blink */
}

@keyframes mascotWaveGreet {
  0%, 100% { transform: translateY(0) rotate(0deg); }
  15% { transform: translateY(-8px) rotate(4deg); }
  30% { transform: translateY(-4px) rotate(-3deg); }
  45% { transform: translateY(-10px) rotate(5deg); }
  60% { transform: translateY(-3px) rotate(-2deg); }
  75% { transform: translateY(-6px) rotate(3deg); }
  90% { transform: translateY(-2px) rotate(-1deg); }
}

/* ===== CREDITS BAR ===== */
.credits-bar {
  text-align: center;
  padding: 14px 24px;
  width: 100%;
  font-family: 'Outfit', sans-serif;
  font-size: 0.9rem;
  font-weight: 600;
  color: #4b5563;
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border-top: 1px solid rgba(16, 185, 129, 0.15);
  z-index: 10;
}

/* ===== ABOUT MODAL ===== */
.modal-overlay {
  position: fixed;
  top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(5px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  padding: 2rem;
}

.modal-content {
  background: white;
  width: 100%;
  max-width: 800px;
  max-height: 90vh;
  overflow-y: auto;
  border-radius: 20px;
  padding: 3rem;
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

.modal-close {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  background: none;
  border: none;
  font-size: 2rem;
  line-height: 1;
  color: #9ca3af;
  cursor: pointer;
  transition: color 0.3s;
}

.modal-close:hover {
  color: #ef4444;
}

.modal-logo {
  width: 250px;
  height: auto;
  margin-bottom: 2rem;
  filter: drop-shadow(0 10px 20px rgba(0,0,0,0.1));
}

.modal-text {
  text-align: left;
  font-size: 1.1rem;
  line-height: 1.7;
  color: #374151;
  margin-bottom: 2rem;
}

.modal-text p {
  margin-bottom: 1.2rem;
}

.highlight-text {
  font-weight: 600;
  color: var(--secondary-green);
  text-align: center;
  font-size: 1.2rem;
  margin-top: 1.5rem;
  padding: 1.5rem;
  background: var(--light-green);
  border-radius: 12px;
}

.modal-action-btn {
  width: 100%;
  max-width: 400px;
  padding: 1.2rem;
  font-size: 1.2rem;
}

/* Modal Animations */
.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}
.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}
.modal-fade-enter-active .modal-content {
  animation: modalPopIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}
.modal-fade-leave-active .modal-content {
  animation: modalPopOut 0.3s ease;
}

@keyframes modalPopIn {
  0% { transform: scale(0.8); opacity: 0; }
  100% { transform: scale(1); opacity: 1; }
}
@keyframes modalPopOut {
  0% { transform: scale(1); opacity: 1; }
  100% { transform: scale(0.9); opacity: 0; }
}

/* ===== RESPONSIVE ===== */
@media (max-width: 1100px) {
  .splash-main {
    flex-direction: column;
    text-align: center;
    padding: 2rem;
    justify-content: flex-start;
  }

  .hero-left {
    align-items: center;
    text-align: center;
    padding-right: 0;
    margin-bottom: 2rem;
  }

  .hero-buttons {
    justify-content: center;
  }

  .hero-right {
    justify-content: center;
  }

  .hero-mascot {
    max-width: 400px;
  }
}

@media (max-width: 768px) {
  .splash-topbar {
    padding: 1rem 1.5rem;
  }
  
  .hero-title {
    font-size: 2.5rem;
  }

  .hero-subtitle {
    font-size: 1rem;
    margin-bottom: 2rem;
  }

  .hide-mobile {
    display: none;
  }

  .hero-buttons {
    flex-direction: column;
    align-items: center;
    gap: 1rem;
    width: 100%;
  }

  .btn-hero-primary,
  .btn-hero-secondary {
    width: 100%;
    max-width: 100%;
    justify-content: center;
  }
  
  .modal-content {
    padding: 1.5rem;
  }
  
  .modal-logo {
    width: 150px;
    margin-bottom: 1.5rem;
  }
  
  .modal-text {
    font-size: 1rem;
    line-height: 1.5;
  }
  
  .highlight-text {
    font-size: 1.1rem;
    padding: 1rem;
  }
  
  .live-data-btn-wrapper-left {
    width: 100%;
    display: flex;
    justify-content: center;
    margin-bottom: 1.5rem;
  }
}
</style>
