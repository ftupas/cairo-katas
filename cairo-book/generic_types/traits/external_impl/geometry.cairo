// Here T is an alias type which will be provided buring implementation
trait ShapeGeometry<T> {
    fn boundary(self: T) -> u64;
    fn area(self: T) -> u64;
}
