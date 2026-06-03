<template>
  <div v-if="playMusic" class="music-player" aria-hidden="true">
    <!-- Local MP3 background sound (starts from 0:23) -->
    <audio
      ref="audioEl"
      :src="mp3Src"
      autoplay
      loop
      preload="auto"
    ></audio>
  </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue'

defineProps({
  playMusic: Boolean
})

const audioEl = ref(null)

// Use file from public so it can be referenced as /TULUS-Jatuh-Suka-(CeeNaija.com).mp3
const mp3Src = computed(() => '/TULUS-Jatuh-Suka-(CeeNaija.com).mp3')

const START_AT_SECONDS = 23 // 0:23

const tryStartAt = async () => {
  const el = audioEl.value
  if (!el) return

  // Some browsers may block autoplay; we still try.
  // Start from 0:23 as requested.
  el.currentTime = START_AT_SECONDS

  try {
    await el.play()
  } catch (e) {
    // ignore autoplay restrictions
  }
}

onMounted(() => {
  const el = audioEl.value
  if (!el) return

  // If already ready, start immediately.
  if (el.readyState >= 1) tryStartAt()
})

watch(
  () => (audioEl.value ? audioEl.value.readyState : 0),
  () => {
    const el = audioEl.value
    if (!el) return
    if (el.readyState >= 1) tryStartAt()
  }
)
</script>

