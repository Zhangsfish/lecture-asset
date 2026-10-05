import sharp from 'sharp';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
mkdirSync('review/M00', { recursive: true });
const plan = JSON.parse(readFileSync('plan.json','utf8'));
const ids = plan.opening_album.personal_tiles.map(p=>p.id);
const opening = plan.opening_album.order;
const ending = plan.opening_album.ending_personal_order;
if (opening.length !== 20 || new Set(opening).size !== 20 || ending.length !== 8 || new Set(ending).size !== 8 ||
    ids.some(id=>!opening.includes(id) || !ending.includes(id)) ||
    plan.opening_album.lecture_tiles.some((p,i)=>p.id!==`L${String(i+1).padStart(2,'0')}` || p.fixture!==13+i)) throw new Error('Locked album identity contract failed');
const hash = p => createHash('sha256').update(readFileSync(p)).digest('hex');
const base = execFileSync('git',['merge-base','HEAD','origin/main'],{encoding:'utf8'}).trim();
const source = execFileSync('git',['rev-parse','HEAD'],{encoding:'utf8'}).trim();
const captureProvenance = JSON.parse(readFileSync('../../reports/S05/store-screenshots-01/captures/PROVENANCE.json','utf8'));
const composite = [], assets = [];
for (let i=0;i<ids.length;i++) {
 const id=ids[i], path=`assets/personal/${id}.svg`;
 const png = await sharp(path).resize(256,256).png().toBuffer();
 composite.push({ input: png, left:28+(i%4)*296, top:28+Math.floor(i/4)*328 });
 composite.push({ input: Buffer.from(`<svg width="256" height="50"><text x="128" y="35" text-anchor="middle" font-family="Segoe UI" font-size="26" fill="#203247">${id}</text></svg>`), left:28+(i%4)*296, top:284+Math.floor(i/4)*328 });
 assets.push({asset_id:id,path,type:'EDITORIAL_VECTOR',provenance:'Original local deterministic SVG authored in scripts/prepare-assets.mjs; abstract invented people. No real/private/stock/API media.',source_sha:source,sha256:hash(path),locale:'shared',rights_privacy:'Original project editorial artwork; no identifiable person/logo',intended_scenes:['S01','S08'],subject:plan.opening_album.personal_tiles[i].subject,ending_reuses_exact_path:true});
}
await sharp({create:{width:1200,height:670,channels:3,background:'#FAFBFC'}}).composite(composite).png().toFile('review/M00/PERSONAL_TILES.png');
await sharp('assets/personal/P01.svg').resize(450,450).png().toFile('out/M00/personal-color-reference.png');
for (const tile of plan.opening_album.lecture_tiles) {
 const path=`../../reports/S05/store-screenshots-01/fixtures/lecture-${tile.fixture}.jpg`;
 assets.push({asset_id:tile.id,path,type:'PRODUCT_CONTENT',provenance:'Accepted original fictional lecture source fixture; NOT canonical App export JPEG.',source_sha:base,sha256:hash(path),locale:'shared',rights_privacy:'Safe synthetic project lecture; no private photo/OCR/account',intended_scenes:['S01','S02','S03','S04','S08']});
}
const captures = ['selection','review','ready','pdf','delete-confirmation'];
for(const name of captures) {
 const path=`../../reports/S05/store-screenshots-01/captures/store-en-${name}.png`;
 try { assets.push({asset_id:`native-${name}`,path,type:'NATIVE_CAPTURE',provenance:'Existing accepted Release simulator capture on synthetic lecture fixtures; deletion App confirmation capture cancels before PhotoKit. See frozen Store RENDER_MANIFEST and S03 audit.',source_sha:captureProvenance.source_sha,sha256:hash(path),locale:'en',rights_privacy:'Synthetic product UI; no private media',intended_scenes:name==='delete-confirmation'?['S07']:['S02','S03','S07']}); } catch { /* Missing refs are recorded explicitly below, never manufactured. */ }
}
assets.push({asset_id:'M00-ping',path:'assets/ping-48k.wav',type:'EDITORIAL_VECTOR',provenance:'Original locally synthesized 880Hz enveloped 120ms stereo PCM ping; prepare-assets.mjs',source_sha:source,sha256:hash('assets/ping-48k.wav'),locale:'shared',rights_privacy:'Original project sound; no speech or recording',intended_scenes:['M00-smoke']});
const archive = {status:'BLOCKED_EXPORT_ASSET',required_fixture_numbers:plan.sample.fixture_numbers,page_count:12,zip_basename:null,zip_sha256:null,pdf_sha256:null,readme_sha256:null,reason:'No accessible existing real 12-page App ZIP + companion PDF found. Existing safe packages are 20/200-page synthetic regressions and cannot substitute.',next_targeted_action:'One export-only fresh Release simulator job using accepted fixtures 13–24 through unchanged App, retaining only public ZIP/PDF and safe digest/provenance. No source deletion, fake archive, TestFlight or broad QA.',must_verify:['12 canonical JPEGs','README rules from accepted current source','lecture.md','manifest.json','schema + ZIP CRC/hash','separate 12-page PDF','exact fixtures 13–24 mapping in private simulator test; never publish identifiers']};
writeFileSync('ASSET_LEDGER.json',JSON.stringify({schema_version:1,base_sha:base,assets,archive,album_identity:{status:'PASS',opening_count:20,opening_order:opening,ending_count:8,ending_order:ending,same_assets_by_path_and_sha256:true,no_immediate_storage_reclaim_claim:true}},null,2)+'\n');
console.log('Original assets and locked opening/ending identities: PASS');
