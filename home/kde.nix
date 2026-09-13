{ pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "26.05";
 
  # wallpaper
  #stylix = {
  #  enable = true;
  #  overrideConfig = true;
  #  image = ./path/to/your/wallpaper.jpg; # Path to your image file
  #};
 

  # task panel on all displays
  programs.plasma = {
   enable = true;

   # Overwrites manual GUI changes with this config
   # overrideConfig = true;

   panels = [
      {
        location = "bottom";
        height = 48;
        screen = "all";
        widgets = [
          "org.kde.plasma.pager"
          "org.kde.plasma.taskmanager"
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
