the expected behavior for types of inputs:
1. (input / operation variables objects) fields
	1. nonnull -> field type as per normal
    2. nullable no default value -> should resolved as a Maybe type in order to distinguish absent values (allowing patch graphql operations)
    3. nullable with default -> just a normal nullable
2. (input / operation variables objects) constructors
    1. if the field is required 
        1. has default value? -> should be nullable at constructor with the default value injected inline or in a constructor list based on the implementation details
        2. otherwise should use required this.<field_name>
    2. field is nullable
        1. has default value?
            1. if default value is `null` => just use this.fieldname
            2. default value is not `null` and doesn't need initializer list (e.g builtin_scalar `field: String = ""`) => should just result something like `SomeInputType({this.field = const ""})`
            3. default value is not `null` and the field requires an initializer list => i.e `field: Point = POINT(1, 23)`  type should be `Maybe<T>` because we want to know if the user passed something or we should use the default value defined in the schema should look something like this `SomeInputType({Maybe<PointScalarType> field = const None()}): field = field.unwrapOr(PointScalarType.deserialize("POINT(1, 23)"))`
		2. otherwise this is a Maybe type so just use `this.field = const None()` as per normal
