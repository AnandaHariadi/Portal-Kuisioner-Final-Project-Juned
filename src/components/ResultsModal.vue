<template>
  <transition name="modal-fade">
    <div v-if="isOpen" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content glass-card">
        <button class="modal-close" @click="closeModal">×</button>
        
        <div class="modal-header">
          <div class="header-icon">📊</div>
          <h2>Live Data Transparansi</h2>
          <p>Daftar partisipan yang telah berpartisipasi dalam jaringan JUNED.</p>
        </div>

        <div class="table-container">
          <table class="voters-table">
            <thead>
              <tr>
                <th>No</th>
                <th>Nama (Anonim)</th>
                <th>Waktu Voting</th>
                <th>Status Blok</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="displayVoters.length === 0">
                <td colspan="4" style="text-align: center; color: #64748b;">Belum ada partisipan yang terdaftar.</td>
              </tr>
              <tr v-else v-for="(voter, index) in displayVoters" :key="index">
                <td>{{ index + 1 }}</td>
                <td class="name-text">{{ voter.name }}</td>
                <td>{{ voter.time }}</td>
                <td><span class="status-badge verified">Terverifikasi</span></td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="admin-section">
          <div v-if="!showAdminPrompt" class="admin-actions">
            <button class="btn-download" @click="showAdminPrompt = true">
              ⬇ Download Data (Admin Only)
            </button>
          </div>
          
          <div v-else class="admin-prompt">
            <input 
              type="password" 
              v-model="adminPassword" 
              placeholder="Masukkan password admin..." 
              class="admin-input"
              @keyup.enter="handleDownload"
            />
            <button class="btn-verify" @click="handleDownload">Verifikasi & Download</button>
            <button class="btn-cancel" @click="showAdminPrompt = false">Batal</button>
          </div>
          <p v-if="adminError" class="error-text">Password salah. Akses ditolak.</p>
        </div>
        
      </div>
    </div>
  </transition>
</template>

<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  isOpen: Boolean,
  voters: {
    type: Array,
    default: () => []
  }
})

// When voters prop is empty/not provided, load from localStorage
const localVoters = ref([])

watch(() => props.isOpen, (newVal) => {
  if (newVal && (!props.voters || props.voters.length === 0)) {
    const stored = localStorage.getItem('juned_liveVoters')
    if (stored) {
      localVoters.value = JSON.parse(stored)
    }
  }
})

// Use prop voters if available, otherwise use localStorage voters
const displayVoters = computed(() => {
  if (props.voters && props.voters.length > 0) {
    return props.voters
  }
  return localVoters.value
})

const emit = defineEmits(['close'])

const closeModal = () => {
  emit('close')
  showAdminPrompt.value = false
  adminPassword.value = ''
  adminError.value = false
}

const showAdminPrompt = ref(false)
const adminPassword = ref('')
const adminError = ref(false)

const handleDownload = () => {
  if (adminPassword.value === 'admin123') {
    adminError.value = false
    
    const stored = localStorage.getItem('juned_fullSubmissions')
    let data = []
    if (stored) {
      data = JSON.parse(stored)
    }
    
    if (data.length === 0) {
      alert('Belum ada data partisipan yang bisa didownload.')
      showAdminPrompt.value = false
      adminPassword.value = ''
      return
    }

    alert('Verifikasi berhasil! Mengunduh file data_voting_juned.csv...')
    
    // Build CSV
    const headers = Object.keys(data[0])
    const csvRows = []
    csvRows.push(headers.join(','))
    
    for (const row of data) {
      const values = headers.map(header => {
        const val = row[header] === undefined || row[header] === null ? '' : row[header]
        const escaped = ('' + val).replace(/"/g, '""')
        return `"${escaped}"`
      })
      csvRows.push(values.join(','))
    }
    
    const csvString = csvRows.join('\n')
    const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.style.display = 'none'
    a.href = url
    a.download = 'data_voting_juned.csv'
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    window.URL.revokeObjectURL(url)

    // Reset prompt
    showAdminPrompt.value = false
    adminPassword.value = ''
  } else {
    adminError.value = true
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  padding: 1rem;
}

.modal-content {
  background: white;
  width: 100%;
  max-width: 800px;
  max-height: 90vh;
  border-radius: 20px;
  padding: 2.5rem;
  position: relative;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

.modal-close {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  background: #f1f5f9;
  border: none;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  font-size: 1.5rem;
  line-height: 1;
  color: #64748b;
  cursor: pointer;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-close:hover {
  background: #fee2e2;
  color: #ef4444;
}

.modal-header {
  text-align: center;
  margin-bottom: 2rem;
}

.header-icon {
  font-size: 3rem;
  margin-bottom: 0.5rem;
}

.modal-header h2 {
  font-family: 'Outfit', sans-serif;
  font-weight: 800;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.modal-header p {
  color: #64748b;
  font-size: 1rem;
}

.table-container {
  flex: 1;
  overflow-y: auto;
  border-radius: 12px;
  border: 1px solid #e2e8f0;
  margin-bottom: 2rem;
}

.voters-table {
  width: 100%;
  border-collapse: collapse;
  text-align: left;
}

.voters-table th {
  background: #f8fafc;
  padding: 1rem;
  font-weight: 600;
  color: #475569;
  position: sticky;
  top: 0;
  z-index: 10;
  border-bottom: 2px solid #e2e8f0;
}

.voters-table td {
  padding: 1rem;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
}

.name-text {
  font-weight: 600;
  color: var(--primary-green);
  letter-spacing: 0.5px;
}

.status-badge {
  background: #dcfce7;
  color: #16a34a;
  padding: 0.25rem 0.75rem;
  border-radius: 50px;
  font-size: 0.85rem;
  font-weight: 600;
}

.admin-section {
  background: #f8fafc;
  padding: 1.5rem;
  border-radius: 12px;
  border: 1px dashed #cbd5e1;
  text-align: center;
}

.btn-download {
  background: #1e293b;
  color: white;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  font-family: 'Inter', sans-serif;
}

.btn-download:hover {
  background: #0f172a;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.admin-prompt {
  display: flex;
  gap: 10px;
  justify-content: center;
  align-items: center;
  flex-wrap: wrap;
}

.admin-input {
  padding: 0.8rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 8px;
  font-family: 'Inter', sans-serif;
  width: 250px;
  outline: none;
  transition: border-color 0.3s;
}

.admin-input:focus {
  border-color: var(--primary-green);
}

.btn-verify {
  background: var(--primary-green);
  color: white;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-verify:hover {
  background: var(--secondary-green);
}

.btn-cancel {
  background: white;
  color: #64748b;
  border: 1px solid #cbd5e1;
  padding: 0.8rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
}

.btn-cancel:hover {
  background: #f1f5f9;
}

.error-text {
  color: #ef4444;
  font-size: 0.9rem;
  margin-top: 10px;
  font-weight: 500;
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
</style>
