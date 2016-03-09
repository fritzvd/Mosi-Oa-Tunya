
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;
import com.haxepunk.utils.Key;

class Inputs {

  static inline public function direction () {
    var _direction:Array<Float> = [0, 0];


    if (Input.joystick(0).check(XBOX_GAMEPAD.DPAD_UP) ||
        Input.check(Key.W) || Input.check(Key.UP)) {
          _direction[1] = -1; // pixel space move up y with -1
    }

    if (Input.joystick(0).check(XBOX_GAMEPAD.DPAD_DOWN) ||
        Input.check(Key.S) || Input.check(Key.DOWN)) {
          _direction[1] = 1; // pixel space move down y with 1
    }

    if (Input.joystick(0).check(XBOX_GAMEPAD.DPAD_LEFT) ||
        Input.check(Key.A) || Input.check(Key.LEFT)) {
          _direction[0] = -1; // pixel space move up x with -1
    }

    if (Input.joystick(0).check(XBOX_GAMEPAD.DPAD_RIGHT) ||
        Input.check(Key.D) || Input.check(Key.RIGHT)) {
          _direction[0] = 1; // pixel space move up x with 1
    }

    var XAXIS = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_X);
    var YAXIS = Input.joystick(0).getAxis(XBOX_GAMEPAD.LEFT_ANALOGUE_Y);
    if (Math.abs(XAXIS) > 0.1) {
      _direction[0] = XAXIS;
    }

    if (Math.abs(YAXIS) > 0.1) {
      _direction[1] = YAXIS;
    }

    return _direction;
  }

  static inline public function action () {
    var _action:String = null;

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON) ||
        Input.pressed(Key.Z)) {
          _action = 'left';
    }

    if (Input.joystick(0).pressed(XBOX_GAMEPAD.B_BUTTON) ||
        Input.pressed(Key.X)) {
          _action = 'right';
    }

    return _action;

  }

  static inline public function holding () {
    var _holding:String = null;

    if (Input.joystick(0).check(XBOX_GAMEPAD.A_BUTTON) ||
        Input.check(Key.Z)) {
          _holding = 'left';
    }

    if (Input.joystick(0).check(XBOX_GAMEPAD.B_BUTTON) ||
        Input.check(Key.X)) {
          _holding = 'right';
    }

    return _holding;
  }

}
