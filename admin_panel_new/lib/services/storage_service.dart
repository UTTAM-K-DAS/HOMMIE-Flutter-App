import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:developer' as developer;

// Custom exceptions for better error handling
class StorageUploadException implements Exception {
  final String message;
  final dynamic originalError;

  StorageUploadException(this.message, [this.originalError]);

  @override
  String toString() => 'StorageUploadException: $message';
}

class StorageDeleteException implements Exception {
  final String message;
  final dynamic originalError;

  StorageDeleteException(this.message, [this.originalError]);

  @override
  String toString() => 'StorageDeleteException: $message';
}

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  void _log(String message) {
    developer.log(message, name: 'StorageService');
  }

  // File validation constants
  static const int _maxImageSizeMB = 10;
  static const int _maxDocumentSizeMB = 50;
  static const List<String> _allowedImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
  ];
  static const List<String> _allowedDocumentExtensions = [
    '.pdf',
    '.doc',
    '.docx',
    '.txt',
    '.xls',
    '.xlsx',
  ];

  // Validate file before upload
  bool _validateFile(File file, String fileType) {
    final extension = path.extension(file.path).toLowerCase();
    final fileSizeBytes = file.lengthSync();
    final fileSizeMB = fileSizeBytes / (1024 * 1024);

    if (fileType == 'image') {
      if (!_allowedImageExtensions.contains(extension)) {
        throw StorageUploadException(
          'Invalid image format. Allowed: ${_allowedImageExtensions.join(', ')}',
        );
      }
      if (fileSizeMB > _maxImageSizeMB) {
        throw StorageUploadException(
          'Image too large. Max size: ${_maxImageSizeMB}MB',
        );
      }
    } else if (fileType == 'document') {
      if (!_allowedDocumentExtensions.contains(extension)) {
        throw StorageUploadException(
          'Invalid document format. Allowed: ${_allowedDocumentExtensions.join(', ')}',
        );
      }
      if (fileSizeMB > _maxDocumentSizeMB) {
        throw StorageUploadException(
          'Document too large. Max size: ${_maxDocumentSizeMB}MB',
        );
      }
    }

    return true;
  }

  // Retry mechanism for failed operations
  Future<T> _retryOperation<T>(
    Future<T> Function() operation,
    String operationName, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        if (attempt == maxRetries) {
          _log('$operationName failed after $maxRetries attempts: $e');
          rethrow;
        }
        _log(
          '$operationName attempt $attempt failed, retrying in ${delay.inSeconds}s: $e',
        );
        await Future.delayed(delay * attempt); // Exponential backoff
      }
    }
    throw Exception('Unexpected end of retry loop');
  }

  // Upload image and get download URL
  Future<String?> uploadImage({
    required File file,
    required String folder,
    String? fileName,
    Function(double)? onProgress,
  }) async {
    try {
      // Validate file before upload
      _validateFile(file, 'image');

      final fileExtension = path.extension(file.path);
      final uploadFileName =
          fileName ??
          _generateSecureFileName(
            'image_${DateTime.now().millisecondsSinceEpoch}$fileExtension',
          );

      final ref = _storage.ref().child('$folder/$uploadFileName');
      final uploadTask = ref.putFile(file);

      // Listen to upload progress with better tracking
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
        _log('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save file metadata
      await _saveFileMetadata(
        fileName: uploadFileName,
        filePath: '$folder/$uploadFileName',
        downloadUrl: downloadUrl,
        fileSize: await file.length(),
        fileType: 'image',
      );

      _log('Successfully uploaded image: $uploadFileName');
      return downloadUrl;
    } on StorageUploadException {
      rethrow; // Re-throw validation errors
    } catch (e) {
      _log('Error uploading image: $e');
      throw StorageUploadException('Failed to upload image', e);
    }
  }

  // Upload image from bytes (for web)
  Future<String?> uploadImageFromBytes({
    required Uint8List bytes,
    required String folder,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final ref = _storage.ref().child('$folder/$fileName');
      final uploadTask = ref.putData(bytes);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save file metadata
      await _saveFileMetadata(
        fileName: fileName,
        filePath: '$folder/$fileName',
        downloadUrl: downloadUrl,
        fileSize: bytes.length,
        fileType: 'image',
      );

      return downloadUrl;
    } catch (e) {
      _log('Error uploading image from bytes: $e');
      return null;
    }
  }

  // Upload document file
  Future<String?> uploadDocument({
    required File file,
    required String folder,
    String? fileName,
    Function(double)? onProgress,
  }) async {
    try {
      // Validate file before upload
      _validateFile(file, 'document');

      final fileExtension = path.extension(file.path);
      final uploadFileName =
          fileName ??
          _generateSecureFileName(
            'document_${DateTime.now().millisecondsSinceEpoch}$fileExtension',
          );

      final ref = _storage.ref().child('$folder/$uploadFileName');
      final uploadTask = ref.putFile(file);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Save file metadata
      await _saveFileMetadata(
        fileName: uploadFileName,
        filePath: '$folder/$uploadFileName',
        downloadUrl: downloadUrl,
        fileSize: await file.length(),
        fileType: 'document',
      );

      return downloadUrl;
    } catch (e) {
      _log('Error uploading document: $e');
      return null;
    }
  }

  // Pick and upload image
  Future<String?> pickAndUploadImage({
    required String folder,
    ImageSource source = ImageSource.gallery,
    Function(double)? onProgress,
  }) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        return await uploadImage(
          file: file,
          folder: folder,
          onProgress: onProgress,
        );
      }
      return null;
    } catch (e) {
      _log('Error picking and uploading image: $e');
      return null;
    }
  }

  // Pick and upload multiple images
  Future<List<String>> pickAndUploadMultipleImages({
    required String folder,
    int maxImages = 10,
    Function(double)? onProgress,
  }) async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      final urls = <String>[];
      final filesToUpload = pickedFiles.take(maxImages).toList();

      for (int i = 0; i < filesToUpload.length; i++) {
        final file = File(filesToUpload[i].path);
        final url = await uploadImage(
          file: file,
          folder: folder,
          onProgress: (progress) {
            final totalProgress = (i + progress) / filesToUpload.length;
            onProgress?.call(totalProgress);
          },
        );

        if (url != null) {
          urls.add(url);
        }
      }

      return urls;
    } catch (e) {
      _log('Error picking and uploading multiple images: $e');
      return [];
    }
  }

  // Pick and upload document
  Future<String?> pickAndUploadDocument({
    required String folder,
    List<String> allowedExtensions = const ['pdf', 'doc', 'docx', 'txt'],
    Function(double)? onProgress,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await uploadDocument(
          file: file,
          folder: folder,
          fileName: result.files.single.name,
          onProgress: onProgress,
        );
      }
      return null;
    } catch (e) {
      _log('Error picking and uploading document: $e');
      return null;
    }
  }

  // Delete file from storage
  Future<bool> deleteFile(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      await ref.delete();

      // Remove metadata
      await _removeFileMetadata(filePath);

      return true;
    } catch (e) {
      _log('Error deleting file: $e');
      return false;
    }
  }

  // Delete file by URL
  Future<bool> deleteFileByUrl(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();

      // Remove metadata
      await _removeFileMetadataByUrl(downloadUrl);

      return true;
    } catch (e) {
      _log('Error deleting file by URL: $e');
      return false;
    }
  }

  // Get file metadata
  Future<Map<String, dynamic>?> getFileMetadata(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      final metadata = await ref.getMetadata();

      return {
        'name': metadata.name,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'created': metadata.timeCreated,
        'updated': metadata.updated,
      };
    } catch (e) {
      _log('Error getting file metadata: $e');
      return null;
    }
  }

  // List files in folder
  Future<List<Reference>> listFiles(String folder) async {
    try {
      final ref = _storage.ref().child(folder);
      final result = await ref.listAll();
      return result.items;
    } catch (e) {
      _log('Error listing files: $e');
      return [];
    }
  }

  // Get download URL from path
  Future<String?> getDownloadUrl(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      _log('Error getting download URL: $e');
      return null;
    }
  }

  // Compress image
  Future<File?> compressImage(File file, {int quality = 85}) async {
    try {
      // This would typically use a compression package
      // For now, we'll return the original file
      return file;
    } catch (e) {
      _log('Error compressing image: $e');
      return null;
    }
  }

  // Save file metadata to Firestore
  Future<void> _saveFileMetadata({
    required String fileName,
    required String filePath,
    required String downloadUrl,
    required int fileSize,
    required String fileType,
  }) async {
    try {
      await _firestore.collection('file_metadata').add({
        'fileName': fileName,
        'filePath': filePath,
        'downloadUrl': downloadUrl,
        'fileSize': fileSize,
        'fileType': fileType,
        'uploadedAt': FieldValue.serverTimestamp(),
        'uploadedBy': 'admin',
      });
    } catch (e) {
      _log('Error saving file metadata: $e');
    }
  }

  // Remove file metadata
  Future<void> _removeFileMetadata(String filePath) async {
    try {
      final query = await _firestore
          .collection('file_metadata')
          .where('filePath', isEqualTo: filePath)
          .get();

      for (final doc in query.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      _log('Error removing file metadata: $e');
    }
  }

  // Remove file metadata by URL
  Future<void> _removeFileMetadataByUrl(String downloadUrl) async {
    try {
      final query = await _firestore
          .collection('file_metadata')
          .where('downloadUrl', isEqualTo: downloadUrl)
          .get();

      for (final doc in query.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      _log('Error removing file metadata by URL: $e');
    }
  }

  // Get file metadata from Firestore
  Stream<QuerySnapshot> getFileMetadataStream() {
    return _firestore
        .collection('file_metadata')
        .orderBy('uploadedAt', descending: true)
        .snapshots();
  }

  // Upload user profile image
  Future<String?> uploadUserProfileImage({
    required String userId,
    required File imageFile,
    Function(double)? onProgress,
  }) async {
    return await uploadImage(
      file: imageFile,
      folder: 'users/$userId/profile',
      fileName: 'profile_image.jpg',
      onProgress: onProgress,
    );
  }

  // Upload service image
  Future<String?> uploadServiceImage({
    required String serviceId,
    required File imageFile,
    Function(double)? onProgress,
  }) async {
    return await uploadImage(
      file: imageFile,
      folder: 'services/$serviceId',
      onProgress: onProgress,
    );
  }

  // Upload provider document
  Future<String?> uploadProviderDocument({
    required String providerId,
    required File documentFile,
    required String documentType,
    Function(double)? onProgress,
  }) async {
    return await uploadDocument(
      file: documentFile,
      folder: 'providers/$providerId/documents',
      fileName: _generateSecureFileName(
        '${documentType}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      ),
      onProgress: onProgress,
    );
  }

  // Clean up old files (utility function)
  Future<void> cleanupOldFiles({int daysOld = 30}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      final query = await _firestore
          .collection('file_metadata')
          .where('uploadedAt', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      for (final doc in query.docs) {
        final filePath = doc.data()['filePath'] as String;
        await deleteFile(filePath);
      }
    } catch (e) {
      _log('Error cleaning up old files: $e');
    }
  }

  // Get storage usage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final query = await _firestore.collection('file_metadata').get();

      int totalFiles = query.docs.length;
      int totalSize = 0;
      Map<String, int> fileTypeCount = {};

      for (final doc in query.docs) {
        final data = doc.data();
        totalSize += (data['fileSize'] as int?) ?? 0;
        final fileType = data['fileType'] as String? ?? 'unknown';
        fileTypeCount[fileType] = (fileTypeCount[fileType] ?? 0) + 1;
      }

      return {
        'totalFiles': totalFiles,
        'totalSize': totalSize,
        'totalSizeMB': (totalSize / 1024 / 1024).toStringAsFixed(2),
        'fileTypeCount': fileTypeCount,
      };
    } catch (e) {
      _log('Error getting storage stats: $e');
      return {};
    }
  }

  // Batch delete files
  Future<Map<String, bool>> batchDeleteFiles(List<String> filePaths) async {
    final results = <String, bool>{};

    for (final filePath in filePaths) {
      try {
        final success = await _retryOperation(
          () => deleteFile(filePath),
          'Delete file: $filePath',
        );
        results[filePath] = success;
      } catch (e) {
        _log('Failed to delete file $filePath: $e');
        results[filePath] = false;
      }
    }

    return results;
  }

  // Generate secure filename
  String _generateSecureFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalName);
    final baseName = path
        .basenameWithoutExtension(originalName)
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .toLowerCase();
    return '${baseName}_$timestamp$extension';
  }

  // Check if file exists
  Future<bool> fileExists(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }
}
