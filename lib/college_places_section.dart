import 'package:flutter/material.dart';

class CollegePlacesSection extends StatelessWidget {
  const CollegePlacesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CollegeSectionBlock(
          heading: 'Our College Places',
          subheading: 'Explore the heart of our campus',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/6455c8cd2de778a700dbfebd887f8d63ef1511f2.jpg',
            tag: 'ACADEMIC HUB',
            title: 'Grand Memorial Library',
            description:
            'Over 2 million volumes, silent study atriums, and 24/7 access to digital archives for all enrolled students.',
            icon: Icons.local_library_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/dddf66d6b574b7ae95f195b6fcc8e6ae383965a9.jpg',
              title: 'The Quad Cafe',
              description: 'Artisan coffee and collaboration.',
              icon: Icons.local_cafe_outlined,
              iconColor: AppColorsss.secondary,
            ),
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/fd131a0556d5bb174f2732095428a88b2ea6d522.jpg',
              title: 'Athletics Center',
              description: 'Fitness, courts, and team sports.',
              icon: Icons.sports_basketball_outlined,
              iconColor: AppColorsss.primary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Classrooms & Lecture Halls',
          subheading: 'Smart spaces designed for deep learning',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/4714ac241972b6b992d99d699775538ee1ad6910.jpg',
            tag: 'SMART CLASSROOMS',
            title: 'State-of-the-Art Lecture Halls',
            description:
            'Equipped with HD projectors, smart boards, tiered seating, and real-time collaborative tools to power every class.',
            icon: Icons.desktop_windows_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/175af68bf781ed566170fa90e08d4d7b3fc34698.jpg',
              title: 'Tutorial Rooms',
              description: 'Intimate settings for focused group sessions.',
              icon: Icons.menu_book_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/1/16/5th_Floor_Lecture_Hall.jpg',
              title: 'Video-Enabled Halls',
              description: 'Recorded lectures & hybrid sessions.',
              icon: Icons.ondemand_video_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Seminar Hall & Auditorium',
          subheading: 'Grand venues for events and presentations',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/c765a718380b762005c4c019a2711cbb06402946.jpg',
            tag: 'EVENTS & CULTURE',
            title: 'Main Auditorium',
            description:
            'A state-of-the-art venue for annual fests, seminars, convocation events, performances, and inspiring guest lectures.',
            icon: Icons.groups_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/7cf7f5fc894e2180eb06d45b0ebd387de1e3db70.jpg',
              title: 'Seminar Hall A',
              description: 'Ideal for conferences and technical workshops.',
              icon: Icons.cast_for_education_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/7d826b74fe6490ea4ff5be6e795d8b75ba6198e1.jpg',
              title: 'Seminar Hall B',
              description: 'Perfect for talks, demos, and presentations.',
              icon: Icons.record_voice_over_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Mess & Dining',
          subheading: 'Nutritious meals at the heart of campus life',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/6ced60e76f0a3f06e0ec155115e184bb5af62df8.jpg',
            tag: 'DINING HUB',
            title: 'Central Mess Hall',
            description:
            'Spacious and hygienic dining space serving fresh meals for hundreds of students every day.',
            icon: Icons.restaurant_outlined,
            iconColor: AppColorsss.secondary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/ce4f832bc5d248397f2bcf0912ddbc51c2ecd09e.jpg',
              title: 'North Wing Mess',
              description: 'Clean seating and organized meal counters.',
              icon: Icons.table_restaurant_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/784ac37b78871f372435f3ddf7175013e6691b65.jpg',
              title: 'Canteen & Snack Bar',
              description: 'Quick bites and beverages between classes.',
              icon: Icons.fastfood_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Placement Section',
          subheading: 'Connecting talent with opportunity',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/35f3e7afa9224c2694c9ee744db4a836ea0c8bfc.jpg',
            tag: 'CAREER CENTER',
            title: 'Training & Placement Cell',
            description:
            'Our placement section supports students with training, mock interviews, career guidance, and campus recruitment drives.',
            icon: Icons.business_center_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://picsum.photos/seed/interviewroom/700/500',
              title: 'Interview Rooms',
              description: 'Dedicated spaces for recruitment processes.',
              icon: Icons.meeting_room_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://picsum.photos/seed/careerlab/700/500',
              title: 'Career Guidance Labs',
              description: 'Resume building, aptitude prep, and mentoring.',
              icon: Icons.school_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Main Block',
          subheading: 'The administrative and academic heart',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/11a91e850eabf725a7d0b7bf6144101d7e043107.jpg',
            tag: 'MAIN CAMPUS',
            title: 'Academic Main Block',
            description:
            'A landmark building housing major departments, faculty rooms, and essential administrative offices.',
            icon: Icons.apartment_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/1732e5ddef61e37e4f384e4c67985c313b100c3b.jpg',
              title: 'Admin Block',
              description: 'Student services, registrar, and offices.',
              icon: Icons.account_balance_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://picsum.photos/seed/departments/700/500',
              title: 'Department Wings',
              description: 'Home to academics, labs, and faculty cabins.',
              icon: Icons.domain_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Gym & Fitness Center',
          subheading: 'Stay active, stay sharp',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/c244c9d620a5f6ec615df1ea707bcb72b9464727.jpg',
            tag: 'FITNESS & WELLNESS',
            title: 'Modern Fitness Center',
            description:
            'A fully equipped gym with cardio machines, weight training areas, and space for everyday workouts.',
            icon: Icons.fitness_center_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/fd131a0556d5bb174f2732095428a88b2ea6d522.jpg',
              title: 'Weight Training Zone',
              description: 'Strength equipment and trainer support.',
              icon: Icons.sports_gymnastics_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://picsum.photos/seed/indoorsports/700/500',
              title: 'Indoor Sports Area',
              description: 'Badminton, TT, and indoor fitness activity.',
              icon: Icons.sports_handball_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Cricket Ground',
          subheading: 'Championship-grade outdoor sports space',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/135c4af55684b32696b01b6e0dd2e967d2be7ae5.jpg',
            tag: 'SPORTS GROUND',
            title: 'International-Standard Cricket Ground',
            description:
            'An expansive cricket ground with a well-maintained outfield, practice facilities, and match-day energy.',
            icon: Icons.sports_cricket_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/3b50347afda3e504ea60c18e8e9ab5021988d618.jpg',
              title: 'Match Day Arena',
              description: 'Inter-college tournaments and sporting events.',
              icon: Icons.emoji_events_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://picsum.photos/seed/footballground/700/500',
              title: 'Multi-Sports Field',
              description: 'Outdoor area for football and athletics too.',
              icon: Icons.sports_soccer_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
        SizedBox(height: 32),
        CollegeSectionBlock(
          heading: 'Environment',
          subheading: 'A sustainable and refreshing campus atmosphere',
          feature: PlaceData(
            imageUrl:
            'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/5ff6480dd4076b2fc677510e900e783d4b00b61b.jpg',
            tag: 'GREEN CAMPUS',
            title: 'Lush Green Environment',
            description:
            'Tree-lined pathways, open lawns, eco-conscious spaces, and a peaceful setting for learning and growth.',
            icon: Icons.eco_outlined,
            iconColor: AppColorsss.primary,
          ),
          secondaryPlaces: [
            PlaceData(
              imageUrl:
              'https://pplx-res.cloudinary.com/image/upload/pplx_search_images/560189a86f31984919e1a3385d4e26d54ae47f61.jpg',
              title: 'Eco Architecture',
              description: 'Green campus planning and modern buildings.',
              icon: Icons.park_outlined,
              iconColor: AppColorsss.primary,
            ),
            PlaceData(
              imageUrl:
              'https://picsum.photos/seed/naturewalk/700/500',
              title: 'Nature Walk Trail',
              description: 'A calm stretch for walking and relaxation.',
              icon: Icons.forest_outlined,
              iconColor: AppColorsss.secondary,
            ),
          ],
        ),
      ],
    );
  }
}

