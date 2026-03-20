switch:
	sudo nixos-rebuild switch --flake .#karpalo

update:
	nix flake update

cleanup:
	nix-collect-garbage -d
	nix-store --optimise
