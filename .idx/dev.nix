{pkgs}: {

  # Which nixpkgs channel to use.
  channel = "unstable"; # or "unstable"

  # Use https://search.nixos.org/packages to  find packages
  packages = [
    pkgs.nodejs_18
    pkgs.dart
  ];

  # sets environment variables in the workspace
  env = {
    SOME_ENV_VAR = "hello";
  };

  # search for the extension on https://open-vsx.org/ and use "publisher.id"
  idx.extensions = [
    "angular.ng-template"
  ];

  # preview configuration, identical to monospace.json
  idx.previews = {
    enable = true;
    previews = [
      {
        command = [
          "npm"
          "run"
          "start"
          "--"
          "--port"
          "$PORT"
          "--host"
          "0.0.0.0"
          "--disable-host-check"
        ];
        manager = "web";
        id = "web";
      }
    ];
  };
}