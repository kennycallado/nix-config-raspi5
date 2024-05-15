# nix-config-raspi5

## NOTES:

- Build sd-image
``` bash
nix build '.#nixosConfigurations.raspi5.config.system.build.sdImage'
```

- Issue: libcamera fails. workaround:
``` nix
raspberry-pi-nix.libcamera-overlay.enable = false;
```

## TODO:

