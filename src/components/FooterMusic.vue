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
import { computed, onMounted, ref, onUnmounted } from 'vue'

defineProps({
  playMusic: Boolean
})

const audioEl = ref(null)
const hasPlayed = ref(false)

// Use file from public
const mp3Src = computed(() => '/TULUS-Jatuh-Suka-(CeeNaija.com).mp3')

const START_AT_SECONDS = 23 // 0:23

const playAudio = async () => {
  const el = audioEl.value
  if (!el || hasPlayed.value) return

  try {
    // Ensure it starts from 0:23
    if (el.currentTime < START_AT_SECONDS) {
      el.currentTime = START_AT_SECONDS
    }
    
    await el.play()
    hasPlayed.value = true // Mark as played successfully
    
    // Remove listeners to prevent unnecessary calls
    window.removeEventListener('click', playAudio)
    window.removeEventListener('touchstart', playAudio)
    window.removeEventListener('keydown', playAudio)
  } catch (e) {
    // Browser blocked it; wait for the next user interaction
  }
}

onMounted(() => {
  // 1. Try to autoplay immediately (might be blocked)
  playAudio()
  
  // 2. Add event listeners so it plays on the user's FIRST interaction
  window.addEventListener('click', playAudio)
  window.addEventListener('touchstart', playAudio)
  window.addEventListener('keydown', playAudio)
})

onUnmounted(() => {
  window.removeEventListener('click', playAudio)
  window.removeEventListener('touchstart', playAudio)
  window.removeEventListener('keydown', playAudio)
})
</script>

