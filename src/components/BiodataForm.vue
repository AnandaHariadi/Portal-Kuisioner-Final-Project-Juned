<template>
  <div class="glass-card landscape-card">
    <h2 class="section-title">1. Biodata Awal</h2>
    
    <div class="landscape-grid">
      <div class="form-group">
        <label class="form-label">Nama</label>
        <input type="text" class="form-input" v-model="model.nama" placeholder="Masukkan nama Anda" />
      </div>

      <div class="form-group">
        <label class="form-label">Umur <span class="required">*</span></label>
        <input type="number" class="form-input" v-model="model.umur" placeholder="Misal: 25" min="17" />
      </div>

      <div class="form-group">
        <label class="form-label">Jenis Kelamin <span class="required">*</span></label>
        <select class="form-select" v-model="model.jenisKelamin">
          <option value="" disabled>Pilih Jenis Kelamin</option>
          <option value="Laki-laki">Laki-laki</option>
          <option value="Perempuan">Perempuan</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Domisili <span class="required">*</span></label>
        <input type="text" class="form-input" v-model="model.domisili" placeholder="Kota/Kabupaten" />
      </div>

      <div class="form-group">
        <label class="form-label">Latar Belakang Pendidikan <span class="required">*</span></label>
        <select class="form-select" v-model="model.pendidikan">
          <option value="" disabled>Pilih Pendidikan Terakhir</option>
          <option value="SD/SMP">SD / SMP</option>
          <option value="SMA/SMK">SMA / SMK</option>
          <option value="Diploma">Diploma (D1-D4)</option>
          <option value="Sarjana">Sarjana (S1/D4)</option>
          <option value="Magister/Doktor">Magister / Doktor (S2/S3)</option>
        </select>
      </div>
    </div>
  </div>
</template>

<script setup>
const model = defineModel()
</script>

<style scoped>
.section-title {
  color: var(--secondary-green);
  margin-bottom: 2rem;
  font-size: 1.8rem;
  border-bottom: 2px solid var(--light-green);
  padding-bottom: 0.5rem;
}

.required {
  color: #ef4444;
}
</style>
