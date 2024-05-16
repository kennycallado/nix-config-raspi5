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
            hash = "10$TDh68T5XUK10$TDh68T5XUK10$TDh68T5XUK";
            username = "test";
            # easily generated with `$ uuidgen`
            userID = "6D196B03-8A28-4D6E-B849-9298168CBA34";
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
