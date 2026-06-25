enum FileType {
  profileAvatar,
  announcementImage,
  chatMessageImage,
  shareAndHelpImage,
}

extension FileTypeApiValue on FileType {
  String get apiValue {
    switch (this) {
      case FileType.profileAvatar:
        return 'PROFILE_AVATAR';
      case FileType.announcementImage:
        return 'ANNOUNCEMENT_IMAGE';
      case FileType.chatMessageImage:
        return 'CHAT_MESSAGE_IMAGE';
      case FileType.shareAndHelpImage:
        return 'SHARE_AND_HELP_IMAGE';
    }
  }
}
