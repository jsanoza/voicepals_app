import 'package:voicepals/app/data/model/profile_information.dart';

class CombinedData {
  final String id;
  final String otherUserId;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final DateTime? createdAt;
  final ProfileInformation profileInfo;
  final bool? isRoomVisible;

  CombinedData({
    required this.id,
    required this.otherUserId,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    this.createdAt,
    required this.profileInfo,
    this.isRoomVisible,
  });
}
