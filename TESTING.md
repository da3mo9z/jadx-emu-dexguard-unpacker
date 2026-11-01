# Checking a deploy

A result only means something if the install was clean and you know which jar ran, so use the scripts instead of copying jars by hand.

## After a change

1. If the engine changed, run `scripts/deploy-engine.sh <path to jadx-emu>`. It runs the engine's tests, publishes it to `~/.m2` and installs the plugin jar. Skip this when only the extension changed.
2. Run `scripts/baseline.sh` for a known-good state. It clears build output, the installed jar, recovered output and jadx's cache, resets the properties to `telemetry=true` and `nativeBackend=none`, then deploys.
3. Run `scripts/smoke.sh`. It takes about ten seconds and needs no APK. It runs jadx on `fixtures/smoke.dex`, a tiny app whose loader hands a task to an executor and AES-decrypts `fixtures/payload.dex`. It passes only if the recovered dex is byte-identical to the payload.
4. Run a real target. For FaceTec, open the APK in jadx-gui (File > Open, never a saved project), run **DexGuard: auto-sweep**, close jadx, then check the log:

```
EXPECT=4 scripts/results.sh ~/run.log
```

FaceTec should give 4 dex and 421 classDefs. The smoke test doesn't replace this.

`results.sh` prints the dex on disk, the class counts, the telemetry (including any limit hits), per-candidate timings and the startup line, then PASS or FAIL.

## If the count is short

| what you see | what it means | what to do |
|---|---|---|
| `HIT the maxMillis=... limit`, or limit hits in the telemetry | The wall-clock cap cut a loader off | Set `clockAdvanceMs` to 1000 first. A time-gated loop is the usual cause. |
| No limit hit, and the startup line or `native bridge ACTIVE` looks wrong | The wrong jar or backend is live | Run `scripts/baseline.sh`. |
| No limit hit, clean startup, still short | A real difference in the emulation | Keep the log and `telemetry.json` and look at the candidate in jadx. |

To see the cut-off on purpose, run once with `scripts/set-prop.sh maxMillis 120000`, then again after `scripts/set-prop.sh maxMillis --unset`.
