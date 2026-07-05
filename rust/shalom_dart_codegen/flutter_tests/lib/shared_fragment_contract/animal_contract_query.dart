import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';

import '__graphql__/CommonAnimalFrag.shalom.dart';
import '__graphql__/DogFavoriteFrag.shalom.dart';
import '__graphql__/ExtendedDogStatusFrag.shalom.dart';
import '__graphql__/DogWithFavoriteToyFrag.shalom.dart';
import '__graphql__/HasFavoriteToyFrag.shalom.dart';
import '__graphql__/MinimalDogStatusFrag.shalom.dart';
import '__graphql__/ToyFrag.shalom.dart';
import '__graphql__/ZooAnimalsContractQuery.widget.shalom.dart';

@Fragment(r'''
on Toy {
  id
  label
}
''')
class ToyFrag extends $ToyFrag {
  const ToyFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, ToyFragData data) {
    return Text(data.label, textDirection: TextDirection.ltr);
  }
}

@Fragment(r'''
on HasFavoriteToy {
  favoriteToy {
    ...ToyFrag
  }
}
''')
class HasFavoriteToyFrag extends $HasFavoriteToyFrag {
  const HasFavoriteToyFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, HasFavoriteToyFragData data) {
    return Text(data.favoriteToy.label, textDirection: TextDirection.ltr);
  }
}

@Fragment(r'''
on Animal {
  __typename
  id
}
''')
class CommonAnimalFrag extends $CommonAnimalFrag {
  const CommonAnimalFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, CommonAnimalFragData data) {
    return Text(data.id, textDirection: TextDirection.ltr);
  }
}

@Fragment(r'''
on Dog {
  ...CommonAnimalFrag
  breed
  ...HasFavoriteToyFrag
}
''')
class DogFavoriteFrag extends $DogFavoriteFrag {
  const DogFavoriteFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, DogFavoriteFragData data) {
    return Text(
      '${data.favoriteToy.label}:${data.breed}',
      textDirection: TextDirection.ltr,
    );
  }
}

@Fragment(r'''
on Dog {
  ...CommonAnimalFrag
  breed
  ...HasFavoriteToyFrag
}
''')
class DogWithFavoriteToyFrag extends $DogWithFavoriteToyFrag {
  const DogWithFavoriteToyFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, DogWithFavoriteToyFragData data) {
    return Text(data.favoriteToy.label, textDirection: TextDirection.ltr);
  }
}

@Fragment(r'''
on Dog {
  status {
    __typename
    ... on MovementStatus {
      motionType
    }
  }
}
''')
class MinimalDogStatusFrag extends $MinimalDogStatusFrag {
  const MinimalDogStatusFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, MinimalDogStatusFragData data) {
    return Text(data.status.$__typename, textDirection: TextDirection.ltr);
  }
}

@Fragment(r'''
on Dog {
  ...MinimalDogStatusFrag
  status {
    ... on StatusInterface {
      originMessage
    }
    ... on MovementStatus {
      sensitivity
    }
  }
}
''')
class ExtendedDogStatusFrag extends $ExtendedDogStatusFrag {
  const ExtendedDogStatusFrag({super.key, required super.ref});

  @override
  Widget buildData(BuildContext context, ExtendedDogStatusFragData data) {
    return Text(data.status.$__typename, textDirection: TextDirection.ltr);
  }
}

@Query(r'''
{
  animals {
    __typename
    ...CommonAnimalFrag
    ...DogFavoriteFrag
    ...DogWithFavoriteToyFrag
    ...ExtendedDogStatusFrag
  }
}
''')
class ZooAnimalsContractQuery extends $ZooAnimalsContractQuery {
  const ZooAnimalsContractQuery({super.key});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, ZooAnimalsContractQueryData data) {
    return Text('${data.animals.length}', textDirection: TextDirection.ltr);
  }
}
