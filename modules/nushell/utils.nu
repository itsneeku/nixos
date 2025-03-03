export def make-editable [
    path: string
] {
    let tmpdir = (mktemp -d)
    rsync -avz --copy-links $"($path)/" $tmpdir
    rsync -avz --copy-links --chmod=D2755,F744 $"($tmpdir)/" $path
}

export def "nixos rebuild" [] {
    try {
      nh os switch
    } catch {
      notify-send -e 'NixOS Rebuild FAILED!' --icon=software-update-available
      return
    }
    notify-send -e 'NixOS Rebuild OK!' --icon=software-update-available
}

export def "nixos upgrade" [] {
    enter $env.FLAKE
    nix flake update
    if $env.LAST_EXIT_CODE != 0 {
        notify-send -e 'NixOS Upgrade FAILED!' --icon=software-update-available
        return 1
    }
    nixos rebuild
    dexit
}

export def "hm fix" [] {
    journalctl  --unit home-manager-neeku.service -e 
}

# export def "shell" [pkg: string, ...rest: string] {
#     nix shell $"nixpkgs#($pkg) ($rest)"
# }

# export def "run" [pkg: string, ...rest: string] {
#     nix run $"nixpkgs#($pkg) ($rest)"
# }

# def shell [...packages: string] {
#   # Build the 'nix shell' command with 'nixpkgs#' for each package
#   let nix_command = $"nix shell " + ($packages | each { |pkg| $"nixpkgs#($pkg)" } | str join " ")
  
#   # Run the constructed command
#   ^$"($nix_command)"
# }