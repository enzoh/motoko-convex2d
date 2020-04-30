import L "mo:base/List";
import P "mo:base/Prelude";

import T "Types";
import G "Geom2D";

module {

  func getMaxPointRec(
    maxDist: Float,
    maxPoint: T.Point,
    line: T.Line,
    pts: L.List<T.Point>
  ) : T.Point {
    switch pts {
      case null { maxPoint };
      case (?(pt, pts)) {
             let dist = G.linePointDistance(line, pt);
             if (dist > maxDist) {
               getMaxPointRec(dist, pt, line, pts)
             } else {
               getMaxPointRec(maxDist, maxPoint, line, pts)
             }
           };
    }
  };

  // traps on empty list
  public func getMaxPoint(
    line: T.Line,
    pts: L.List<T.Point>
  ) : T.Point {
    switch pts {
      case null { P.unreachable() };
      case (?(pt, pts)) { getMaxPointRec(0, pt, line, pts) };
    }
  };

  // lt/eq/gt in terms of horizontal, so #lt means "left part"
  public func getPartition(
    part: {#lt; #eq; #gt},
    line: T.Line,
    pts: L.List<T.Point>,
    accum: L.List<T.Point>,
  ) : L.List<T.Point> {
    switch pts {
      case null { L.rev(accum) };
      case (?(pt, pts)) {
             switch (part, G.lineSideTest(line, pt)) {
             case ((#lt, #lt) or
             (#eq, #eq) or
             (#gt, #gt)) { getPartition(part, line, pts, ?(pt, accum)) };
             case (_, _) { getPartition(part, line, pts, accum) };
             };
           }
    }
  };

  // assumed invariants:
  // 1. pts lie above line (reverse line end points for lower hull),
  // 2. pts lie to left of hullRight (read 'hullRight' as 'hullLeft' for lower hull)
  public func quickHullRec(
    line: T.Line,
    pts: L.List<T.Point>,
    hullRight: L.List<T.Point>) : L.List<T.Point>
  {
    if (L.isNil(pts)) {
      hullRight
    } else {
      let max = getMaxPoint(line, pts);
      let ptsRight = getPartition(#gt, (max, line.1), pts, null);
      let hullMax = ?(max, quickHullRec((max, line.1), ptsRight, hullRight));
      let ptsLeft = getPartition(#lt, (line.0, max), pts, null);
      quickHullRec((line.0, max), ptsLeft, hullMax)
    }
  };

  public func quickHull(pts: L.List<T.Point>) : L.List<T.Point> {
    // find a horizon line that will likely span the hull:
    let diag = ((-1.0, -1.0), (1.0, 1.0));
    let leftPoint = getMaxPoint(diag, pts);
    let rightPoint = getMaxPoint((diag.1, diag.0), pts);
    // (to do: this will not work if leftPoint and rightPoint are the same point.)
    // compute upper/lower hulls above/below horizon line:
    quickHullRec(
      (rightPoint, leftPoint),
      pts,
      quickHullRec(
        (leftPoint, rightPoint),
        pts,
        null))
  }
}
