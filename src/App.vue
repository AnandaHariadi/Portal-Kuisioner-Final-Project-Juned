<template>
  <!-- CURTAIN OPENING ANIMATION -->
  <div v-if="showCurtain" class="curtain-overlay">
    <div class="curtain-left" :class="{ 'curtain-open': curtainOpening }"></div>
    <div class="curtain-right" :class="{ 'curtain-open': curtainOpening }"></div>
    <div class="curtain-logo" :class="{ 'curtain-logo-fade': curtainOpening }">
      <img src="/logo.png" alt="JUNED" class="curtain-logo-img" />
      <div class="curtain-loading">
        <div class="curtain-loading-bar"></div>
      </div>
    </div>
  </div>

  <!-- ELEGANT PARTICLE BACKGROUND -->
  <canvas ref="particleCanvas" class="particle-bg"></canvas>

  <!-- Ambient Glow Orbs -->
  <div class="ambient-glow">
    <div class="glow-orb glow-1"></div>
    <div class="glow-orb glow-2"></div>
    <div class="glow-orb glow-3"></div>
    <div class="glow-orb glow-4"></div>
  </div>

  <transition name="fade" mode="out-in">
    <!-- SPLASH SCREEN -->
    <SplashScreen v-if="appState === 'splash'" @start="startApp" />
    
    <!-- BIODATA -->
    <div v-else-if="appState === 'biodata'" class="landscape-card">
      <div class="logo-header">
        <img src="/logo.png" alt="JUNED" class="logo-small" />
        <h2 class="display-font">Formulir Registrasi Pemilih</h2>
      </div>
      <BiodataForm v-model="formData.biodata" />
      <div class="action-buttons center">
        <button class="btn-primary" @click="goToCBT">Lanjut ke Kuisioner</button>
      </div>
    </div>

    <!-- CBT QUESTIONNAIRE -->
    <div v-else-if="appState === 'cbt'" class="cbt-container">
      <div class="cbt-header glass-card">
        <div class="cbt-header-left">
          <img src="/logo.png" alt="JUNED" class="logo-small" />
          <div class="user-info">
            <strong>{{ formData.biodata.nama || 'Peserta' }}</strong>
            <span class="badge">Sistem Voting Digital</span>
          </div>
        </div>
        <div class="cbt-header-right">
          <div class="progress-info">Progres: {{ progressPercentage }}%</div>
        </div>
      </div>
      
      <div class="progress-container">
        <div class="progress-bar" :style="{ width: progressPercentage + '%' }"></div>
      </div>

      <div class="cbt-layout">
        <Questionnaire v-model="formData.answers" :currentIndex="currentQuestionIndex" class="centered-questionnaire" />
      </div>

      <div class="cbt-footer glass-card">
        <button class="btn-secondary" @click="prevQuestion" :disabled="currentQuestionIndex === 0">
          ⬅ Sebelumnya
        </button>
        
        <button v-if="currentQuestionIndex < 15" class="btn-primary" @click="nextQuestion">
          Selanjutnya ➡
        </button>
        <button v-else class="btn-primary submit-btn" @click="submitForm" :disabled="isSubmitting">
          {{ isSubmitting ? 'Mengirim Data...' : 'Selesai & Kirim' }}
        </button>
      </div>
    </div>

    <!-- SUCCESS MESSAGE -->
    <div v-else-if="appState === 'success'" class="success-wrapper">
      <!-- Animated Background Elements -->
      <div class="animated-bg">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        <div class="blob blob-3"></div>
      </div>

      <div class="confetti-container">
        <div v-for="n in 20" :key="n" class="confetti" :style="confettiStyle(n)"></div>
      </div>

      <!-- Top Bar -->
      <div class="success-topbar">
        <div class="topbar-left">
          <img src="/logo.png" alt="JUNED Logo" class="topbar-logo" />
        </div>
      </div>

      <!-- Main Content Area -->
      <div class="success-main">
        
        <!-- Left Content (Text) -->
        <div class="success-left">
          <h1 class="success-title">Terima Kasih!</h1>
          <p class="success-subtitle">
            Suara dan tanggapan Anda sangat berarti untuk transparansi demokrasi kita bersama JUNED.
          </p>
          <button class="btn-primary" style="margin-top: 1rem; font-size: 1.1rem; padding: 1rem 2rem; border-radius: 50px;" @click="goHome">
            Kembali ke Beranda
          </button>
        </div>

        <!-- Right Content (Illustration & Live Data) -->
        <div class="success-right">
          
          <div class="mascot-wrapper">
            <img src="/maskot-2.png" alt="Maskot Terima Kasih" class="success-mascot mascot-blink-effect" />
          </div>
        </div>

      </div>

      <!-- Live Voters List Mockup -->
      <div class="live-voters-card glass-card">
        <div class="voters-header">
          <span class="live-indicator"></span>
          <h3 class="voters-title">Live Jaringan Blok JUNED</h3>
        </div>
        <div class="voters-list">
          <div v-if="liveVoters.length === 0" style="text-align: center; color: #64748b; padding: 1rem 0; font-size: 0.9rem;">
            Belum ada partisipan.
          </div>
          <div v-else class="voter-item" v-for="(voter, index) in liveVoters.slice(0, 3)" :key="index">
            <div class="voter-avatar">{{ voter.name.charAt(0).toUpperCase() }}</div>
            <div class="voter-info">
              <span class="voter-name">{{ voter.name }}</span>
              <span class="voter-time">{{ voter.time }}</span>
            </div>
          </div>
        </div>
        <button class="btn-secondary btn-small" @click="showResults = true">
          Lihat Semua Data Transparansi
        </button>
      </div>
    </div>
  </transition>
  
  <FooterMusic :playMusic="true" />

  <!-- RESULTS MODAL -->
  <ResultsModal :isOpen="showResults" :voters="liveVoters" @close="showResults = false" />
