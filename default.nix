{
  pkgs,
  zmk,
}:
rec {
  cradio_left = zmk.zmk.override {
    shield = "cradio_left";
    board = "nice_nano_v2";
    keymap = ./config/cradio.keymap;
    kconfig = ./config/cradio.conf;
  };

  cradio_right = zmk.zmk.override {
    shield = "cradio_right";
    board = "nice_nano_v2";
    keymap = ./config/cradio.keymap;
    kconfig = ./config/cradio.conf;
  };

  cradio_combined = zmk.combine_uf2 cradio_left cradio_right "cradio";

  glove80_left = zmk.zmk.override {
    board = "glove80_lh";
    keymap = ./config/glove80.keymap;
  };

  glove80_right = zmk.zmk.override {
    board = "glove80_rh";
    keymap = ./config/glove80.keymap;
  };

  glove80_combined = zmk.combine_uf2 glove80_left glove80_right "glove80";

  collect_uf2 = a: b: pkgs.runCommandNoCC "collect_${a.name}_${b.name}" {} ''
    mkdir -p $out
    cp ${a}/*.uf2 $out
    cp ${b}/*.uf2 $out
  '';

  default = collect_uf2 cradio_combined glove80_combined;
}