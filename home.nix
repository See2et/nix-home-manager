# /etc/nixos/home.nix  (統合後の正本)
{
  config,
  pkgs,
  rustToolchain,
  lib,
  isDarwin,
  ...
}:
{
  home.username = if isDarwin then "see2et" else "nixos";
  home.homeDirectory = if isDarwin then "/Users/see2et" else "/home/nixos";

  home.stateVersion = "25.05";

  home.packages =
    (with pkgs; [
      git
      neovim
      zsh
      gcc
      unzip
      rust-analyzer
      tre-command
      lsd
      nixfmt-rfc-style
      gh
      ghq
      lazygit
      zellij
      codex
      zenn-cli
      peco
      zoxide
      nodejs_24
      pnpm
      yarn
      deno
      uv
      fastfetch
      tree-sitter
      yt-dlp
      ripgrep
      ffmpeg
      fzf
      markdownlint-cli2
      yubikey-manager
      wget # for VSCode Server
    ])
    ++ [ rustToolchain ];

  home.file = {
    ".gitconfig".source = ./.gitconfig;
    ".p10k.zsh".source = ./.p10k.zsh;
    ".codex/config.toml".source = ./codex/config.toml;
    ".codex/AGENTS.md".source = ./codex/AGENTS.md;
    ".codex/github-mcp.sh" = {
      source = ./codex/github-mcp.sh;
      executable = true;
    };
    "yubikey-setup.sh" = {
      source = ./yubikey-setup.sh;
      executable = true;
    };
  };

  xdg.configFile = {
    "nvim".source = ./nvim;
    "zellij".source = ./zellij;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    UV_TOOL_DIR = "$XDG_DATA_HOME/uv/tools";
    UV_TOOL_BIN_DIR = "$XDG_DATA_HOME/uv/tools/bin";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$XDG_DATA_HOME/uv/tools/bin"
  ];

  programs.home-manager.enable = true;

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-notify ];
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
  };

  programs.zsh = {
    enable = true;

    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';
        zshConfig = lib.mkOrder 1000 ''
          export ABBR_QUIET=1
          ABBR_SET_EXPANSION_CURSOR=1

          typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

          eval "$(zoxide init zsh)"
          eval "$(${pkgs.uv}/bin/uv generate-shell-completion zsh)"

          function peco-ghq () {
            cd "$( ghq list --full-path | peco --prompt "REPO> " --layout=bottom-up)"
          }
          abbr -S gp='peco-ghq'

          function peco-git-switch() {
            local sel branch
            sel=$(
              git for-each-ref --format='%(refname:short)' refs/heads \
              | peco --prompt "BRANCH> " --query "$LBUFFER" --layout=bottom-up --print-query \
              | tail -n 1
            ) || return

            [[ -z "$sel" ]] && return
            branch="$sel"

            if git show-ref --verify --quiet "refs/heads/$branch"; then
              git switch "$branch"
            else
              git switch -c "$branch"
            fi
          }
          abbr -S gsp="peco-git-switch"

          function peco-history() {
            local selected_command=$(fc -l -n 1 | tail -300 | awk '!seen[$0]++ { lines[++count] = $0 } END { for (i = count; i >= 1; i--) print lines[i] }' | peco --prompt "HISTORY>" --layout=bottom-up)

            if [ -n "$selected_command" ]; then
              print -s "$selected_command"
              echo "Executing: $selected_command"
              eval "$selected_command"
            fi
          }
          abbr -S hp="peco-history"

          function peco-zoxide() {
            local dir
            dir=$(zoxide query -l | peco --prompt "DIR> " --layout=bottom-up)
            [[ -n "$dir" ]] && cd "$dir"
          }
          abbr -S zp="peco-zoxide"
        '';
      in
      lib.mkMerge [ zshConfigEarlyInit zshConfig ];

    zsh-abbr = {
      enable = true;
      abbreviations = {
        v = "nvim";
        ll = "lsd -alF";
        ls = "lsd";
        la = "lsd -altr";
        lg = "lazygit";
        bat = "batcat";
        ze = "zellij --layout 1p2p";
        up = "cd ../";
        cl = "clear";

        re = if isDarwin
          then "home-manager switch --flake /etc/nixos#darwin"
          else "sudo nixos-rebuild switch --flake /etc/nixos#nixos";

        gcm = ''git commit -m "%"'';
      };
    };

    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "romkatv/powerlevel10k"
        "Tarrasch/zsh-bd"
      ];
    };
  };
}

