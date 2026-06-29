import 'package:flutter/widgets.dart';
import 'package:shalom_annotations/shalom_annotations.dart';
import '__graphql__/ShelterSubscription.widget.shalom.dart';

@Subscription(r'''
{
  shelterAnimals {
    ...DogFrag
  }
}
''')
class ShelterSubscription extends $ShelterSubscription {
  const ShelterSubscription({super.key});

  @override
  Widget buildLoading(BuildContext context) =>
      const Text('loading shelter', textDirection: TextDirection.ltr);

  @override
  Widget buildError(BuildContext context, Object error) =>
      Text('error: $error', textDirection: TextDirection.ltr);

  @override
  Widget buildData(BuildContext context, ShelterSubscriptionData data) {
    return Text(
      data.shelterAnimals.$__typename,
      textDirection: TextDirection.ltr,
    );
  }
}
