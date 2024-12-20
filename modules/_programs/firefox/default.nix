{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  firefox-devedition-autoconfig =
    (pkgs.firefox-devedition.overrideAttrs (oldAttrs: {
      buildCommand =
        oldAttrs.buildCommand
        + ''
          echo 'pref("general.config.sandbox_enabled", false);' >> $out/lib/firefox/defaults/pref/autoconfig.js
        '';
    })).override
      {
        extraPrefs = ''
          ${builtins.readFile ./userChrome.js}
          ${builtins.readFile ./user-chome-js-loader.js}
        '';
      };
in
{
  programs.firefox = {
    enable = true;
    package = firefox-devedition-autoconfig;
    profiles.neeku = {
      name = "neeku";
      isDefault = true;
      settings = {
        "middlemouse.paste" = false;
        "browser.startup.homepage" = "about:blank";
        "browser.tabs.tabmanager.enabled" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "devtools.debugger.prompt-connection" = false;
        "svg.context-properties.content.enabled" = true;
        "layout.css.has-selector.enabled" = true;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "browser.urlbar.trimHttps" = true;
        "browser.urlbar.trimURLs" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "widget.gtk.ignore-bogus-leave-notify" = 1; # fixes Sidebery tab dragging
        "browser.tabs.allow_transparent_browser" = false; # Setting to true matches some pages' background color to current theme => BAD
        "ui.key.menuAccessKeyFocuses" = false;
        # "mousewheel.default.delta_multiplier_y" = 50;
        "mousewheel.with_alt.action" = 0;

        # Allow Dark Reader to work on mozilla websites
        "extensions.webextensions.restrictedDomains" = "";
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
      };
    };
  };

  # Disable the dev edition profile
  home.file.".mozilla/firefox/ignore-dev-edition-profile".text = "";

  # Symlink userChrome.css
  home.file.".mozilla/firefox/neeku/chrome/" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/modules/programs/firefox/chrome/";
    recursive = true;
  };
}
