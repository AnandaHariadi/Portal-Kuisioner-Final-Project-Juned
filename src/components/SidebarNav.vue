<template>
  <div class="glass-card cbt-sidebar">
    <h3 class="sidebar-title">Navigasi Soal</h3>
    <div class="nav-grid">
      <button 
        v-for="n in totalQuestions" 
        :key="n"
        class="nav-btn"
        :class="{
          'active': currentQuestionIndex === n - 1,
          'answered': isAnswered(n - 1)
        }"
        @click="$emit('select-question', n - 1)"
      >
        {{ n }}
      </button>
    </div>
    
    <div class="legend">
      <div class="legend-item"><span class="box answered-box"></span> Sudah Dijawab</div>
      <div class="legend-item"><span class="box active-box"></span> Sedang Dikerjakan</div>
      <div class="legend-item"><span class="box empty-box"></span> Belum Dijawab</div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  totalQuestions: Number,
  currentQuestionIndex: Number,
  answers: Object
})
defineEmits(['select-question'])

const isAnswered = (index) => {
  if(index < 15) {
    return !!props.answers['q' + (index + 1)]
  } else {
    return !!props.answers.pesan
  }
}
</script>

<style scoped>
.sidebar-title {
  color: var(--secondary-green);
  margin-bottom: 1rem;
  font-size: 1.2rem;
  text-align: center;
  border-bottom: 1px solid var(--glass-border);
  padding-bottom: 0.5rem;
}

.nav-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 8px;
  margin-bottom: 1.5rem;
}

.nav-btn {
  background: white;
  border: 1px solid #ccc;
  border-radius: 4px;
  padding: 10px 0;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s ease;
  color: var(--text-dark);
}

.nav-btn:hover {
  background: var(--light-green);
}

.nav-btn.answered {
  background: var(--primary-green);
  color: white;
  border-color: var(--secondary-green);
}

.nav-btn.active {
  box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.4);
  transform: scale(1.1);
  z-index: 1;
}

.legend {
  font-size: 0.85rem;
  color: var(--text-light);
}

.legend-item {
  display: flex;
  align-items: center;
  margin-bottom: 5px;
}

.box {
  width: 14px;
  height: 14px;
  margin-right: 8px;
  border-radius: 2px;
  display: inline-block;
}

.answered-box { background: var(--primary-green); }
.active-box { background: white; border: 2px solid var(--primary-green); }
.empty-box { background: white; border: 1px solid #ccc; }
</style>
