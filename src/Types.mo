import L "mo:base/List";
module {
  public type Point = (Float, Float);
  public type Points = L.List<Point>;
  public type Hull = Points;
  public type Line = (Point, Point);
}
