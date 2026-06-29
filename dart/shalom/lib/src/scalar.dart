abstract class CustomScalarImpl<T> {
  const CustomScalarImpl();
  T deserialize(dynamic raw);
  dynamic serialize(T value);
}
