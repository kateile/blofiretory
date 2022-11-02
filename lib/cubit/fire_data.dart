import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FireData<T> extends Equatable {
  const FireData( {
    required this.object,
    required this.doc,
  });

  ///This is actual object
  final T object;

  /// This is firebase id. It can be used in editing/deleting
  final DocumentSnapshot<T> doc;

  @override
  List<Object?> get props => [object, doc];
}