</template>

<script setup>
import { ref, reactive, computed, onMounted, onBeforeUnmount } from 'vue'
import SplashScreen from './components/SplashScreen.vue'
import BiodataForm from './components/BiodataForm.vue'
import Questionnaire from './components/Questionnaire.vue'
import FooterMusic from './components/FooterMusic.vue'
import ResultsModal from './components/ResultsModal.vue'

// Curtain animation
const showCurtain = ref(true)
const curtainOpening = ref(false)

// Results modal
const showResults = ref(false)

// Live voters data
const liveVoters = ref([])

onMounted(() => {
  // Muat data dari localStorage saat aplikasi dimulai
  const storedVoters = localStorage.getItem('juned_liveVoters')
  if (storedVoters) {
    liveVoters.value = JSON.parse(storedVoters)
  }
})

// Particle canvas
const particleCanvas = ref(null)
let animFrameId = null

// splash -> biodata -> cbt -> success
const appState = ref('splash')
const currentQuestionIndex = ref(0)
const isSubmitting = ref(false)

const formData = reactive({
  biodata: {
    nama: '',
    umur: '',
    jenisKelamin: '',
    domisili: '',
    pendidikan: ''
  },
  answers: {
    q1: '', q2: '', q3: '', q4: '', q5: '',
    q6: '', q7: '', q8: '', q9: '', q10: '',
    q11: '', q12: '', q13: '', q14: '', q15: '',
    pesan: ''
  }
})

// Confetti styles for success screen
const confettiStyle = (n) => {
  const colors = ['#10b981', '#047857', '#6ee7b7', '#fde047', '#93c5fd', '#f9a8d4', '#c4b5fd', '#fca5a5', '#86efac', '#a78bfa']
  const left = Math.random() * 100
  const delay = Math.random() * 3
  const duration = 3 + Math.random() * 4
  const size = 6 + Math.random() * 10
  const rotation = Math.random() * 360
  return {
    left: `${left}%`,
    animationDelay: `${delay}s`,
    animationDuration: `${duration}s`,
    width: `${size}px`,
    height: `${size}px`,
    backgroundColor: colors[n % colors.length],
    transform: `rotate(${rotation}deg)`,
    borderRadius: Math.random() > 0.5 ? '50%' : '2px'
  }
}

