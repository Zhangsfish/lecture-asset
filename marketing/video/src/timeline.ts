import type { gsap as GSAP } from "gsap";

declare global {
  interface Window {
    gsap: typeof GSAP;
    __timelines: Record<string, ReturnType<typeof GSAP.timeline>>;
    __m00Ready?: { fonts: boolean; images: boolean; audio: boolean; externalResources: string[] };
  }
}

const gsap = window.gsap;
async function prepare() {
  await document.fonts.load('700 76px "M00 CJK"', '讲座照片与 AI ZIP');
  await document.fonts.load('400 50px "M00 Latin"', 'Lecture Asset README.md AI ZIP');
  await document.fonts.ready;
  await Promise.all(Array.from(document.images).map(image => image.decode()));
  const audio = document.querySelector<HTMLAudioElement>('#m00-ping')!;
  if (audio.readyState < 1) {
    await new Promise<void>((resolve, reject) => {
      audio.addEventListener('loadedmetadata', () => resolve(), { once: true });
      audio.addEventListener('error', () => reject(new Error('Missing local WAV')), { once: true });
    });
  }
  const tl = gsap.timeline({ paused: true, defaults: { force3D: false } });
  tl.fromTo('#zip-card', { y: 32, opacity: 0 }, { y: 0, opacity: 1, duration: 0.35, ease: 'power2.out' }, 0);
  tl.fromTo('#readme-card', { y: 72, opacity: 0 }, { y: 0, opacity: 1, duration: 0.45, ease: 'power2.out' }, 0.8);
  // 0.2s hold: no tween mutates any visual between 1.25 and 1.45.
  tl.fromTo('#zip-card', { x: 0 }, { x: -24, duration: 0.3, ease: 'power2.inOut', immediateRender: false }, 1.45);
  window.__m00Ready = {
    fonts: document.fonts.check('700 76px "M00 CJK"', '讲座照片与 AI ZIP') &&
      document.fonts.check('400 50px "M00 Latin"', 'Lecture Asset README.md AI ZIP'),
    images: Array.from(document.images).every(i => i.complete && i.naturalWidth > 0),
    audio: audio.readyState >= 1,
    externalResources: performance.getEntriesByType('resource')
      .map(r => r.name).filter(name => /^https?:/.test(name) && new URL(name).origin !== location.origin)
  };
  if (!window.__m00Ready.fonts || !window.__m00Ready.images || !window.__m00Ready.audio ||
      window.__m00Ready.externalResources.length !== 0) {
    throw new Error('M00 local font/media readiness or same-origin resource contract failed');
  }
  // Register only when assets and the complete timeline are ready.
  window.__timelines['m00-smoke'] = tl;
}
void prepare();
