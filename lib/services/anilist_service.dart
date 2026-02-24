import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/release_item.dart';

class AniListService {
  static const String apiUrl = 'https://graphql.anilist.co';

  Future<List<ReleaseItem>> getUpcomingAnime(String timeframe) async {
    final dates = _getDateRange(timeframe);
    
    const query = r'''
query ($startDate_greater: Int, $startDate_lesser: Int) {
  Page(page: 1, perPage: 50) {
    media(
      type: ANIME,
      status_in: [RELEASING, NOT_YET_RELEASED],
      startDate_greater: $startDate_greater,
      startDate_lesser: $startDate_lesser,
      sort: START_DATE
    ) {
      id
      title {
        romaji
        english
      }
      startDate {
        year
        month
        day
      }
      coverImage {
        large
      }
      genres
      duration
      description
      format
      status
    }
  }
}
''';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'query': query,
          'variables': {
            'startDate_greater': dates['start'],
            'startDate_lesser': dates['end'],
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['errors'] != null) {
          print('GraphQL errors: ${data['errors']}');
          return [];
        }
        
        if (data['data'] != null && 
            data['data']['Page'] != null && 
            data['data']['Page']['media'] != null) {
          final mediaList = data['data']['Page']['media'] as List;
          final results = mediaList
              .map((json) => ReleaseItem.fromAniList(json))
              .toList();
          
          // Additional filter to ensure dates are within exact range
          final now = DateTime.now();
          DateTime startDate, endDate;
          
          if (timeframe == 'today') {
            startDate = DateTime(now.year, now.month, now.day);
            endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          } else if (timeframe == 'week') {
            startDate = DateTime(now.year, now.month, now.day);
            endDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 7));
          } else {
            startDate = DateTime(now.year, now.month, now.day);
            endDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 30));
          }
          
          return results.where((item) {
            return item.releaseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                   item.releaseDate.isBefore(endDate.add(const Duration(days: 1)));
          }).toList();
        }
      }
    } catch (e) {
      print('Error fetching upcoming anime: $e');
    }
    return [];
  }

  Map<String, int> _getDateRange(String timeframe) {
    final now = DateTime.now();
    int startYear, startMonth, startDay;
    int endYear, endMonth, endDay;

    if (timeframe == 'today') {
      // Same day only
      startYear = now.year;
      startMonth = now.month;
      startDay = now.day;
      endYear = now.year;
      endMonth = now.month;
      endDay = now.day;
    } else if (timeframe == 'week') {
      // Next 7 days starting from today
      final start = DateTime(now.year, now.month, now.day);
      final end = start.add(const Duration(days: 7));
      startYear = start.year;
      startMonth = start.month;
      startDay = start.day;
      endYear = end.year;
      endMonth = end.month;
      endDay = end.day;
    } else {
      // Next 30 days starting from today
      final start = DateTime(now.year, now.month, now.day);
      final end = start.add(const Duration(days: 30));
      startYear = start.year;
      startMonth = start.month;
      startDay = start.day;
      endYear = end.year;
      endMonth = end.month;
      endDay = end.day;
    }

    // Convert to AniList format (FuzzyDateInt)
    final startDate = startYear * 10000 + startMonth * 100 + startDay;
    final endDate = endYear * 10000 + endMonth * 100 + endDay;

    return {'start': startDate, 'end': endDate};
  }
}
