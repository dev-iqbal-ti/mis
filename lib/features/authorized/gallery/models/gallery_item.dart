import 'dart:convert';

import 'package:intl/intl.dart';

List<GalleryItem> galleryItemFromJson(String str) => List<GalleryItem>.from(
  json.decode(str).map((x) => GalleryItem.fromJson(x)),
);

String galleryItemToJson(List<GalleryItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GalleryItem {
  final int id;
  final int userId;
  final String imageUrl;
  final String thumbnailUrl;
  final DateTime createdAt;
  final String name;

  GalleryItem({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.createdAt,
    required this.name,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) => GalleryItem(
    id: json["id"],
    userId: json["user_id"],
    imageUrl: json["image_url"],
    thumbnailUrl: json["thumbnail_url"],
    createdAt: DateTime.parse(json["created_at"]),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "image_url": imageUrl,
    "thumbnail_url": thumbnailUrl,
    "created_at": createdAt.toIso8601String(),
    "name": name,
  };
}

// --- 2. Mock Data & Helpers ---

// Helper to format dates nicely (Today, Yesterday, MM/dd/yyyy)
String getFormattedDateHeader(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final dateToCheck = DateTime(date.year, date.month, date.day);

  if (dateToCheck == today) {
    return "Today";
  } else if (dateToCheck == yesterday) {
    return "Yesterday";
  } else {
    return DateFormat('MMMM d, yyyy').format(date);
  }
}

// Helper to group raw list by formatted date string
Map<String, List<GalleryItem>> groupItemsByDate(List<GalleryItem> items) {
  final Map<String, List<GalleryItem>> groupedItems = {};

  // Sort by date descending first
  items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  for (var item in items) {
    final dateHeader = getFormattedDateHeader(item.createdAt);
    if (!groupedItems.containsKey(dateHeader)) {
      groupedItems[dateHeader] = [];
    }
    groupedItems[dateHeader]!.add(item);
  }
  return groupedItems;
}
