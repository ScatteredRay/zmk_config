let
  zmk = (import ../zmk) {};
in {
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
}