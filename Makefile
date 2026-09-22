switch:
	sudo nixos-rebuild switch --flake .#karpalo

update:
	nix flake update

cleanup:
	nix-collect-garbage -d
	nix-store --optimise

link:
	mkdir -p $(or $(TARGET),$(HOME)/.config/$(APP))
	stow -d config/$(APP) -t $(or $(TARGET),$(HOME)/.config/$(APP)) .

unlink:
	stow -d config/$(APP) -t $(or $(TARGET),$(HOME)/.config/$(APP)) -D .