// --- Particle Background ---
const initParticles = () => {
  const canvas = particleCanvas.value
  if (!canvas) return
  const ctx = canvas.getContext('2d')
  
  const resize = () => {
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
  }
  resize()
  window.addEventListener('resize', resize)

  const particleCount = 80
  const particles = []
  const connectionDistance = 150

  for (let i = 0; i < particleCount; i++) {
    particles.push({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      vx: (Math.random() - 0.5) * 0.6,
      vy: (Math.random() - 0.5) * 0.6,
      radius: 1.5 + Math.random() * 2,
      opacity: 0.3 + Math.random() * 0.5,
      pulseSpeed: 0.01 + Math.random() * 0.02,
      pulseOffset: Math.random() * Math.PI * 2
    })
  }

  let time = 0
  const animate = () => {
    time += 0.016
    ctx.clearRect(0, 0, canvas.width, canvas.height)

    // Update & draw particles
    particles.forEach((p, i) => {
      p.x += p.vx
      p.y += p.vy

      // Wrap around edges
      if (p.x < 0) p.x = canvas.width
      if (p.x > canvas.width) p.x = 0
      if (p.y < 0) p.y = canvas.height
      if (p.y > canvas.height) p.y = 0

      // Pulsing opacity
      const pulse = Math.sin(time * p.pulseSpeed * 60 + p.pulseOffset) * 0.2 + 0.8

      // Draw particle
      ctx.beginPath()
      ctx.arc(p.x, p.y, p.radius * pulse, 0, Math.PI * 2)
      ctx.fillStyle = `rgba(16, 185, 129, ${p.opacity * pulse})`
      ctx.fill()

      // Draw connections
      for (let j = i + 1; j < particles.length; j++) {
        const other = particles[j]
        const dx = p.x - other.x
        const dy = p.y - other.y
        const dist = Math.sqrt(dx * dx + dy * dy)

        if (dist < connectionDistance) {
          const lineOpacity = (1 - dist / connectionDistance) * 0.15
          ctx.beginPath()
          ctx.moveTo(p.x, p.y)
          ctx.lineTo(other.x, other.y)
          ctx.strokeStyle = `rgba(16, 185, 129, ${lineOpacity})`
          ctx.lineWidth = 0.5
          ctx.stroke()
        }
      }
    })

    animFrameId = requestAnimationFrame(animate)
  }

  animate()
}

onMounted(() => {
  // Start curtain animation sequence
  setTimeout(() => {
    curtainOpening.value = true
  }, 1800)
  
  setTimeout(() => {
    showCurtain.value = false
  }, 3200)

  // Init particle background
  initParticles()
})

onBeforeUnmount(() => {
  if (animFrameId) cancelAnimationFrame(animFrameId)
})

const startApp = () => {
  appState.value = 'biodata'
}

const goToCBT = () => {
  const b = formData.biodata
  if(!b.umur || !b.jenisKelamin || !b.domisili || !b.pendidikan) {
    alert('Mohon lengkapi biodata yang bertanda * (Nama opsional).')
    return
  }
  appState.value = 'cbt'
}

const prevQuestion = () => {
  if (currentQuestionIndex.value > 0) {
    currentQuestionIndex.value--
  }
}

const nextQuestion = () => {
  if (currentQuestionIndex.value < 15) {
    currentQuestionIndex.value++
  }
}

const goToQuestion = (index) => {
  currentQuestionIndex.value = index
}

const progressPercentage = computed(() => {
  let answeredCount = 0
  for(let i=1; i<=15; i++) {
    if(formData.answers['q'+i]) answeredCount++
  }
  if(formData.answers.pesan) answeredCount++
  
  return Math.round((answeredCount / 16) * 100)
})

