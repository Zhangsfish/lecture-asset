import { build } from 'esbuild';
import { readFileSync, writeFileSync, copyFileSync } from 'node:fs';
await build({ entryPoints: ['src/timeline.ts'], bundle: true, outfile: 'dist/timeline.js', format: 'iife', legalComments: 'inline' });
// Keep the vendor library external: its clock/PRNG utilities are not authored motion.
// Copy byte-for-byte, preserving GSAP's original license header.
copyFileSync('node_modules/gsap/dist/gsap.min.js', 'dist/gsap.min.js');
// Inline the compiled timeline so the official static linter can inspect its registration.
writeFileSync('index.html', readFileSync('src/index.html','utf8').replace('/* M00_BUNDLE */', readFileSync('dist/timeline.js','utf8')));
