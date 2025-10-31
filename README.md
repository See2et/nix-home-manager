## Setup

experimental-featuresを設定
```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
. /etc/profile.d/nix.sh
```

Zshをログインシェルに指定
```bash
sudo sh -c 'echo /home/see2et/.nix-profile/bin/zsh >> /etc/shells'
chsh -s /home/see2et/.nix-profile/bin/zsh
```

設定を反映
```zsh
home-manager switch --impure
```