const submitForm = async () => {
  const unAnswered = Object.keys(formData.answers).find(key => key !== 'pesan' && formData.answers[key] === '')
  if (unAnswered) {
    alert('Masih ada soal pilihan ganda yang belum dijawab. Silakan periksa panel navigasi.')
    return
  }

  isSubmitting.value = true

  try {
    const API_URL = 'https://script.google.com/macros/s/AKfycbwYOUR_SCRIPT_ID/exec' 
    
    const payload = {
      timestamp: new Date().toISOString(),
      ...formData.biodata,
      ...formData.answers
    }

    // Simulasi pengiriman data
    await new Promise(resolve => setTimeout(resolve, 1500))

    let nameParts = (formData.biodata.nama || 'Anonim').trim().split(' ')
    let censoredName = 'Anonim'
    if (nameParts.length > 0 && nameParts[0]) {
       if (nameParts.length > 1) {
          censoredName = nameParts[0] + ' ' + nameParts[1].charAt(0).toUpperCase() + '***'
       } else {
          censoredName = nameParts[0] + '***'
       }
    }
    liveVoters.value.unshift({ name: censoredName, time: 'Baru saja' })
    
    // Simpan liveVoters ke localStorage
    localStorage.setItem('juned_liveVoters', JSON.stringify(liveVoters.value))

    // Simpan full data (rekapan Excel) ke localStorage
    let allSubmissions = []
    const storedSubmissions = localStorage.getItem('juned_fullSubmissions')
    if (storedSubmissions) {
      allSubmissions = JSON.parse(storedSubmissions)
    }
    allSubmissions.push(payload)
    localStorage.setItem('juned_fullSubmissions', JSON.stringify(allSubmissions))

    appState.value = 'success'
    window.scrollTo({ top: 0, behavior: 'smooth' })
  } catch (error) {
    alert('Terjadi kesalahan saat mengirim data.')
    console.error(error)
  } finally {
    isSubmitting.value = false
  }
}

const goHome = () => {
  appState.value = 'splash'
  currentQuestionIndex.value = 0
  
  // Reset form
  formData.biodata = {
    nama: '',
    umur: '',
    jenisKelamin: '',
    domisili: '',
    pendidikan: ''
  }
  formData.answers = {
    q1: '', q2: '', q3: '', q4: '', q5: '',
    q6: '', q7: '', q8: '', q9: '', q10: '',
    q11: '', q12: '', q13: '', q14: '', q15: '',
    pesan: ''
  }
}
</script>

<style scoped>
/* ===== CURTAIN ANIMATION ===== */
.curtain-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 9999;
  pointer-events: none;
}

