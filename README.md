# GEThub

GEThub is a dead simple, shell-based installer for remote GitHub executables. There is no database. No cache. No elevated privileges. GEThub reads the `gethub.env` file in the repository's root, then downloads and installs the specified executable to `~/.local/bin/`.

---

###### INSTALLATION

Either clone this repository and run `./install.sh`, or install GEThub directly with:
```
mkdir -p ~/.local/bin ; curl -fsSL 'https://raw.githubusercontent.com/Starscade/gethub/main/install.sh' > ~/.local/bin/gethub && chmod +x ~/.local/bin/gethub
```

---

###### USAGE

- Run `gethub <user>/<repo>` to install a GEThub package. (The specified repo *must* contain a valid `gethub.env` at its root.)
- Run `gethub` alone to update GEThub itself.
