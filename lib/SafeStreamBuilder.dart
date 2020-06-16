import 'package:flutter/cupertino.dart';

class SafeStreamBuilder<T> extends StatelessWidget {

	final T initialData;
	final AsyncWidgetBuilder<T> builder;
	final Stream<T> stream;

	const SafeStreamBuilder({Key key,
		                        this.initialData,
		                        this.stream,
		                        @required this.builder,}) :
				assert(builder != null),
				super(key: key);

	@override
	Widget build(BuildContext context) =>
			StreamBuilder(
				initialData: initialData,
				stream: stream,
				builder: (context, snapshot) {
					if (!snapshot.hasData) {
						return SizedBox.shrink();
					} else {
						return builder.call(context, snapshot);
					}
				},
			);

}