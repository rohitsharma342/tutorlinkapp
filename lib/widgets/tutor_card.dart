import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/language_controller.dart';
import '../models/tutor.dart';
import 'rating_stars.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback? onTap;

  TutorCard({required this.tutor, this.onTap});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: tutor.profilePhoto != null
                        ? CachedNetworkImage(
                            imageUrl: tutor.profilePhoto!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[400],
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[400],
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[400],
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tutor.fullName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (tutor.isVerified)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF0768FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    size: 12,
                                    color: Color(0xFF0768FF),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    languageController.translate('verified'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF0768FF),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${tutor.genderText} • ${tutor.area}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          RatingStars(
                            rating: tutor.averageRating,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${tutor.averageRating.toStringAsFixed(1)} (${tutor.totalRatings})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${tutor.hourlyRate.toStringAsFixed(0)} SAR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0768FF),
                      ),
                    ),
                    Text(
                      languageController.translate('per_hour'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tutor.subjects.take(3).map((subject) => Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF0768FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subject,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0768FF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
            if (tutor.subjects.length > 3) ..[
              SizedBox(height: 4),
              Text(
                '+${tutor.subjects.length - 3} more subjects',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _getTeachingTypeIcon(tutor.teachingType),
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4),
                Text(
                  tutor.teachingTypeText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.work_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4),
                Text(
                  '${tutor.experienceYears} ${languageController.translate('years_experience')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTeachingTypeIcon(TeachingType type) {
    switch (type) {
      case TeachingType.inPerson:
        return Icons.person;
      case TeachingType.online:
        return Icons.computer;
      case TeachingType.both:
        return Icons.groups;
    }
  }
}