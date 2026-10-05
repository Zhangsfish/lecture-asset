import { spawnSync } from 'node:child_process';
import { mkdirSync, writeFileSync } from 'node:fs';
mkdirSync('out/M00', { recursive: true });
function run(command, args, log) {
 const result = spawnSync(command, args, { encoding: 'utf8', maxBuffer: 16*1024*1024 });
 writeFileSync(`out/M00/${log}`, (result.stdout ?? '') + (result.stderr ?? ''));
 if (result.status !== 0) throw new Error(`${log}: command failed (${result.status}); inspect out/M00/${log}`);
 console.log(`${log}: PASS`);
 return result.stdout;
}
run(process.execPath,['scripts/hf.mjs','check','--json','--at','0,0.5,1,1.5,1.9833333333333334'],'check.json');
// Official snapshot command preserves the supplied timestamp order and uses
// a single page/session. No reload or new browser between forward/back seeks.
run(process.execPath,['scripts/hf.mjs','snapshot','--at','0,0.5,1,1.5,1.9833333333333334,1.5,0.5,1.9833333333333334,0,1,1.25,1.45','--no-end','--output','out/M00/seek','--describe','false'],'snapshot.log');
run(process.execPath,['scripts/hf.mjs','render','--fps','60','--workers','1','--quality','looks','--output','out/M00/smoke-full.mp4'],'render.log');
const ffmpeg = process.env.HYPERFRAMES_FFMPEG_PATH ?? 'E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe';
const ffprobe = process.env.HYPERFRAMES_FFPROBE_PATH ?? 'E:/video_to_md/readable-transcript/resource/bin/ffprobe.exe';
// Review scaling is FFmpeg post-encode in the same approved pipeline.
run(ffmpeg,['-y','-i','out/M00/smoke-full.mp4','-vf','scale=540:960:flags=lanczos','-c:v','libx264','-crf','16','-pix_fmt','yuv420p','-c:a','copy','-color_primaries','bt709','-color_trc','bt709','-colorspace','bt709','-movflags','+faststart','out/M00/smoke-review.mp4'],'review-encode.log');
run(ffprobe,['-v','error','-count_frames','-show_streams','-show_format','-of','json','out/M00/smoke-review.mp4'],'ffprobe.json');
run(ffmpeg,['-y','-i','out/M00/smoke-review.mp4','-vn','-acodec','pcm_s16le','out/M00/rendered-audio.wav'],'audio-decode.log');
run(ffmpeg,['-y','-i','out/M00/smoke-review.mp4','-vf','blackdetect=d=0.01:pix_th=0.02','-an','-f','null','-'],'blackdetect.log');
