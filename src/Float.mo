import P "mo:base/Prelude";
module {
  public func abs (f:Float) : Float {
    if (f > 0.0) { f } else { -f }
  };
  public func sqrt(f:Float) : Float {
    P.xxx()
  };
  public func powNat(f:Float, n:Nat) : Float {
    if (n == 0) { 1.0 } else {
      f * powNat(f, n - 1)
    }
  };
}
