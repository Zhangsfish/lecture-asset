import { mkdirSync, writeFileSync, copyFileSync, readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { createHash } from 'node:crypto';

// All artwork below is authored locally as deterministic vector geometry.
// Portraits are invented abstract silhouettes, not depictions of real people.
mkdirSync('assets/personal', { recursive: true });
const svg = (body, sky = '#B5D5DF') => `<svg xmlns="http://www.w3.org/2000/svg" width="640" height="640" viewBox="0 0 640 640"><defs><linearGradient id="sky" x2="0" y2="1"><stop stop-color="${sky}"/><stop offset="1" stop-color="#FAE6C8"/></linearGradient></defs><rect width="640" height="640" fill="url(#sky)"/>${body}</svg>\n`;
const person = (x,y,scale,shirt) => `<g transform="translate(${x} ${y}) scale(${scale})"><path d="M-115 230Q-110 105 0 110Q110 105 115 230Z" fill="${shirt}"/><ellipse cy="30" rx="66" ry="87" fill="#D6A17D"/><path d="M-65 20Q-75-65 0-65Q78-60 65 28L50-14Q0 14-55-9Z" fill="#3D3534"/><path d="M-25 74Q0 88 25 74" stroke="#A05C53" stroke-width="7" fill="none"/></g>`;
const art = {
 P01: svg('<circle cx="485" cy="130" r="60" fill="#FFF1C3"/><path d="M0 390L165 130L335 380L455 215L640 415V640H0Z" fill="#708BA0"/><path d="M100 235L165 130L237 239L171 214Z" fill="#F7FBFC"/><path d="M0 495L192 337L335 489L518 343L640 490V640H0Z" fill="#375E65"/><path d="M0 574Q170 489 327 557T640 528V640H0Z" fill="#6B9278"/>'),
 P02: svg('<circle cx="336" cy="281" r="84" fill="#FFD28D"/><rect y="338" width="640" height="302" fill="#597D91"/><path d="M0 391Q160 362 320 391T640 391M0 461Q160 432 320 461T640 461" fill="none" stroke="#B7BAC2" stroke-width="11"/><path d="M0 573Q260 475 640 537V640H0Z" fill="#B79577"/>','#D4979B'),
 P03: svg('<circle cx="493" cy="126" r="43" fill="#FFF1C3"/><path d="M0 355H67V211H159V310H219V142H313V273H384V185H484V314H553V228H640V640H0Z" fill="#69839A"/><path d="M0 432H108V352H223V448H337V322H448V415H560V348H640V640H0Z" fill="#3D566C"/>'+[80,241,408,578].map(x=>`<path d="M${x} 385v170" stroke="#F6D796" stroke-width="13" stroke-dasharray="19 24"/>`).join('')),
 P04: svg('<rect x="45" y="45" width="550" height="550" rx="65" fill="#C3D5CB"/>'+person(320,268,1.55,'#527C92')),
 P05: svg('<path d="M0 520Q200 422 640 492V640H0Z" fill="#71948A"/>'+person(206,295,1.35,'#8A7283')+person(431,265,1.4,'#5E839B')),
 P06: svg('<rect width="640" height="640" fill="#B9A18B"/><circle cx="320" cy="320" r="235" fill="#ECE9DF"/><circle cx="320" cy="320" r="195" fill="#FFFDF5"/><ellipse cx="280" cy="330" rx="103" ry="82" fill="#D79D6C"/><path d="M335 164Q460 191 459 302Q371 328 335 164Z" fill="#79916B"/><circle cx="393" cy="390" r="45" fill="#B96753"/><circle cx="170" cy="230" r="33" fill="#A9B27B"/>'),
 P07: svg('<rect width="640" height="640" fill="#819693"/><circle cx="320" cy="330" r="226" fill="#E4E5DC"/><circle cx="320" cy="330" r="189" fill="#9C674C"/>'+[0,1,2,3,4].map(i=>`<path d="M${179+i*21} 230Q${428-i*22} 150 437 ${289+i*24}Q${168+i*13} ${463-i*14} 200 ${355+i*12}" fill="none" stroke="#EDCB90" stroke-width="16"/>`).join('')+'<ellipse cx="420" cy="387" rx="43" ry="59" fill="#F1E5BD"/><ellipse cx="420" cy="387" rx="21" ry="31" fill="#DBA054"/><path d="M69 84L493 213M70 105L489 235" stroke="#DCC4A1" stroke-width="16"/>'),
 P08: svg('<rect width="640" height="640" fill="#C2AD97"/><circle cx="236" cy="261" r="143" fill="#EAE6DF"/><path d="M331 203Q441 168 431 259Q417 309 340 296" fill="none" stroke="#FDFBF0" stroke-width="26"/><circle cx="236" cy="261" r="100" fill="#F8F2E3"/><circle cx="236" cy="261" r="81" fill="#89624F"/><path d="M236 213C160 199 195 267 236 296C284 260 305 207 236 213Z" fill="#E7C3A0"/><ellipse cx="421" cy="469" rx="155" ry="80" fill="#ECE6D9"/><path d="M305 473L345 378H481L537 473Z" fill="#D5A17B"/><path d="M345 378H481L510 424H327Z" fill="#E8D6BC"/><circle cx="420" cy="377" r="19" fill="#A85957"/>')
};
for (const [id, source] of Object.entries(art)) writeFileSync(`assets/personal/${id}.svg`, source);
copyFileSync('../../reports/S05/store-screenshots-01/fixtures/lecture-13.jpg', 'assets/lecture-13.jpg');
mkdirSync('assets/fonts', { recursive: true });
for (const name of ['msyh.ttc','msyhbd.ttc','segoeui.ttf']) copyFileSync(resolve(process.env.WINDIR ?? 'C:/Windows', 'Fonts', name), `assets/fonts/${name}`);
// Original 48 kHz stereo PCM ping, 120ms, -15dB maximum amplitude.
const n = 5760, wave = Buffer.alloc(44+n*4);
wave.write('RIFF'); wave.writeUInt32LE(wave.length-8,4); wave.write('WAVEfmt ',8);
wave.writeUInt32LE(16,16); wave.writeUInt16LE(1,20); wave.writeUInt16LE(2,22);
wave.writeUInt32LE(48000,24); wave.writeUInt32LE(192000,28); wave.writeUInt16LE(4,32); wave.writeUInt16LE(16,34);
wave.write('data',36); wave.writeUInt32LE(n*4,40);
for (let i=0;i<n;i++) {
 const envelope = Math.sin(Math.PI*i/(n-1))**2 * Math.exp(-3*i/n);
 const sample = Math.round(5800*envelope*Math.sin(2*Math.PI*880*i/48000));
 wave.writeInt16LE(sample,44+i*4); wave.writeInt16LE(sample,46+i*4);
}
writeFileSync('assets/ping-48k.wav',wave);
const hash = p => createHash('sha256').update(readFileSync(p)).digest('hex');
console.log(JSON.stringify({ original_assets: Object.keys(art).map(id=>({id,sha256:hash(`assets/personal/${id}.svg`)})), audio_sha256:hash('assets/ping-48k.wav') },null,2));