class CollegeSectionBlock extends StatelessWidget {
  final String heading;
  final String subheading;
  final PlaceData feature;
  final List<PlaceData> secondaryPlaces;

  const CollegeSectionBlock({
    super.key,
    required this.heading,
    required this.subheading,
    required this.feature,
    required this.secondaryPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColorsss.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subheading,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColorsss.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          PlaceFeatureCardd(data: feature),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: PlaceSecondaryCardd(data: secondaryPlaces[0])),
              const SizedBox(width: 16),
              Expanded(child: PlaceSecondaryCardd(data: secondaryPlaces[1])),
            ],
          ),
        ],
      ),
    );
  }
}

class PlaceData {
  final String imageUrl;
  final String title;
  final String description;
  final String? tag;
  final IconData icon;
  final Color iconColor;

  const PlaceData({
    required this.imageUrl,
    required this.title,
    required this.description,
    this.tag,
    required this.icon,
    required this.iconColor,
  });
}

class PlaceFeatureCardd extends StatelessWidget {
  final PlaceData data;

  const PlaceFeatureCardd({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsss.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    data.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined, size: 36),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.18),
                        ],
                      ),
                    ),
                  ),
                  if (data.tag != null)
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              data.icon,
                              size: 16,
                              color: data.iconColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              data.tag!,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: data.iconColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColorsss.onSurface,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: AppColorsss.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceSecondaryCardd extends StatelessWidget {
  final PlaceData data;

  const PlaceSecondaryCardd({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsss.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 132,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    data.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined, size: 28),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.14),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        data.icon,
                        size: 18,
                        color: data.iconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColorsss.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.description,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: AppColorsss.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppColorsss {
  static const Color primary = Color(0xFF01696F);
  static const Color secondary = Color(0xFF964219);
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF1A1714);
  static const Color onSurfaceVariant = Color(0xFF6B6965);
}