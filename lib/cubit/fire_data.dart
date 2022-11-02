import 'package:equatable/equatable.dart';

class FireData<T> extends Equatable {
  const FireData({
    required this.object,
    required this.id,
  });

  ///This is actual object
  final T object;

  /// This is firebase id. It can be used in editing/deleting
  final String id;

  @override
  List<Object?> get props => [object, id];
}
