import { spawnSync } from 'node:child_process';
import { resolve } from 'node:path';
import { existsSync, readFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
// One official HyperFrames CLI capture/render engine. No homemade frame capture.
const env = { ...process.env,
 HYPERFRAMES_NO_UPDATE_CHECK: '1', HYPERFRAMES_SKIP_SKILLS: '1',
 HYPERFRAMES_NO_TELEMETRY: '1', DO_NOT_TRACK: '1',
 HYPERFRAMES_BROWSER_PATH: process.env.HYPERFRAMES_BROWSER_PATH ?? 'C:/Program Files/Google/Chrome/Application/chrome.exe',
 HYPERFRAMES_FFMPEG_PATH: process.env.HYPERFRAMES_FFMPEG_PATH ?? 'E:/video_to_md/readable-transcript/resource/bin/ffmpeg.exe',
 HYPERFRAMES_FFPROBE_PATH: process.env.HYPERFRAMES_FFPROBE_PATH ?? 'E:/video_to_md/readable-transcript/resource/bin/ffprobe.exe'
};
// Refuse silent browser/tool drift once this host is locked.
if (existsSync('TOOLCHAIN_LOCK.json')) {
 const lock = JSON.parse(readFileSync('TOOLCHAIN_LOCK.json','utf8'));
 if (process.version !== lock.node) throw new Error('BLOCKED_ENV: Node differs from TOOLCHAIN_LOCK');
 for (const [kind,path] of [['browser',env.HYPERFRAMES_BROWSER_PATH],['ffmpeg',env.HYPERFRAMES_FFMPEG_PATH],['ffprobe',env.HYPERFRAMES_FFPROBE_PATH]]) {
   const current = createHash('sha256').update(readFileSync(path)).digest('hex');
   if (current !== lock[kind].sha256) throw new Error(`BLOCKED_ENV: ${kind} differs from TOOLCHAIN_LOCK`);
 }
}
const result = spawnSync(process.execPath, [resolve('node_modules/hyperframes/bin/hyperframes.mjs'), ...process.argv.slice(2)], { env, stdio: 'inherit' });
if (result.error) throw result.error;
process.exit(result.status ?? 1);
