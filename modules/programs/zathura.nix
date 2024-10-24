{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  catppuccin-latte = ''
    set default-fg                rgba(76,79,105,1)
    set default-bg 			          rgba(239,241,245,1)

    set completion-bg		          rgba(204,208,218,1)
    set completion-fg		          rgba(76,79,105,1)
    set completion-highlight-bg	  rgba(87,82,104,1)
    set completion-highlight-fg	  rgba(76,79,105,1)
    set completion-group-bg		    rgba(204,208,218,1)
    set completion-group-fg		    rgba(30,102,245,1)

    set statusbar-fg		          rgba(76,79,105,1)
    set statusbar-bg		          rgba(204,208,218,1)

    set notification-bg		        rgba(204,208,218,1)
    set notification-fg		        rgba(76,79,105,1)
    set notification-error-bg	    rgba(204,208,218,1)
    set notification-error-fg	    rgba(210,15,57,1)
    set notification-warning-bg	  rgba(204,208,218,1)
    set notification-warning-fg	  rgba(250,227,176,1)

    set inputbar-fg			          rgba(76,79,105,1)
    set inputbar-bg 		          rgba(204,208,218,1)

    set recolor                   "true"
    set recolor-lightcolor		    rgba(239,241,245,1)
    set recolor-darkcolor		      rgba(76,79,105,1)

    set index-fg			            rgba(76,79,105,1)
    set index-bg			            rgba(239,241,245,1)
    set index-active-fg		        rgba(76,79,105,1)
    set index-active-bg		        rgba(204,208,218,1)

    set render-loading-bg		      rgba(239,241,245,1)
    set render-loading-fg		      rgba(76,79,105,1)

    set highlight-color		        rgba(87,82,104,0.5)
    set highlight-fg              rgba(234,118,203,0.5)
    set highlight-active-color	  rgba(234,118,203,0.5)
  '';

  catppuccin-mocha = ''
    set default-fg                rgba(205,214,244,1)
    set default-bg 			          rgba(30,30,46,1)

    set completion-bg		          rgba(49,50,68,1)
    set completion-fg		          rgba(205,214,244,1)
    set completion-highlight-bg	  rgba(87,82,104,1)
    set completion-highlight-fg	  rgba(205,214,244,1)
    set completion-group-bg		    rgba(49,50,68,1)
    set completion-group-fg		    rgba(137,180,250,1)

    set statusbar-fg		          rgba(205,214,244,1)
    set statusbar-bg		          rgba(49,50,68,1)

    set notification-bg		        rgba(49,50,68,1)
    set notification-fg		        rgba(205,214,244,1)
    set notification-error-bg	    rgba(49,50,68,1)
    set notification-error-fg	    rgba(243,139,168,1)
    set notification-warning-bg	  rgba(49,50,68,1)
    set notification-warning-fg	  rgba(250,227,176,1)

    set inputbar-fg			          rgba(205,214,244,1)
    set inputbar-bg 		          rgba(49,50,68,1)

    set recolor                   "true"
    set recolor-lightcolor		    rgba(30,30,46,1)
    set recolor-darkcolor		      rgba(205,214,244,1)

    set index-fg			            rgba(205,214,244,1)
    set index-bg			            rgba(30,30,46,1)
    set index-active-fg		        rgba(205,214,244,1)
    set index-active-bg		        rgba(49,50,68,1)

    set render-loading-bg		      rgba(30,30,46,1)
    set render-loading-fg		      rgba(205,214,244,1)

    set highlight-color		        rgba(87,82,104,0.5)
    set highlight-fg              rgba(245,194,231,0.5)
    set highlight-active-color	  rgba(245,194,231,0.5)
  '';
in
{
  home-manager.users.${config.user} = {
    programs.zathura = {
      enable = true;
      options = {
        guioptions = "none";
        recolor-keephue = true;
        selection-clipboard = "clipboard";
        selection-notification = false;
        zoom-center = true;
      };
      extraConfig = catppuccin-mocha;
    };

    xdg.dataFile."scripts/zathura-wrapper.sh".source = pkgs.writeScript "zathura-wrapper" ''
      #!/bin/sh
      zathura "$1" & disown
    '';

    xdg.desktopEntries = {
      "org.pwmt.zathura-pdf-mupdf" = {
        name = "Zathura";
        type = "Application";
        comment = "zathura :)";
        exec = "/home/neeku/.local/share/scripts/zathura-wrapper.sh %U";
        # keywords = ["vscode"];
        terminal = false;
        noDisplay = true;
        categories = [
          "Office"
          "Viewer"
        ];
        mimeType = [
          "application/pdf"
          "application/epub+zip"
          "application/oxps"
          "application/x-fictionbook"
        ];
      };

      "org.pwmt.zathura" = {
        name = "Zathura";
        type = "Application";
        comment = "Zathura :)";
        exec = ''sh -c "zathura %U & disown"'';
        # keywords = ["vscode"];
        terminal = false;
        icon = "org.pwmt.zathura";
        noDisplay = true;
        mimeType = [
          "application/pdf"
          "application/epub"
        ];
        categories = [
          "Office"
          "Viewer"
        ];
        startupNotify = true;
      };
    };
  };
}
