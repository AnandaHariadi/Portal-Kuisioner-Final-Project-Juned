<template>
  <div class="glass-card cbt-main">
    <div v-if="currentIndex < 15">
      <h2 class="section-title">Soal {{ currentIndex + 1 }}</h2>
      <div class="question-block">
        <p class="question-text"><strong>{{ currentQuestion.title }}:</strong> {{ currentQuestion.text }}</p>
        
        <div class="options-grid">
          <label v-for="opt in currentQuestion.options" :key="opt" class="option-label">
            <input type="radio" :name="'q' + (currentIndex + 1)" :value="opt" v-model="model['q' + (currentIndex + 1)]" />
            <span class="option-text">{{ opt }}</span>
          </label>
        </div>
      </div>
    </div>
    
    <div v-else>
      <h2 class="section-title">Pertanyaan Terbuka</h2>
      <div class="form-group">
        <label class="form-label">Pesan & Saran</label>
        <p class="sub-label">Tuliskan pesan atau saran Anda untuk pengembangan JUNED ke depan.</p>
        <textarea class="form-textarea" v-model="model.pesan" placeholder="Masukkan pesan dan saran Anda di sini..."></textarea>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  currentIndex: Number
})
const model = defineModel()

const questions = [
  {
    title: 'Pengalaman pertama',
    text: 'Bagaimana kesan Anda saat pertama kali menggunakan JUNED untuk memilih?',
    options: ['Sangat terkesan & mudah', 'Cukup terkesan', 'Biasa saja', 'Kurang terkesan']
  },
  {
    title: 'Tujuan sistem',
    text: 'Apakah JUNED menurut Anda berhasil mencapai tujuannya yaitu voting yang aman dan transparan?',
    options: ['Sangat berhasil', 'Cukup berhasil', 'Belum sepenuhnya berhasil', 'Belum berhasil sama sekali']
  },
  {
    title: 'Kemudahan proses',
    text: 'Apakah proses memilih terasa sederhana dan tidak membingungkan?',
    options: ['Sangat mudah & jelas', 'Cukup mudah dipahami', 'Agak membingungkan', 'Sangat membingungkan']
  },
  {
    title: 'Kecepatan layanan',
    text: 'Apakah sistem merespon dengan cepat saat Anda melakukan voting?',
    options: ['Sangat cepat & responsif', 'Cukup cepat', 'Agak lambat', 'Sangat lambat']
  },
  {
    title: 'Keamanan suara',
    text: 'Apakah Anda merasa suara Anda benar-benar aman dan tidak bisa diubah pihak lain?',
    options: ['Sangat aman & terjamin', 'Cukup aman', 'Kurang yakin aman', 'Tidak merasa aman']
  },
  {
    title: 'Privasi pilihan',
    text: 'Apakah pilihan Anda tetap rahasia dan tidak bisa dilihat admin atau pihak lain?',
    options: ['Sangat terjaga kerahasiaannya', 'Cukup terjaga', 'Kurang yakin terjaga', 'Tidak terjaga sama sekali']
  },
  {
    title: 'Transparansi hasil',
    text: 'Apakah hasil voting terlihat transparan tanpa membuka identitas pemilih?',
    options: ['Sangat transparan', 'Cukup transparan', 'Kurang transparan', 'Tidak transparan']
  },
  {
    title: 'Kepercayaan publik',
    text: 'Apakah sistem ini bisa meningkatkan kepercayaan masyarakat terhadap hasil pemilu?',
    options: ['Sangat bisa meningkatkan', 'Cukup bisa meningkatkan', 'Kurang bisa meningkatkan', 'Tidak bisa meningkatkan']
  },
  {
    title: 'Studi kasus lokal',
    text: 'Jika JUNED diterapkan di daerah Anda, apakah menurut Anda bisa berjalan lancar?',
    options: ['Sangat bisa berjalan lancar', 'Cukup bisa berjalan', 'Perlu banyak penyesuaian', 'Sulit diterapkan']
  },
  {
    title: 'Kejelasan informasi',
    text: 'Apakah penjelasan di aplikasi mudah dipahami tanpa istilah teknis rumit?',
    options: ['Sangat mudah dipahami', 'Cukup mudah dipahami', 'Agak sulit dipahami', 'Sangat sulit dipahami']
  },
  {
    title: 'Kenyamanan penggunaan',
    text: 'Apakah Anda merasa nyaman menggunakan aplikasi ini dibanding cara manual?',
    options: ['Jauh lebih nyaman', 'Sedikit lebih nyaman', 'Sama saja', 'Lebih nyaman cara manual']
  },
  {
    title: 'Perlindungan kecurangan',
    text: 'Apakah sistem ini bisa mencegah orang memilih dua kali?',
    options: ['Sangat bisa mencegah', 'Cukup bisa mencegah', 'Kurang bisa mencegah', 'Tidak bisa mencegah']
  },
  {
    title: 'Peran KPU',
    text: 'Apakah menurut Anda KPU bisa menggunakan sistem ini dengan jujur dan adil?',
    options: ['Sangat bisa', 'Cukup bisa', 'Kurang yakin bisa', 'Tidak bisa']
  },
  {
    title: 'Relevansi digital',
    text: 'Apakah voting digital lebih relevan dengan kondisi zaman sekarang?',
    options: ['Sangat relevan', 'Cukup relevan', 'Kurang relevan', 'Tidak relevan']
  },
  {
    title: 'Kepuasan keseluruhan',
    text: 'Secara keseluruhan, apakah Anda puas dengan pengalaman menggunakan JUNED?',
    options: ['Sangat puas', 'Cukup puas', 'Kurang puas', 'Tidak puas']
  }
]

const currentQuestion = computed(() => {
  if(props.currentIndex < 15) return questions[props.currentIndex]
  return {}
})
</script>

<style scoped>
.section-title {
  color: var(--secondary-green);
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
  border-bottom: 2px solid var(--light-green);
  padding-bottom: 0.5rem;
}

.question-block {
  margin-bottom: 1.5rem;
}

.question-text {
  font-size: 1.3rem;
  font-weight: 500;
  margin-bottom: 2rem;
  line-height: 1.6;
}

.sub-label {
  color: var(--text-light);
  font-size: 1rem;
  margin-bottom: 1rem;
}

.options-grid {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.option-label {
  display: flex;
  align-items: center;
  padding: 1.2rem;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-weight: 500;
  font-size: 1.1rem;
}

.option-label input {
  margin-right: 1rem;
  transform: scale(1.2);
}

.option-label:has(input:checked) {
  background: var(--light-green);
  border-color: var(--primary-green);
}
</style>
