import T "../src/Types";
import QH "../src/Quickhull";

actor {
  public func convexHull(pts: T.Points) : async T.Hull {
    QH.quickHull(pts)
  }
}
