# GEThub

GEThub is a dead simple, zero-dependency installer for remote GitHub executables. There is no database. No cache. No elevated privileges. GEThub reads the `gethub.env` file in the repository's root, then downloads and installs the specified executable to `~/.local/bin/`.

###### INSTALLATION
---
Either clone this repository and run `./install.sh`, or install the GEThub script directly via:
```
curl -fLsS 'https://raw.githubusercontent.com/Starscade/gethub/main/gethub.sh' > ~/.local/bin/gethub

chmod +x ~/.local/bin/gethub
```

###### USAGE
---
Run `gethub <user>/<repo>` to install a GEThub package. Run `gethub` alone to update GEThub itself.
