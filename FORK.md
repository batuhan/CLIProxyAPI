# Fork notes

`patched` is upstream [router-for-me/CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI)
plus the patches below. `main` mirrors upstream and carries no patches.

## Patches

| Area | Change |
|---|---|
| Codex Ultrafast | Advertise the `ultrafast` service tier on gpt-6.1-sol and gpt-6-astra in the Codex client catalog, and route Ultrafast requests only to credentials that can use it (Pro $500 OAuth plans or API keys). |
| Codex Pro preference | Standard, auto, and priority requests prefer ordinary Pro accounts. A pinned tier is enforced on websocket turns without replaying the rejected request. |
| Claude signatures | Recognize model-free and unknown-generation thinking signatures, validate the CAIS carrier format, and keep unknown-generation Claude signatures off the Grok fallback. |
| Claude client version | Treat the pinned Claude Code version as a floor, not a lock, and expose the observed client versions through the management API. |
| Container | Railway entrypoint with persistent config and auth storage under `/data`. The timezone is set through a symlink. |
| CI | Upstream-only contribution workflows run only on the upstream repository. |

## Updating to a new upstream release

```sh
git fetch upstream --tags
git switch patched
git merge vX.Y.Z -m "Merge CLIProxyAPI vX.Y.Z and preserve custom patches"
GOFLAGS=-buildvcs=false go test ./...
git push origin patched
```

Merge the release instead of rebasing onto it. The Claude signature patches
conflict when replayed commit by commit on newer releases.

`TestResponsesInterruptStopsHTTPUpstream` and `TestServerResponsesWebsocketReauthorizesEachTurn` also fail
intermittently on unpatched upstream (the latter in about 30% of runs on v8.0.64, a TempDir cleanup race).
