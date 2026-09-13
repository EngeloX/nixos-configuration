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
}