.curtain-left,
.curtain-right {
  position: absolute;
  top: 0;
  width: 50%;
  height: 100%;
  background: linear-gradient(180deg, #013829 0%, #047857 40%, #10b981 100%);
  transition: transform 1.4s cubic-bezier(0.77, 0, 0.175, 1);
  z-index: 10000;
}

.curtain-left {
  left: 0;
  background: linear-gradient(135deg, #013829 0%, #047857 100%);
  box-shadow: 5px 0 30px rgba(0, 0, 0, 0.5);
}

.curtain-right {
  right: 0;
  background: linear-gradient(225deg, #013829 0%, #047857 100%);
  box-shadow: -5px 0 30px rgba(0, 0, 0, 0.5);
}

.curtain-left::after,
.curtain-right::after {
  content: '';
  position: absolute;
  top: 0;
  width: 100%;
  height: 100%;
  background: repeating-linear-gradient(
    0deg,
    transparent,
    transparent 40px,
    rgba(255, 255, 255, 0.03) 40px,
    rgba(255, 255, 255, 0.03) 41px
  );
}

.curtain-left::before,
.curtain-right::before {
  content: '';
  position: absolute;
  top: 0;
  width: 30px;
  height: 100%;
  z-index: 1;
}

.curtain-left::before {
  right: 0;
  background: linear-gradient(to left, rgba(0,0,0,0.15), transparent);
}

.curtain-right::before {
  left: 0;
  background: linear-gradient(to right, rgba(0,0,0,0.15), transparent);
}

.curtain-left.curtain-open {
  transform: translateX(-105%);
}

.curtain-right.curtain-open {
  transform: translateX(105%);
}

.curtain-logo {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 10001;
  text-align: center;
  transition: opacity 0.6s ease;
}

.curtain-logo-fade {
  opacity: 0;
}

.curtain-logo-img {
  width: 200px;
  height: auto;
  filter: drop-shadow(0 10px 30px rgba(0,0,0,0.4));
  animation: curtainLogoPulse 1.5s ease-in-out infinite;
}

@keyframes curtainLogoPulse {
  0%, 100% { transform: scale(1); filter: drop-shadow(0 10px 30px rgba(0,0,0,0.4)); }
  50% { transform: scale(1.08); filter: drop-shadow(0 15px 40px rgba(16, 185, 129, 0.5)); }
}

.curtain-loading {
  width: 180px;
  height: 4px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  margin: 20px auto 0;
  overflow: hidden;
}

.curtain-loading-bar {
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, #6ee7b7, #10b981, #047857);
  border-radius: 4px;
  animation: curtainLoadProgress 1.8s ease-in-out;
}

@keyframes curtainLoadProgress {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(0); }
}

/* ===== PARTICLE BACKGROUND ===== */
.particle-bg {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: -1;
}

/* ===== AMBIENT GLOW ORBS ===== */
.ambient-glow {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: -1;
  overflow: hidden;
}

.glow-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.4;
}

.glow-1 {
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(16, 185, 129, 0.3) 0%, transparent 70%);
  top: -10%;
  right: -5%;
  animation: orbDrift1 20s infinite ease-in-out;
}

.glow-2 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, rgba(6, 95, 70, 0.25) 0%, transparent 70%);
  bottom: -15%;
  left: -5%;
  animation: orbDrift2 25s infinite ease-in-out;
}

.glow-3 {
  width: 350px;
  height: 350px;
  background: radial-gradient(circle, rgba(110, 231, 183, 0.2) 0%, transparent 70%);
  top: 40%;
  left: 30%;
  animation: orbDrift3 18s infinite ease-in-out;
}

.glow-4 {
  width: 300px;
  height: 300px;
  background: radial-gradient(circle, rgba(16, 185, 129, 0.15) 0%, transparent 70%);
  top: 20%;
  right: 20%;
  animation: orbDrift4 22s infinite ease-in-out;
}

@keyframes orbDrift1 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  25% { transform: translate(-60px, 40px) scale(1.1); }
  50% { transform: translate(-30px, 80px) scale(0.95); }
  75% { transform: translate(40px, 20px) scale(1.05); }
}

@keyframes orbDrift2 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  25% { transform: translate(50px, -30px) scale(1.1); }
  50% { transform: translate(80px, -60px) scale(0.9); }
  75% { transform: translate(20px, -40px) scale(1.05); }
}

@keyframes orbDrift3 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(-40px, -50px) scale(1.15); }
  66% { transform: translate(30px, 40px) scale(0.9); }
}

@keyframes orbDrift4 {
  0%, 100% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(-50px, 60px) scale(1.1); }
}

/* ===== GENERAL LAYOUT ===== */
.container-center {
  max-width: 800px;
  margin: 0 auto;
}

.logo-small {
  width: 120px; /* Diperbesar dari 80px */
  height: auto;
  margin-right: 1.5rem;
  filter: drop-shadow(0 4px 8px rgba(0,0,0,0.1));
}

.logo-header {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 2rem;
  color: var(--secondary-green);
}

.action-buttons {
  margin-top: 2rem;
}
.action-buttons.center {
  text-align: center;
}

