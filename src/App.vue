<script setup>
import { ref, computed } from 'vue'
import keysData from './keys.json'

const searchTerm = ref('')
const ignoredKeys = ['metadata', 'hash', 'gracePeriodDays', 'autoProlongated', 'isAutoProlongated', 'trial', 'aiAllowed']

// 基于 icons.svg 的顺序 (根据用户提供的图片和常见 JetBra 排列)
const iconMapping = {
  "IntelliJ IDEA": 7,
  "PhpStorm": 8,
  "DataGrip": 5,
  "RubyMine": 14,
  "RustRover": 26, 
  "WebStorm": 15,
  "Rider": 11,
  "CLion": 3,
  "PyCharm": 9,
  "GoLand": 6,
}

// 获取图标索引，如果没有匹配到，返回 26 (默认图标)
const getIconIndex = (name) => {
  if (iconMapping[name] !== undefined) return iconMapping[name]
  const key = Object.keys(iconMapping).find(k => name.includes(k))
  return key ? iconMapping[key] : 26
}

const products = computed(() => {
  return Object.entries(keysData).map(([name, versions]) => {
    return {
      name,
      iconIndex: getIconIndex(name),
      versions: Object.entries(versions)
        .filter(([key]) => !ignoredKeys.includes(key))
        .map(([ver, code]) => ({
          version: ver,
          code
        }))
        .sort((a, b) => b.version.localeCompare(a.version, undefined, { numeric: true }))
    }
  }).filter(p => p.name.toLowerCase().includes(searchTerm.value.toLowerCase()))
})

const copyCode = async (code, event) => {
  try {
    await navigator.clipboard.writeText(code)
    const btn = event.currentTarget
    if (btn) {
      btn.classList.add('copied')
      const originalText = btn.innerHTML
      btn.innerHTML = `<span class="btn-text">Copied</span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>`
      
      setTimeout(() => {
        btn.innerHTML = originalText
        btn.classList.remove('copied')
      }, 2000)
    }
  } catch (err) {
    console.error('Failed to copy: ', err)
    alert('Failed to copy code. Please copy manually.')
  }
}
</script>

<template>
  <div class="layout">
    <div class="background-noise"></div>
    
    <div class="disclaimer-container">
      <div class="disclaimer-card">
        <div class="disclaimer-icon">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
            <line x1="12" y1="9" x2="12" y2="13"></line>
            <line x1="12" y1="17" x2="12.01" y2="17"></line>
          </svg>
        </div>
        <div class="disclaimer-text">
          <p>
            <strong>Disclaimer:</strong> Download <a href="/jetbra.zip" class="highlight-link">jetbra.zip (230914)</a> and configure as described in readme.txt. 
            For educational and testing purposes only. Not for commercial use.
          </p>
          <p class="sub-text">This is a personal page, not an official website.</p>
        </div>
      </div>
    </div>



    <main class="content">
      <div v-if="products.length === 0" class="empty-state">
        <div class="empty-icon-wrapper">
          <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
        </div>
        <h3>No products found</h3>
        <p>Try searching for a different keyword</p>
      </div>
      
      <div class="grid">
        <div v-for="product in products" :key="product.name" class="card">
          <div class="card-gradient"></div>
          <div class="card-header">
            <div class="product-identity">
              <div class="icon-frame">
                <div 
                  class="product-icon" 
                  :style="{ backgroundPositionY: `calc(-36px * ${product.iconIndex})` }"
                ></div>
              </div>
              <h2 class="product-name">{{ product.name }}</h2>
            </div>
          </div>
          
          <div class="versions-list">
            <div v-for="v in product.versions" :key="v.version" class="version-row">
              <span class="version-number">
                {{ v.version }}
              </span>
              <button @click="copyCode(v.code, $event)" class="copy-btn">
                <span class="btn-text">Copy Code</span>
                <svg class="copy-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                  <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                </svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </main>

    <footer class="footer">
      <div class="footer-content">
        <p>All keys are collected from the Internet for testing purposes only.</p>
        <div class="footer-badge">NON-COMMERCIAL USE</div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;500;700&family=Inter:wght@400;500;600;700&display=swap');

:root {
  --bg-color: #000000;
  --card-bg: #0a0a0a;
  --border-color: #27272a;
  --text-primary: #e4e4e7;
  --text-secondary: #a1a1aa;
  --accent: #d946ef; /* Fuchsia-500 */
  --accent-glow: rgba(217, 70, 239, 0.15);
  --success: #22c55e;
  --warning: #f59e0b;
}

