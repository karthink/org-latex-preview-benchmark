{
  description = "Texlive 2023 with emacs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgsFork.url = "github:apfelkuchen6/nixpkgs/texlive-update";
  };
  
  outputs = { self, nixpkgs, nixpkgsFork }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pkgsFork = import nixpkgsFork { inherit system; };
      texfew = (pkgsFork.texlive.combine {
        inherit (pkgsFork.texlive) scheme-small
          dvisvgm dvipng import transparent
          wrapfig amsmath ulem hyperref
          capt-of cancel xcolor arydshln
          preview mylatexformat;
      });
    in
      {
        packages.${system} = {
          texlive = texfew;
          emacs = pkgs.emacs;
        };
      
        devShell.${system} = 
          pkgs.mkShell {
            name = "texlive2023";
            packages = [ pkgs.emacs texfew pkgs.hyperfine ];
          };
      };
}
