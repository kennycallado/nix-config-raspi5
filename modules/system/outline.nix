{ config, pkgs, lib, ... }:

{

  networking.extraHosts = ''
    127.0.0.1 dex.localhost
  '';

  services = {

    outline = {
      enable = true;
      publicUrl = "http://localhost:3000";
      forceHttps = false;
      storage.storageType = "local";
      oidcAuthentication = {
        # Parts taken from
        # http://dex.localhost/.well-known/openid-configuration
        authUrl = "http://dex.localhost/auth";
        tokenUrl = "http://dex.localhost/token";
        userinfoUrl = "http://dex.localhost/userinfo";
        clientId = "outline";
        clientSecretFile = (builtins.elemAt config.services.dex.settings.staticClients 0).secretFile;
        scopes = [ "openid" "email" "profile" ];
        usernameClaim = "preferred_username";
        displayName = "Dex";
      };
    };

    dex = {
      enable = true;
      settings = {
        issuer = "http://dex.localhost";
        storage.type = "sqlite3";
        web.http = "127.0.0.1:5556";
        enablePasswordDB = true;
        staticClients = [
          {
            id = "outline";
            name = "Outline Client";
            redirectURIs = [ "http://localhost:3000/auth/oidc.callback" ];
            secretFile = "${pkgs.writeText "outline-oidc-secret" "test123"}";
          }
        ];
        staticPasswords = [
          {
            email = "user.email@example.com";
            # bcrypt hash of the string "password": $(echo password | htpasswd -BinC 10 admin | cut -d: -f2)
            hash = "$2y$10$ICvcJUnRKeuFdocATI8oGe.6DGxamXY3/5A2WYO4y0d3s9WLXvrVC";
            username = "test";
            # easily generated with `$ uuidgen`
            userID = "95F24CEB-5A13-426E-B020-5B9C6C0A276A";
          }
        ];
      };
    };

    nginx = {
      enable = true;
      virtualHosts = {
        "localhost" = {
          locations."/" = {
            proxyPass = "${config.services.outline.publicUrl}";
          };
        };
        "dex.localhost" = {
          locations."/" = {
            proxyPass = "http://${config.services.dex.settings.web.http}";
          };
        };
      };
    };
  };
}
