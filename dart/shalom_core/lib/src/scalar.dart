abstract class CustomScalarImpl<T> {
  T deserialize(dynamic raw);
  dynamic serialize(T value);
}
