import T "Types";
import Float "Float";

module {
  public func linePointDistance(line: T.Line, v: T.Point) : Float {
    let nom = Float.abs(
      (line.1.0 - line.0.0) * (v.1 - line.0.1)
        - (line.1.1 - line.0.1) * (v.0 - line.0.0)
    );
    let den = Float.sqrt (
      Float.powNat(line.1.0 - line.0.0, 2)
        + Float.powNat(line.1.1 - line.0.1, 2)
    );
    nom / den
  };

  public func lineSideTest(line: T.Line, v: T.Point) : {#lt; #eq; #gt} {
    let pos = (line.1.0 - line.0.0) * (v.1 - line.0.1)
            - (line.1.1 - line.0.1) * (v.0 - line.0.0);
    if (pos == 0.0)  { #eq } // to do --- use a value of epsilon here?
    else if (pos > 0.0) { #gt }
    else { #lt }
  };
}
