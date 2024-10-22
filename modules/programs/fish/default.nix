{
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    # catppuccin.enable = true;
    # catppuccin.flavor = "mocha";
    enable = false;
    # To translate bash to fish, use babelfish:
    # > nix-shell -p babelfish
    # > echo "bash code" | babelfish
    shellAliases = {
      ls = "eza -la --icons=always";
      cat = "bat";
      logout = "hyprctl dispatch exit 1";
    };
    functions = {
      shell = ''
        set -l packages
        for pkg in $argv
            set packages $packages "nixpkgs#$pkg"
        end
        eval "nix shell $packages"
      '';
      nix = ''
        # Always open nix develop in $SHELL
        if test (count $argv) -ge 1 -a $argv[1] = "develop"
          command nix develop -c $SHELL $argv[2..-1]
        else
          command nix $argv
        end
      '';
      fish_prompt = ''
        if test -n "$SSH_TTY"
            echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
        end

        # echo -n (set_color blue)(prompt_pwd)' '

        set_color -o
        if fish_is_root_user
            echo -n (set_color red)'# '
        end
        echo -n (set_color white)'❯ '
        set_color normal
      '';
      rebuildOld = ''
        pushd ~/.nixos

        if git diff --quiet '*.nix'
          echo 'No changes detected.'
          popd
          return 0
        end

        git diff -U0 '*.nix'

        echo 'NixOS Rebuilding...'


        # exit and print on error
        # sudo nixos-rebuild switch | tee nixos-switch.log
        sudo nixos-rebuild switch 2>&1 | tee nixos-switch.log

        if grep -q error nixos-switch.log
          awk '/error:/ { if (++count > 1) { printing=1; } } printing { print; }' nixos-switch.log
          notify-send -e 'NixOS Rebuilt FAILED!' --icon=software-update-available
          return 1
        end

        # get current generation as "# date time"
        set current (sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1, $2, $3}')

        git add . && git commit -m $current

        popd

        notify-send -e 'NixOS Rebuilt OK!' --icon=software-update-available
      '';

      # TODO: I want a notify-send when it finished building and its waiting to apply/asking for sudo. Maybe use build and apply separately rather than switch?
      rebuild = ''
        pushd ~/.nixos

        git add . && git commit --quiet -m "FAILED"

        nh os switch .

        if test $status -ne 0
          notify-send -e 'NixOS Rebuilt FAILED!' --icon=software-update-available
          popd
          return 1
        end

        # get current generation as "# date time"
        set current (sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1, $2, $3}')

        git commit --amend --quiet -m $current

        popd

        notify-send -e 'NixOS Rebuilt OK!' --icon=software-update-available
      '';

      fish_greeting = ''
        # echo -e "  \e[38;2;112;103;207mhost\e[0m \t    neeku@apollo"
        # echo -e "  \e[38;2;112;103;207mlaptop\e[0m    Framework Laptop 13 (AMD Ryzen™ 5 7640U)"
        # echo -e "  \e[38;2;112;103;207mos\e[0m \t    NixOS"
        # echo -e "  \e[38;2;112;103;207mwm\e[0m \t    Hyprland"
        # echo -e "  \e[38;2;112;103;207mshell\e[0m\t    fish"
        # echo
      '';
    };

    # shellInit = ''
    #   set -g fish_greeting

    # # Cute manual fetch (not fetch)
    # echo -e "  \e[38;2;112;103;207mhost\e[0m \t    neeku@apollo"
    # echo -e "  \e[38;2;112;103;207mlaptop\e[0m    Framework Laptop 13 (AMD Ryzen™ 5 7640U)"
    # echo -e "  \e[38;2;112;103;207mos\e[0m \t    NixOS"
    # echo -e "  \e[38;2;112;103;207mwm\e[0m \t    Hyprland"
    # echo -e "  \e[38;2;112;103;207mshell\e[0m\t    fish"
    # echo
    # '';
  };

  # programs.starship = {
  #   enable = true;
  # };
}
