To rebuild the system in the VM:


cd ~/.dotfiles

sudo nixos-rebuild switch --flake .#VM


To rebuild Home Manager:

cd ~/.dotfiles

home-manager switch --flake .#matthijs
