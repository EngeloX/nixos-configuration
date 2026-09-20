# firefox configuration
{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.default = {
      settings = {
        "browser.startup.page" = 0;
        "browser.urlbar.suggest.calculator" = true;
      };
    };
  };

  # Firefox as the default browser
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
    };

    associations.added = {
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "text/html" = [ "firefox.desktop" ];
    };
  };
}

