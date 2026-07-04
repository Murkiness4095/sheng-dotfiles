{ config, pkgs, ... }:

{
  users.mutableUsers = false;

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fall_dust = {
    isNormalUser = true;
    hashedPassword = "$6$4W.SQiUcbZlEzn27$7mJVzEWZWtwRELuR/VBImj2hDUQTFMo3ZkMZ4yI4YQ9hlDqPXwslAASB7fmauTAfi3Cnj08Zz0N2yBlVCu9Hb0";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "render" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpr2d4l3Qr9w0DK/jgVPBnCWfT9rPYnBNFr6Rw/86ov"
    ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHpr2d4l3Qr9w0DK/jgVPBnCWfT9rPYnBNFr6Rw/86ov"
    ];
  };
}