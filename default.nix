let
  zmk = (import ../zmk) {};
in rec {
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

  glove80_left = zmk.zmk.override {
    board = "glove80_lh";
    keymap = ./config/glove80.keymap;
  };

  glove80_right = zmk.zmk.override {
    board = "glove80_rh";
    keymap = ./config/glove80.keymap;
  };

  glove80_combined = zmk.combine_uf2 glove80_left glove80_right "glove80";
}