/* CBT Layout Specific */
.cbt-container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
}

.centered-questionnaire {
  width: 100%;
}

.cbt-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  margin-bottom: 1rem;
}

.cbt-header-left {
  display: flex;
  align-items: center;
}

.user-info {
  display: flex;
  flex-direction: column;
}

.badge {
  background: var(--primary-green);
  color: white;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 0.8rem;
  margin-top: 5px;
}

.cbt-footer {
  display: flex;
  justify-content: space-between;
  padding: 1.5rem 2rem;
  margin-top: 2rem;
  position: sticky;
  bottom: 1rem;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  z-index: 50;
  box-shadow: 0 -10px 30px rgba(0,0,0,0.05);
  border-radius: 16px;
  border: 1px solid var(--glass-border);
}

.submit-btn {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}
.submit-btn:hover {
  box-shadow: 0 8px 20px rgba(245, 158, 11, 0.4);
}

.display-font {
  font-family: 'Outfit', sans-serif;
  font-weight: 900;
  color: #ffffff;
  text-align: center;
  text-shadow: 0 4px 15px rgba(0,0,0,0.3);
  letter-spacing: 1px;
}

.subtitle-font {
  font-family: 'Playfair Display', serif;
  font-style: italic;
  font-size: 1.5rem;
  color: var(--primary-green);
}

/* ===== SUCCESS SCREEN (Matched with Splash Screen Layout) ===== */
.success-wrapper {
  display: flex;
  flex-direction: column;
  width: 100%;
  min-height: 100vh;
  position: absolute;
  top: 0;
  left: 0;
  overflow: hidden;
  background: #f8fafc;
  z-index: 100;
}

.success-topbar {
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

.success-main {
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

.success-left {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  text-align: left;
  padding-right: 2rem;
}

.success-title {
  font-family: 'Outfit', sans-serif;
  font-weight: 900;
  font-size: 4.5rem;
  line-height: 1.1;
  color: #1f2937;
  margin-bottom: 1.5rem;
  letter-spacing: -1px;
}

.success-subtitle {
  font-family: 'Inter', sans-serif;
  font-weight: 400;
  font-size: 1.25rem;
  line-height: 1.6;
  color: #4b5563;
  margin-bottom: 3rem;
}

.success-right {
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: flex-end;
  height: 100%;
  position: relative;
}

.mascot-wrapper {
  position: relative;
  display: inline-block;
}

.success-mascot {
  width: 100%;
  max-width: 600px; 
  height: auto;
  filter: drop-shadow(0 30px 60px rgba(0,0,0,0.25));
  animation: mascotCelebrate 2.5s infinite ease-in-out;
  transform-origin: bottom center;
}

/* Simulated Blink Effect for Static PNG */
.mascot-blink-effect {
  animation: mascotCelebrate 2.5s infinite ease-in-out, mascotBlink 4s infinite;
}

@keyframes mascotBlink {
  0%, 94%, 98%, 100% { transform: scaleY(1); }
  96% { transform: scaleY(0.97); }
}

@keyframes mascotCelebrate {
  0%, 100% { transform: translateY(0) rotate(0deg) scale(1); }
  20% { transform: translateY(-25px) rotate(-3deg) scale(1.05); }
  40% { transform: translateY(-5px) rotate(2deg) scale(1); }
  60% { transform: translateY(-20px) rotate(-2deg) scale(1.03); }
  80% { transform: translateY(-3px) rotate(1deg) scale(1); }
}

/* ===== LIVE VOTERS CARD ===== */
.live-voters-card {
  position: absolute;
  top: 2rem;
  right: 2rem;
  width: 320px;
  padding: 1.5rem;
  background: rgba(255, 255, 255, 0.95);
  z-index: 20;
  text-align: left;
  border-radius: 20px;
  box-shadow: 0 15px 35px rgba(0,0,0,0.1);
  animation: floatCard 4s infinite ease-in-out;
}

@keyframes floatCard {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.voters-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 1.5rem;
}

.live-indicator {
  width: 12px;
  height: 12px;
  background-color: #ef4444;
  border-radius: 50%;
  animation: pulseLive 1.5s infinite;
}

@keyframes pulseLive {
  0% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7); }
  70% { box-shadow: 0 0 0 10px rgba(239, 68, 68, 0); }
  100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
}

