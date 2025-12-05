import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';

abstract class BaseService {
  CollectionReference? ref;

  BaseService({this.ref});

  Future<DocumentReference> addDocument(Map data) async {
    final doc = await ref!.add(data);
    doc.update({'uid': doc.id});
    return doc;
  }

  Future<DocumentReference> addDocumentWithCustomId(String id, Map<String, dynamic> data) async {
    final doc = ref!.doc(id);

    return doc.set(data).then((value) {
      return doc;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) => ref!.doc(id).update(data);

  Future<void> removeDocument(String id) => ref!.doc(id).delete();

  Future<bool> isUserExist(String? email) async {
    final Query query = ref!.limit(1).where('email', isEqualTo: email);
    final res = await query.get();

    return res.docs.isNotEmpty;
  }

  Future<Iterable> getList() async {
    final res = await ref!.get();
    final Iterable it = res.docs;
    return it;
  }
}