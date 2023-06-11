{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = {self, nixpkgs}:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      texfew = (pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-small
          dvisvgm dvipng import transparent
          wrapfig amsmath ulem hyperref
          capt-of cancel xcolor arydshln
          preview mylatexformat;
      });
    in
      {
        packages.${system} = {
          emacs = pkgs.emacs;
          texlive = texfew;
        };
        
        devShell.${system} =
          pkgs.mkShell {
            name = "texlive2022";
            packages = [ pkgs.emacs texfew pkgs.hyperfine ];
          };
      };
}