.voters-title {
  font-family: 'Outfit', sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  color: var(--text-dark);
  margin: 0;
}

.voters-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 1.5rem;
}

.voter-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px;
  background: #f8fafc;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
}

.voter-avatar {
  width: 35px;
  height: 35px;
  background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
  color: white;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-weight: 700;
  font-size: 1rem;
}

.voter-info {
  display: flex;
  flex-direction: column;
}

.voter-name {
  font-weight: 600;
  font-size: 0.9rem;
  color: var(--text-dark);
}

.voter-time {
  font-size: 0.75rem;
  color: #64748b;
}

.btn-small {
  width: 100%;
  padding: 0.7rem;
  font-size: 0.9rem;
  border-radius: 12px;
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
  background: rgba(16, 185, 129, 0.2);
  top: -10%; left: -10%;
}

.blob-2 {
  width: 500px; height: 500px;
  background: rgba(4, 120, 87, 0.15);
  bottom: -20%; right: -10%;
  animation-duration: 25s;
  animation-delay: -5s;
}

.blob-3 {
  width: 300px; height: 300px;
  background: rgba(110, 231, 183, 0.2);
  top: 40%; left: 60%;
  animation-duration: 18s;
  animation-delay: -10s;
}

@keyframes blobDrift {
  0% { transform: translate(0, 0) scale(1); }
  50% { transform: translate(50px, 50px) scale(1.1); }
  100% { transform: translate(-30px, 80px) scale(0.9); }
}

/* ===== CONFETTI (Improved) ===== */
.confetti-container {
  position: absolute;
  top: 0; left: 0; width: 100%; height: 100%;
  pointer-events: none;
  z-index: 1;
}

.confetti {
  position: absolute;
  top: -20px;
  animation: confettiFall 4s infinite linear;
}

@keyframes confettiFall {
  0% { transform: translateY(-20px) rotate(0deg) scale(1); opacity: 1; }
  25% { transform: translateY(25vh) rotate(120deg) translateX(15px) scale(0.95); opacity: 1; }
  50% { transform: translateY(50vh) rotate(240deg) translateX(-10px) scale(0.9); opacity: 0.8; }
  75% { transform: translateY(75vh) rotate(340deg) translateX(20px) scale(0.85); opacity: 0.5; }
  100% { transform: translateY(100vh) rotate(400deg) translateX(-5px) scale(0.8); opacity: 0; }
}

@media (max-width: 1100px) {
  .success-main {
    flex-direction: column;
    text-align: center;
    padding: 2rem;
    justify-content: flex-start;
  }

  .success-left {
    align-items: center;
    text-align: center;
    padding-right: 0;
    margin-bottom: 2rem;
  }

  .success-right {
    justify-content: center;
  }

  .success-mascot {
    max-width: 400px;
  }

  .live-voters-card {
    position: relative;
    top: auto;
    right: auto;
    width: 100%;
    max-width: 350px;
    margin-bottom: 2rem;
    animation: none;
  }
}

@media (max-width: 768px) {
  .success-topbar {
    padding: 1rem 1.5rem;
  }
  
  .success-title {
    font-size: 2.8rem;
  }

  .success-subtitle {
    font-size: 1.1rem;
  }
}

@media (max-width: 600px) {
  .cbt-header {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
  
  .cbt-header-left {
    flex-direction: column;
    gap: 0.5rem;
  }

  .logo-small {
    margin-right: 0;
    margin-bottom: 0.5rem;
  }

  .cbt-footer {
    flex-direction: column-reverse;
    gap: 1rem;
    padding: 1rem;
  }
}
</style>
