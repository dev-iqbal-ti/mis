import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- 1. Data Model ---
class GalleryItem {
  final String id;
  final String imageUrl;
  final DateTime creationDate;
  // Adding aspect ratio for the staggered effect
  final double aspectRatio;

  GalleryItem({
    required this.id,
    required this.imageUrl,
    required this.creationDate,
    this.aspectRatio = 1.0,
  });
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

// Dummy image data with different dates and aspect ratios
List<GalleryItem> mockGalleryItems = [
  GalleryItem(
    id: '1',
    imageUrl: 'https://picsum.photos/id/237/400/600', // Dog
    creationDate: DateTime.now(),
    aspectRatio: 400 / 600,
  ),
  GalleryItem(
    id: '2',
    imageUrl: 'https://picsum.photos/id/1025/600/400', // Pug
    creationDate: DateTime.now(),
    aspectRatio: 600 / 400,
  ),
  GalleryItem(
    id: '3',
    imageUrl: 'https://picsum.photos/id/1062/400/400', // Dog wrapped
    creationDate: DateTime.now(),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '4',
    imageUrl: 'https://picsum.photos/id/40/400/600', // Cat
    creationDate: DateTime.now().subtract(const Duration(days: 1)),
    aspectRatio: 400 / 600,
  ),
  GalleryItem(
    id: '5',
    imageUrl: 'https://picsum.photos/id/169/600/400', // Landscape
    creationDate: DateTime.now().subtract(const Duration(days: 1)),
    aspectRatio: 600 / 400,
  ),
  GalleryItem(
    id: '6',
    imageUrl: 'https://picsum.photos/id/219/500/500', // Tiger
    creationDate: DateTime.now().subtract(const Duration(days: 2)),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '7',
    imageUrl: 'https://picsum.photos/id/256/500/500', // Tiger
    creationDate: DateTime.now().subtract(const Duration(days: 10)),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '8',
    imageUrl: 'https://picsum.photos/id/619/500/500', // Tiger
    creationDate: DateTime.now().subtract(const Duration(days: 1)),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '9',
    imageUrl: 'https://picsum.photos/id/319/500/500', // Tiger
    creationDate: DateTime.now().subtract(const Duration(days: 1)),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '10',
    imageUrl: 'https://picsum.photos/id/249/500/500', // Tiger
    creationDate: DateTime.now().subtract(const Duration(days: 1)),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '11',
    imageUrl: 'https://picsum.photos/id/209/500/500', // Tiger
    creationDate: DateTime.now().subtract(const Duration(days: 1)),
    aspectRatio: 1.0,
  ),
  GalleryItem(
    id: '12',
    imageUrl: 'https://picsum.photos/id/225/400/600', // Teapot
    creationDate: DateTime.now().subtract(const Duration(days: 2)),
    aspectRatio: 400 / 600,
  ),
];

// Helper to group raw list by formatted date string
Map<String, List<GalleryItem>> groupItemsByDate(List<GalleryItem> items) {
  final Map<String, List<GalleryItem>> groupedItems = {};

  // Sort by date descending first
  items.sort((a, b) => b.creationDate.compareTo(a.creationDate));

  for (var item in items) {
    final dateHeader = getFormattedDateHeader(item.creationDate);
    if (!groupedItems.containsKey(dateHeader)) {
      groupedItems[dateHeader] = [];
    }
    groupedItems[dateHeader]!.add(item);
  }
  return groupedItems;
}
