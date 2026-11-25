# AI tools

Two modules, split by the role a machine plays. In T3 Code's terms an **environment** is a machine
running a T3 server, where agents work on its files; a **client** is the desktop app, web app or
phone you use to reach environments.

| Module | On | Installs |
| --- | --- | --- |
| `ai` | every machine (in `modules`) | T3 Code (desktop app on a Mac, else the `t3` command), Claude Code, Codex |
| `ai-host` | opt-in: `+ai-host` in `~/.config/dotconfig/modules` | T3's background service; CLIProxyAPI with cpa-reset-router (Linux) |

Each tool comes from its own recommended installer and updates itself, so bootstrap only installs
what is missing. Nothing here holds an account, key or hostname: those stay on the machine.

## A client: a machine you use T3 from

1. `./bootstrap.sh` (the `ai` module). On a Mac, install the desktop app from
   [t3.codes](https://t3.codes) if bootstrap says it is missing.
2. Sign in to T3 Code with your T3 account. Environments with T3 Connect on show up by themselves.
3. To reach an environment without T3 Connect: on that environment run `t3 pair`, then add it in
   the client with the code it prints (or scan its QR code from a phone).

The desktop app is also an environment of its own, for the Mac's own files.

## An environment other machines use

1. Add `+ai-host` to `~/.config/dotconfig/modules`, then `./bootstrap.sh`.
2. Sign in the agents: `claude`, then `codex login`.
3. `t3 up`: installs the background service and chooses how other devices reach it, T3 Connect
   through your account and/or LAN and tailnet with a pairing code. `t3 status` shows the result.
4. Linux: `t3 service protect` (asks for sudo) keeps the server alive under memory pressure.
5. CLIProxyAPI (Linux), so agents share a pool of accounts:
   - edit `~/.cli-proxy-api/config.yaml`, which bootstrap starts from the package's example;
   - add accounts: `cli-proxy-api --config ~/.cli-proxy-api/config.yaml -claude-login`
     (or `-codex-login`);
   - bootstrap builds and runs [cpa-reset-router](https://github.com/axieax/cpa-reset-router)
     (private; needs `gh auth login`), which spends the quota that resets soonest first, and
     `cpa-update`, which keeps CLIProxyAPI on the latest upstream release.
6. Point a client's agents at the proxy in that client's T3 provider settings (base URL and key),
   which stay on the client.

## Let agents in one environment work in another

`t3 environment link` on the environment whose agents should reach the other one; it then appears
in the other environment under Settings → Connections, where it can be revoked.
`t3 environment list` shows the links and whether each answers.
