# ares-deps

This is [obs-deps](https://github.com/obsproject/obs-deps) gutted and repurposed to instead compile dependencies for [ares](https://github.com/ares-emulator/ares).

## Windows

OBS dependencies for Windows can be built via the `Build-Dependencies.ps1` PowerShell script. For best compatibility, it is advised to use a recent version of PowerShell Core (pwsh). Older versions of PowerShell might work, but support for these is not provided.

## macOS

OBS dependencies for macOS can be built via the `build-deps.zsh` Zsh-script. Zsh is the default interactive shell on macOS starting with macOS 10.15, the minimum version supported for building OBS. Both Intel and Apple Silicon are supported.

## Contributing

* Add/edit separate build scripts in the appropriate subdirectory.
* Ensure that either a valid Git commit hash is specified or a checksum file for a downloaded artifact has been placed in the `checksums` subdirectory
* If patches are necessary, ensure those are placed in a directory with the same name of the dependency inside the `patches` directory
* Name patches numerically padded to 4 digits (e.g., `0001`) and with a descriptive name
