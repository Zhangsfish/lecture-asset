# R3 real narration / copy timing

Original director speech input is preserved in R3_COPY_AUDIO.json. Screen copy is unchanged and has no sentence punctuation. Separate SRT keeps real spoken punctuation; it is not burned into the film.

Two N01 lines were minimally condensed after actual generated original audio exceeded the 2.75-second window even at the permitted maximum 1.08x correction. No spoken word was cut from the final waveform, no internal pause was removed, and no short cue was stretched.

| Locale | Original N01 input | Actual complete N01 input |
|---|---|---|
| EN | Lecture photos everywhere. Too scattered for AI. | Lecture photos. Too scattered for AI. |
| zh-Hans | 照片塞满相册，交给 AI，又太散。 | 交给 AI，又太散。 |

Congestion is already visible in the unchanged opening photo scene. The AI-scattering meaning remains spoken. All other planned cue words are unchanged. EN N05 was regenerated at a more conversational pace, and ZH N03 regenerated for clearer opening word; all14 final ASR matches normalize to1.0. Independent ASR agreement does not establish subjective pronunciation or listening PASS.

| Locale / cue | Actual seconds | Start → end | Post atempo |
|---|---:|---|---:|
| en / N01 | 2.744 | 0.150 → 2.894 | 1.0709 |
| en / N02 | 4.034 | 3.150 → 7.184 | 1.0037 |
| en / N03 | 1.422 | 7.650 → 9.072 | 1.0000 |
| en / N04 | 1.897 | 10.650 → 12.547 | 1.0000 |
| en / N05 | 2.301 | 13.150 → 15.451 | 1.0000 |
| en / N06 | 2.302 | 17.700 → 20.002 | 1.0000 |
| en / N07 | 3.096 | 20.650 → 23.746 | 1.0000 |
| zh-Hans / N01 | 1.891 | 0.150 → 2.041 | 1.0000 |
| zh-Hans / N02 | 4.045 | 3.150 → 7.195 | 1.0012 |
| zh-Hans / N03 | 2.553 | 7.650 → 10.203 | 1.0608 |
| zh-Hans / N04 | 1.651 | 10.650 → 12.301 | 1.0000 |
| zh-Hans / N05 | 3.793 | 13.150 → 16.943 | 1.0237 |
| zh-Hans / N06 | 2.133 | 17.700 → 19.833 | 1.0000 |
| zh-Hans / N07 | 3.870 | 20.650 → 24.520 | 1.0000 |

See VOICE_ASR.json for actual word timing, SYNC_PROOF.json for saved-before-cleanup/provider synchronization, and AUDIO_QA.json for actual audio signal checks. Subjective listening: NOT_RUN; director review remains pending.