.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background-color: var(--bg-color);
  color: var(--text-primary);
  font-family: 'Inter', sans-serif;
  position: relative;
  overflow-x: hidden;
}

.background-noise {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0.03;
  pointer-events: none;
  z-index: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
}

/* Disclaimer */
.disclaimer-container {
  padding: 16px 24px;
  position: relative;
  z-index: 10;
  display: flex;
  justify-content: center;
}

.disclaimer-card {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  background: rgba(245, 158, 11, 0.05);
  border: 1px solid rgba(245, 158, 11, 0.2);
  padding: 12px 20px;
  border-radius: 12px;
  max-width: 800px;
  width: 100%;
  backdrop-filter: blur(8px);
}

.disclaimer-icon {
  color: var(--warning);
  padding-top: 2px;
}

.disclaimer-text p {
  margin: 0;
  font-size: 0.9rem;
  line-height: 1.5;
  color: #fbbf24;
}

.disclaimer-text .sub-text {
  font-size: 0.8rem;
  opacity: 0.8;
  margin-top: 4px;
}

.highlight-link {
  color: #fff;
  text-decoration: underline;
  text-decoration-color: rgba(255,255,255,0.3);
  text-underline-offset: 4px;
  font-weight: 600;
  transition: all 0.2s;
}

.highlight-link:hover {
  color: var(--warning);
  text-decoration-color: var(--warning);
}



/* Content */
.content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 24px;
  width: 100%;
  position: relative;
  z-index: 1;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;
}

.card {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  overflow: hidden;
  position: relative;
  transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
  display: flex;
  flex-direction: column;
}

.card:hover {
  transform: translateY(-2px);
  border-color: #3f3f46;
  box-shadow: 0 10px 30px -10px rgba(0,0,0,0.5);
}

.card-gradient {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
  opacity: 0;
  transition: opacity 0.3s;
}

.card:hover .card-gradient {
  opacity: 1;
}

.card-header {
  padding: 20px;
  display: flex;
  align-items: center;
  border-bottom: 1px solid #18181b;
  background: linear-gradient(to bottom, rgba(255,255,255,0.02), transparent);
}

.product-identity {
  display: flex;
  align-items: center;
  gap: 16px;
}

.icon-frame {
  width: 48px;
  height: 48px;
  background: #18181b;
  border: 1px solid #27272a;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.product-icon {
  width: 36px;
  height: 36px;
  background-image: url('/icons.svg');
  background-size: 36px 1080px;
  background-repeat: no-repeat;
}

.product-name {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 600;
  color: #f4f4f5;
  letter-spacing: -0.01em;
}

.versions-list {
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.version-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 12px;
  border-radius: 8px;
  transition: background 0.2s;
}

.version-row:hover {
  background: #18181b;
}

.version-number {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.85rem;
  color: #a1a1aa;
}



.copy-btn {
  background: transparent;
  border: 1px solid #27272a;
  color: #d4d4d8;
  padding: 6px 12px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.75rem;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.2s;
}

.copy-btn:hover {
  background: #27272a;
  border-color: #3f3f46;
  color: #fff;
}

.copy-btn:active {
  transform: scale(0.98);
}

.copy-btn.copied {
  background: rgba(34, 197, 94, 0.1);
  border-color: rgba(34, 197, 94, 0.2);
  color: #4ade80;
}

.copy-icon {
  opacity: 0.6;
}

.copy-btn:hover .copy-icon {
  opacity: 1;
}

/* Footer */
.footer {
  margin-top: auto;
  border-top: 1px solid var(--border-color);
  padding: 32px 0;
  text-align: center;
  background: #050505;
}

.footer-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.footer p {
  color: #52525b;
  font-size: 0.85rem;
  margin: 0;
}

.footer-badge {
  font-size: 0.7rem;
  font-weight: 700;
  color: #3f3f46;
  border: 1px solid #27272a;
  padding: 2px 8px;
  border-radius: 99px;
  letter-spacing: 0.05em;
}

.empty-state {
  text-align: center;
  padding: 80px 0;
  color: #52525b;
}

.empty-icon-wrapper {
  width: 80px;
  height: 80px;
  background: #18181b;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 24px;
  border: 1px solid #27272a;
}

.empty-state h3 {
  color: #e4e4e7;
  margin: 0 0 8px;
  font-weight: 600;
}

@media (max-width: 640px) {

  .disclaimer-card {
    flex-direction: column;
  }
}
</style>
