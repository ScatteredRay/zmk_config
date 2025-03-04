{
  pkgs,
  zmk,
}:
rec {

  combine_uf2 = a: b: name: pkgs.runCommandNoCC "combined_${a.name}_${b.name}" {}
  ''
    mkdir -p $out
    cat ${a}/zmk.uf2 ${b}/zmk.uf2 > $out/${name}.uf2
  '';

  collect_uf2 = a: b: pkgs.runCommandNoCC "collect_${a.name}_${b.name}" {} ''
    mkdir -p $out
    cp ${a}/*.uf2 $out
    cp ${b}/*.uf2 $out
  '';

  cradio_left = (zmk.override {
    shield = "cradio_left";
    board = "nice_nano_v2";
    keymap = ./config/cradio.keymap;
    kconfig = ./config/cradio.conf;
    snippets = [
      #"zmk-usb-logging"
    ];
  }).overrideAttrs (prev: {
    #cmakeFlags = prev.cmakeFlags ++ ["-DSNIPPET='zmk-usb-loggingX'"];
  });

  cradio_right = (zmk.override {
    shield = "cradio_right";
    board = "nice_nano_v2";
    keymap = ./config/cradio.keymap;
    kconfig = ./config/cradio.conf;
    snippets = [
      #"zmk-usb-logging"
    ];
  }).overrideAttrs (prev: {
    #cmakeFlags = prev.cmakeFlags ++ ["-DSNIPPET='zmk-usb-loggingz'"];
  });

  # Combine_uf2 doesn't seem to work for cradio, 
  cradio_combined = pkgs.runCommandNoCC "collect_cradio" {} ''
    mkdir -p $out
    cp ${cradio_left}/zmk.uf2 $out/cradio_left.uf2
    cp ${cradio_right}/zmk.uf2 $out/cradio_right.uf2
  '';

  glove80_left = zmk.override {
    board = "glove80_lh";
    keymap = ./config/glove80.keymap;
    snippets = [
      #"zmk-usb-logging"
    ];
  };

  glove80_right = zmk.override {
    board = "glove80_rh";
    keymap = ./config/glove80.keymap;
  };

  glove80_combined = combine_uf2 glove80_left glove80_right "glove80";

  default = collect_uf2 cradio_combined glove80_combined;
}