import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
 Future<String> uploadImageToStorage(String chatRoom, Uint8List file, String uuid) async {
    Reference ref = _storage.ref().child(chatRoom).child(uuid);
    UploadTask uploadTask =
        ref.putData(file, SettableMetadata(contentType: 'image/jpg'));
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
