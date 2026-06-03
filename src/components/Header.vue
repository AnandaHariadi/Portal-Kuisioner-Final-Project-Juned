<template>
  <header class="glass-card header-container">
    <div class="logo-wrapper">
      <img src="/logo.png" alt="JUNED Logo" class="logo" />
    </div>
    <div class="title-section">
      <h1>JUNED</h1>
      <p class="subtitle">Jaringan Voting Digital Transparan</p>
      <p class="desc">Bantu kami meningkatkan kualitas demokrasi digital melalui kuisioner ini.</p>
    </div>
    
    <!-- CSS Animation of a ballot going into a box -->
    <div class="animation-container">
      <div class="ballot-box">
        <div class="box-top"></div>
        <div class="box-body"></div>
      </div>
      <div class="ballot">
        <div class="ballot-check">✓</div>
      </div>
    </div>
  </header>
</template>

<style scoped>
.header-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  position: relative;
  overflow: hidden;
}

.logo {
  width: 120px;
  height: auto;
  margin-bottom: 1rem;
}

h1 {
  font-size: 2.5rem;
  color: var(--secondary-green);
  margin-bottom: 0.2rem;
  font-weight: 700;
  letter-spacing: 1px;
}

.subtitle {
  font-size: 1.2rem;
  font-weight: 600;
  color: var(--primary-green);
  margin-bottom: 0.5rem;
}

.desc {
  color: var(--text-light);
  font-size: 0.95rem;
}

/* Voting Animation Styles */
.animation-container {
  position: absolute;
  right: 20px;
  bottom: 20px;
  width: 80px;
  height: 100px;
  opacity: 0.2; /* Subtle background effect */
}

.ballot-box {
  position: absolute;
  bottom: 0;
  width: 60px;
  height: 60px;
  background: var(--secondary-green);
  border-radius: 4px;
}

.box-top {
  position: absolute;
  top: 0;
  left: 5px;
  width: 50px;
  height: 10px;
  background: #02503a;
  border-radius: 2px 2px 0 0;
}

.box-top::after {
  content: '';
  position: absolute;
  top: 4px;
  left: 15px;
  width: 20px;
  height: 3px;
  background: #000;
  border-radius: 2px;
}

.ballot {
  position: absolute;
  bottom: 60px;
  left: 15px;
  width: 30px;
  height: 40px;
  background: white;
  border: 1px solid #ccc;
  border-radius: 2px;
  display: flex;
  justify-content: center;
  align-items: center;
  animation: dropBallot 3s infinite ease-in;
  z-index: -1;
}

.ballot-check {
  color: var(--primary-green);
  font-weight: bold;
}

@keyframes dropBallot {
  0% { transform: translateY(-30px); opacity: 0; }
  20% { transform: translateY(0); opacity: 1; }
  40% { transform: translateY(40px); opacity: 1; }
  60% { transform: translateY(40px); opacity: 0; }
  100% { transform: translateY(40px); opacity: 0; }
}

@media (max-width: 600px) {
  .animation-container {
    display: none; /* Hide on small screens for cleaner UI */
  }
}
</style>
