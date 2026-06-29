import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/StreetSubscription.widget.shalom.dart';

@Subscription(r'''
{
  streetAnimals {
    ...DogFrag
  }
}
''')
class StreetSubscription extends $StreetSubscription {
  const StreetSubscription({super.key});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading street', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, StreetSubscriptionData data) {
    return Text(
      data.streetAnimals.$__typename,
      textDirection: TextDirection.ltr,
    );
  }
}
