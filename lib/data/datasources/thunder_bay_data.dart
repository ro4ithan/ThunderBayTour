// ignore_for_file: unnecessary_const

import '../../core/enums/category.dart';
import '../../core/enums/season.dart';
import '../../domain/models/attraction.dart';
import '../../domain/models/restaurant.dart';
import 'restaurants_data_part1.dart';
import 'restaurants_data_part2.dart';

class ThunderBayData {
  ThunderBayData._();

  static final List<Attraction> attractions = [
    // ============ 1. Kakabeka Falls ============
    const Attraction(
      id: 'attr_001',
      name: 'Kakabeka Falls',
      shortDescription:
          'The "Niagara of the North" — a 40m waterfall over billion-year-old fossil rock.',
      fullDescription:
          'Known as the "Niagara of the North", Kakabeka Falls plunges 40 metres over sheer cliffs of 1.6-billion-year-old fossil-bearing rock. Boardwalks offer dramatic viewpoints on both sides of the Kaministiquia River, with the legend of Princess Green Mantle haunting the gorge below.',
      imageUrl:
          'https://images.unsplash.com/photo-1432405972618-c60b0225b8f9?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/kakabeka_falls.jpg',
      galleryImages: const [],
      rating: 4.8,
      reviewCount: 3421,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Hiking', 'Photography', 'Sightseeing', 'Picnicking'],
      openingHours: '8:00 AM – 9:00 PM',
      admissionFee: '\$2 day-use parking',
      isIndigenousSite: true,
      legend: const IndigenousLegend(
        title: 'Princess Green Mantle',
        story:
            'Green Mantle, daughter of an Ojibwe chief, lured a Sioux war party to their deaths over the falls to save her people. Her spirit is said to appear in the mist on quiet mornings.',
        culturalNote:
            'The falls are a sacred site to the Anishinaabe people of the Fort William First Nation.',
      ),
      bestTimeToVisit: 'Spring snowmelt for maximum flow, or autumn for colour.',
      parkingInfo: 'Paid lot at park entrance, accessible spots available.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4036,
      longitude: -89.6228,
    ),

    // ============ 2. Sleeping Giant Provincial Park ============
    const Attraction(
      id: 'attr_002',
      name: 'Sleeping Giant Provincial Park',
      shortDescription:
          'Iconic mesa peninsula with 100km of trails and 250m cliffs over Lake Superior.',
      fullDescription:
          'One of Ontario\'s most iconic landscapes — a series of mesas and sills on the Sibley Peninsula that, from a distance, resemble a giant lying on its back. The park offers 100 km of hiking trails, including the legendary Top of the Giant trail with cliffs rising 250m above Lake Superior.',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/sleeping_giant.jpg',
      galleryImages: const [],
      rating: 4.9,
      reviewCount: 1842,
      estimatedVisitMinutes: 240,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['Hiking', 'Camping', 'Wildlife viewing', 'Photography'],
      openingHours: '24 hours (gates close at 10 PM)',
      admissionFee: '\$13 daily vehicle permit',
      isIndigenousSite: true,
      legend: const IndigenousLegend(
        title: 'Nanabijou, the Sleeping Giant',
        story:
            'Nanabijou, the spirit of the deep sea water, was turned to stone after the location of his silver mine was revealed to white men. He lies sleeping forever across the bay.',
        culturalNote:
            'Sacred to the Ojibwe; the silver of Silver Islet is said to be Nanabijou\'s treasure.',
      ),
      bestTimeToVisit: 'September for fall colours and cool hiking weather.',
      parkingInfo: 'Multiple trailhead lots, busiest at Kabeyun and Sea Lion.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.3667,
      longitude: -88.8167,
    ),

    // ============ 3. Terry Fox Monument ============
    const Attraction(
      id: 'attr_003',
      name: 'Terry Fox Monument',
      shortDescription:
          'Bronze tribute to the Marathon of Hope, overlooking Lake Superior.',
      fullDescription:
          'A 9-foot bronze statue commemorating Terry Fox\'s Marathon of Hope, located near the spot where his run ended on September 1, 1980. Set against a stunning panorama of Lake Superior and the Sleeping Giant.',
      imageUrl:
          'https://images.unsplash.com/photo-1564399579883-451a5d44ec08?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/terry_fox.jpg',
      galleryImages: const [],
      rating: 4.7,
      reviewCount: 2156,
      estimatedVisitMinutes: 45,
      category: AttractionCategory.culture,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Sightseeing', 'Photography', 'Reflection'],
      openingHours: 'Open 24 hours',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Golden hour for the best Sleeping Giant backdrop.',
      parkingInfo: 'Large free lot at the lookout.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4376,
      longitude: -89.1898,
    ),

    // ============ 4. Fort William Historical Park ============
    const Attraction(
      id: 'attr_004',
      name: 'Fort William Historical Park',
      shortDescription:
          'Living history fur-trade fort with 42 buildings and costumed interpreters.',
      fullDescription:
          'Step into 1815 at one of North America\'s largest living history sites. Costumed interpreters bring the fur trade era to life across 42 reconstructed buildings, with voyageur canoes, Indigenous encampments, and working blacksmith shops.',
      imageUrl:
          'https://images.unsplash.com/photo-1533090481720-856c6e3c1fdc?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/fort_william.jpg',
      galleryImages: const [],
      rating: 4.6,
      reviewCount: 1278,
      estimatedVisitMinutes: 180,
      category: AttractionCategory.history,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const [
        'History tours',
        'Live demonstrations',
        'Canoeing',
        'Family activities'
      ],
      openingHours: '10:00 AM – 5:00 PM (mid-May to mid-Oct)',
      admissionFee: '\$15 adult / \$10 youth',
      isIndigenousSite: false,
      bestTimeToVisit: 'Anishinaabe Keeshigun festival in late June.',
      parkingInfo: 'Free on-site parking.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3589,
      longitude: -89.2761,
    ),

    // ============ 5. Amethyst Mine Panorama ============
    const Attraction(
      id: 'attr_005',
      name: 'Amethyst Mine Panorama',
      shortDescription:
          'North America\'s largest amethyst deposit — dig your own purple gems.',
      fullDescription:
          'The largest amethyst deposit in North America, where visitors can dig their own purple gemstones. The open-pit mine reveals 1-billion-year-old crystal formations and offers spectacular views of the surrounding boreal forest.',
      imageUrl:
          'https://images.unsplash.com/photo-1518123890711-3a3d3c8e7adc?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/amethyst_mine.jpg',
      galleryImages: const [],
      rating: 4.5,
      reviewCount: 892,
      estimatedVisitMinutes: 120,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['Gem digging', 'Sightseeing', 'Souvenir shopping'],
      openingHours: '10:00 AM – 6:00 PM (May–Oct)',
      admissionFee: '\$10 + \$3/lb for kept gems',
      isIndigenousSite: false,
      bestTimeToVisit: 'Mid-summer after rain — wet stones reveal colour best.',
      parkingInfo: 'Free gravel lot at the visitor centre.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.6833,
      longitude: -88.6333,
    ),

    // ============ 6. Mount McKay Lookout ============
    const Attraction(
      id: 'attr_006',
      name: 'Mount McKay Lookout',
      shortDescription:
          'Sacred 300m peak (Anemki Wajiw) with sweeping views of Thunder Bay.',
      fullDescription:
          'Sacred mountain (Anemki Wajiw) on Fort William First Nation land, rising 300m above the city. The lookout offers 360° views of Thunder Bay, Lake Superior, and the Sleeping Giant. A small admission fee supports the community.',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/mount_mckay.jpg',
      galleryImages: const [],
      rating: 4.6,
      reviewCount: 743,
      estimatedVisitMinutes: 60,
      category: AttractionCategory.indigenous,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['Sightseeing', 'Photography', 'Cultural learning'],
      openingHours: '9:00 AM – 8:00 PM (seasonal)',
      admissionFee: '\$5 per vehicle (supports the community)',
      isIndigenousSite: true,
      legend: const IndigenousLegend(
        title: 'Anemki Wajiw — Thunder Mountain',
        story:
            'The Anishinaabe believe Thunder Mountain is home to the Thunderbirds — powerful spirits who bring storms across Lake Superior to renew the land.',
        culturalNote:
            'Visitors are asked to be respectful; the upper summit is reserved for ceremony.',
      ),
      bestTimeToVisit: 'Clear summer evenings for sunset over the lake.',
      parkingInfo: 'Lot at the lookout, narrow access road.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3478,
      longitude: -89.2697,
    ),

    // ============ 7. Ouimet Canyon ============
    const Attraction(
      id: 'attr_007',
      name: 'Ouimet Canyon',
      shortDescription:
          'A 100m-deep gorge with rare arctic-alpine plants on the canyon floor.',
      fullDescription:
          'A breathtaking 100m-deep, 150m-wide gorge with sheer vertical walls. Two viewing platforms offer dizzying vantage points over the rare arctic-alpine ecosystem at the canyon floor — flora normally found 1000 km further north.',
      imageUrl:
          'https://images.unsplash.com/photo-1505765050516-f72dcac9c60e?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/ouimet_canyon.jpg',
      galleryImages: const [],
      rating: 4.7,
      reviewCount: 1056,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['Hiking', 'Photography', 'Geology viewing'],
      openingHours: '9:00 AM – 6:00 PM (May–Oct)',
      admissionFee: '\$3 day-use',
      isIndigenousSite: false,
      bestTimeToVisit: 'Late September for fall colour contrast with cliffs.',
      parkingInfo: 'Free lot at the trailhead, 1km boardwalk to viewpoints.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.7833,
      longitude: -88.6833,
    ),

    // ============ 8. Eagle Canyon Adventures ============
    const Attraction(
      id: 'attr_008',
      name: 'Eagle Canyon Adventures',
      shortDescription:
          'Canada\'s longest suspension footbridge and zipline — 152ft above the canyon.',
      fullDescription:
          'Home to Canada\'s longest suspension footbridge (600 ft) and longest zipline (1000 ft). Walk 152 ft above the canyon floor or zip across at 72 km/h for an adrenaline-fueled view of the Northern Ontario wilderness.',
      imageUrl:
          'https://images.unsplash.com/photo-1551632811-561732d1e306?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/eagle_canyon.jpg',
      galleryImages: const [],
      rating: 4.7,
      reviewCount: 1342,
      estimatedVisitMinutes: 150,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['Zipline', 'Suspension bridge walk', 'Hiking'],
      openingHours: '10:00 AM – 5:00 PM (mid-May to mid-Oct)',
      admissionFee: '\$25 bridges / \$100 zipline',
      isIndigenousSite: false,
      bestTimeToVisit: 'Weekday mornings to avoid bridge queues.',
      parkingInfo: 'Free on-site parking.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.7500,
      longitude: -88.5833,
    ),

    // ============ 9. Prince Arthur's Landing ============
    const Attraction(
      id: 'attr_009',
      name: 'Prince Arthur\'s Landing',
      shortDescription:
          'Revitalized waterfront park with marina, art, and Sleeping Giant views.',
      fullDescription:
          'Thunder Bay\'s revitalized waterfront park with a marina, splash pad, art installations, walking paths, and skating rink in winter. Stunning views of the Sleeping Giant across the harbour, especially at sunrise.',
      imageUrl:
          'https://images.unsplash.com/photo-1473773508845-188df298d2d1?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/marina_park.jpg',
      galleryImages: const [],
      rating: 4.6,
      reviewCount: 1567,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.waterfront,
      bestSeasons: const [Season.spring, Season.summer, Season.fall, Season.winter],
      activities: const ['Walking', 'Skating', 'Picnicking', 'Art viewing'],
      openingHours: 'Open 24 hours',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Sunrise over the Sleeping Giant.',
      parkingInfo: 'Free lots and street parking nearby.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4339,
      longitude: -89.2114,
    ),

    // ============ 10. Hillcrest Park ============
    const Attraction(
      id: 'attr_010',
      name: 'Hillcrest Park',
      shortDescription:
          'The iconic clifftop postcard view of the Sleeping Giant.',
      fullDescription:
          'The most iconic view of the Sleeping Giant — a clifftop park with a sweeping panorama over Lake Superior and downtown Port Arthur. The classic Thunder Bay postcard photo is taken here.',
      imageUrl:
          'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/hillcrest_park.jpg',
      galleryImages: const [],
      rating: 4.8,
      reviewCount: 989,
      estimatedVisitMinutes: 45,
      category: AttractionCategory.waterfront,
      bestSeasons: const [Season.spring, Season.summer, Season.fall, Season.winter],
      activities: const ['Sightseeing', 'Photography', 'Picnicking'],
      openingHours: 'Open 24 hours',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Sunrise — the Giant glows pink and gold.',
      parkingInfo: 'Free street parking along High Street.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4376,
      longitude: -89.2231,
    ),

    // ============ 11. Centennial Park ============
    const Attraction(
      id: 'attr_011',
      name: 'Centennial Park',
      shortDescription:
          '150-acre wilderness park with a 1910 logging camp and animal farm.',
      fullDescription:
          'A 150-acre wilderness park with a reconstructed 1910 logging camp, animal farm, and Current River walking trails. Perfect for families and an authentic window into Northern Ontario logging history.',
      imageUrl:
          'https://images.unsplash.com/photo-1448375240586-882707db888b?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/centennial_park.jpg',
      galleryImages: const [],
      rating: 4.4,
      reviewCount: 612,
      estimatedVisitMinutes: 120,
      category: AttractionCategory.history,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Walking', 'History', 'Animal viewing', 'Picnicking'],
      openingHours: '8:00 AM – 9:00 PM',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Saturday mornings when the logging camp is active.',
      parkingInfo: 'Free lot at park entrance.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4750,
      longitude: -89.1611,
    ),

    // ============ 12. Trowbridge Falls ============
    const Attraction(
      id: 'attr_012',
      name: 'Trowbridge Falls',
      shortDescription:
          'A peaceful cascade on the Current River with pine-forest trails.',
      fullDescription:
          'A peaceful cascade on the Current River with a network of hiking and biking trails through Norway pine forests. Excellent for a quick nature escape just minutes from the city.',
      imageUrl:
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/trowbridge_falls.jpg',
      galleryImages: const [],
      rating: 4.5,
      reviewCount: 487,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Hiking', 'Cycling', 'Photography', 'Camping'],
      openingHours: '8:00 AM – 10:00 PM',
      admissionFee: 'Free (campground extra)',
      isIndigenousSite: false,
      bestTimeToVisit: 'Spring melt for full cascade volume.',
      parkingInfo: 'Free lot at the trailhead.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.4889,
      longitude: -89.1583,
    ),

    // ============ 13. Thunder Bay Art Gallery ============
    const Attraction(
      id: 'attr_013',
      name: 'Thunder Bay Art Gallery',
      shortDescription:
          'Canada\'s leading gallery for contemporary Indigenous art.',
      fullDescription:
          'Canada\'s leading public gallery for contemporary Indigenous and Northwestern Ontario art. The permanent collection holds over 1,800 works featuring Norval Morrisseau, Roy Thomas, and the Woodland School.',
      imageUrl:
          'https://images.unsplash.com/photo-1554907984-15263bfd63bd?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/art_gallery.jpg',
      galleryImages: const [],
      rating: 4.5,
      reviewCount: 423,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.culture,
      bestSeasons: const [Season.spring, Season.summer, Season.fall, Season.winter],
      activities: const ['Art viewing', 'Guided tours', 'Gift shop'],
      openingHours: '12:00 PM – 5:00 PM (closed Mondays)',
      admissionFee: '\$8 adult / Free under 12',
      isIndigenousSite: false,
      bestTimeToVisit: 'Thursday evenings — late hours and free admission.',
      parkingInfo: 'Free lot on Confederation College campus.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3711,
      longitude: -89.2447,
    ),

    // ============ 14. Thunder Bay Museum ============
    const Attraction(
      id: 'attr_014',
      name: 'Thunder Bay Museum',
      shortDescription:
          'Lakehead history housed in the 1912 former police station.',
      fullDescription:
          'Housed in the 1912 former police station, the museum tells the story of the Lakehead region — from Ojibwe heritage and voyageur fur trade to grain elevators and the modern city.',
      imageUrl:
          'https://images.unsplash.com/photo-1565060299500-19ca0d3a4f7e?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/tbay_museum.jpg',
      galleryImages: const [],
      rating: 4.4,
      reviewCount: 312,
      estimatedVisitMinutes: 75,
      category: AttractionCategory.history,
      bestSeasons: const [Season.spring, Season.summer, Season.fall, Season.winter],
      activities: const ['Exhibits', 'Archives', 'Guided tours'],
      openingHours: '11:00 AM – 5:00 PM (Tue–Sat)',
      admissionFee: '\$6 adult',
      isIndigenousSite: false,
      bestTimeToVisit: 'Rainy afternoons — perfect indoor stop.',
      parkingInfo: 'Free street parking on Donald Street.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4302,
      longitude: -89.2128,
    ),

    // ============ 15. Cascades Conservation Area ============
    const Attraction(
      id: 'attr_015',
      name: 'Cascades Conservation Area',
      shortDescription:
          'Rocky cascades on the Current River surrounded by old-growth pine.',
      fullDescription:
          'A series of rocky cascades on the Current River surrounded by old-growth pines. Popular for short hikes, picnics, and photography in autumn when the maples turn fiery red.',
      imageUrl:
          'https://images.unsplash.com/photo-1490682143684-14369e18dce8?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/cascades.jpg',
      galleryImages: const [],
      rating: 4.5,
      reviewCount: 398,
      estimatedVisitMinutes: 75,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Hiking', 'Photography', 'Picnicking'],
      openingHours: 'Dawn to dusk',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Late September for peak fall colour.',
      parkingInfo: 'Small free lot off Hodder Avenue.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.5083,
      longitude: -89.1306,
    ),

    // ============ 16. Mission Island Marsh ============
    const Attraction(
      id: 'attr_016',
      name: 'Mission Island Marsh',
      shortDescription:
          '100-hectare wetland with boardwalks and 200+ bird species.',
      fullDescription:
          'A 100-hectare wetland conservation area on Lake Superior. Boardwalks and observation towers offer prime birdwatching — over 200 species including bald eagles, herons, and migrating waterfowl.',
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/mission_marsh.jpg',
      galleryImages: const [],
      rating: 4.4,
      reviewCount: 267,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.waterfront,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Birdwatching', 'Walking', 'Photography'],
      openingHours: 'Dawn to dusk',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'May migration or September shorebird passage.',
      parkingInfo: 'Free lot at the boardwalk entrance.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3611,
      longitude: -89.2289,
    ),

    // ============ 17. Pigeon River Provincial Park ============
    const Attraction(
      id: 'attr_017',
      name: 'Pigeon River Provincial Park',
      shortDescription:
          'High Falls — Ontario\'s second-highest waterfall at the US border.',
      fullDescription:
          'At the Canada-US border, this park protects High Falls — Ontario\'s second-highest waterfall at 28m. Boardwalks lead through cedar forests to dramatic clifftop viewpoints of the cascade.',
      imageUrl:
          'https://images.unsplash.com/photo-1467890947394-8171244e5410?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/pigeon_river.jpg',
      galleryImages: const [],
      rating: 4.7,
      reviewCount: 521,
      estimatedVisitMinutes: 120,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Hiking', 'Photography', 'Sightseeing'],
      openingHours: '8:00 AM – 8:00 PM (seasonal)',
      admissionFee: '\$11 day-use vehicle',
      isIndigenousSite: false,
      bestTimeToVisit: 'Spring snowmelt for peak flow.',
      parkingInfo: 'Free lot at the visitor centre.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.0044,
      longitude: -89.6175,
    ),

    // ============ 18. Loch Lomond Ski Area ============
    const Attraction(
      id: 'attr_018',
      name: 'Loch Lomond Ski Area',
      shortDescription:
          'Thunder Bay\'s premier ski hill — 18 runs, 700ft vertical.',
      fullDescription:
          'Thunder Bay\'s premier ski hill with 18 runs and a 700ft vertical drop. Reliable lake-effect snow from November through April makes this a winter destination for downhill skiing and snowboarding.',
      imageUrl:
          'https://images.unsplash.com/photo-1551524559-8af4e6624178?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/loch_lomond.jpg',
      galleryImages: const [],
      rating: 4.4,
      reviewCount: 689,
      estimatedVisitMinutes: 240,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.winter],
      activities: const ['Skiing', 'Snowboarding', 'Tubing', 'Lessons'],
      openingHours: '9:00 AM – 9:00 PM (Dec–Mar)',
      admissionFee: '\$55 adult day pass',
      isIndigenousSite: false,
      bestTimeToVisit: 'Mid-January after a fresh lake-effect dump.',
      parkingInfo: 'Free large lot at the chalet.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.3417,
      longitude: -89.2056,
    ),

    // ============ 19. Chippewa Park ============
    const Attraction(
      id: 'attr_019',
      name: 'Chippewa Park',
      shortDescription:
          'Vintage 1920 lakeside amusement park with a wooden carousel.',
      fullDescription:
          'A vintage lakeside amusement park established in 1920, featuring a historic wooden carousel, beach, hiking trails, and wildlife exhibit. A nostalgic Thunder Bay summer tradition.',
      imageUrl:
          'https://images.unsplash.com/photo-1513889961551-628c1e5e2ee9?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/chippewa_park.jpg',
      galleryImages: const [],
      rating: 4.3,
      reviewCount: 445,
      estimatedVisitMinutes: 150,
      category: AttractionCategory.waterfront,
      bestSeasons: const [Season.summer],
      activities: const ['Rides', 'Swimming', 'Hiking', 'Picnicking'],
      openingHours: '11:00 AM – 8:00 PM (June–Sept)',
      admissionFee: 'Free entry / ride tickets extra',
      isIndigenousSite: false,
      bestTimeToVisit: 'July weekends when all rides are running.',
      parkingInfo: 'Free large lot at the entrance.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3194,
      longitude: -89.2856,
    ),

    // ============ 20. Boulevard Lake Park ============
    const Attraction(
      id: 'attr_020',
      name: 'Boulevard Lake Park',
      shortDescription:
          'A peaceful in-city lake for paddling, picnics, and shoreline walks.',
      fullDescription:
          'Boulevard Lake is a dammed section of the Current River that became a city park in the 1900s. A 4 km loop trail circles the water, passing a beach, fishing spots, and a historic bandshell. Canoe and paddleboard rentals are available in summer.',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/boulevard_lake.jpg',
      galleryImages: const [],
      rating: 4.3,
      reviewCount: 540,
      estimatedVisitMinutes: 90,
      category: AttractionCategory.waterfront,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Walking', 'Cycling', 'Canoeing', 'Fishing', 'Picnicking'],
      openingHours: '6:00 AM – 11:00 PM',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Calm summer mornings for glassy water reflections.',
      parkingInfo: 'Several free lots around the lake.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.4300,
      longitude: -89.2200,
    ),

    // ============ 21. Mount Baldy Ski Area ============
    const Attraction(
      id: 'attr_021',
      name: 'Mount Baldy Ski Area',
      shortDescription:
          'Thunder Bay\'s highest vertical (770ft) with 14 runs and night skiing.',
      fullDescription:
          'A locally-run ski hill with 14 runs and Thunder Bay\'s highest vertical (770 ft). Excellent powder, terrain park, and night skiing. Less crowded than Loch Lomond and well-loved by Lakehead students.',
      imageUrl:
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/mount_baldy.jpg',
      galleryImages: const [],
      rating: 4.5,
      reviewCount: 412,
      estimatedVisitMinutes: 240,
      category: AttractionCategory.nature,
      bestSeasons: const [Season.winter],
      activities: const ['Skiing', 'Snowboarding', 'Night skiing', 'Terrain park'],
      openingHours: '9:00 AM – 9:00 PM (Dec–Mar)',
      admissionFee: '\$50 adult day pass',
      isIndigenousSite: false,
      bestTimeToVisit: 'Friday nights for the lit terrain park.',
      parkingInfo: 'Free lot at the chalet.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.5667,
      longitude: -89.0500,
    ),

    // ============ 22. Founders' Museum & Pioneer Village ============
    const Attraction(
      id: 'attr_022',
      name: 'Founders\' Museum & Pioneer Village',
      shortDescription:
          'Reconstructed pioneer village with 25 historic buildings.',
      fullDescription:
          'A reconstructed pioneer village with 25 historic buildings — schoolhouse, church, blacksmith shop, and farmhouses — recreating life in 1910 Northern Ontario.',
      imageUrl:
          'https://images.unsplash.com/photo-1518736114810-3f3bedfec66a?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/founders_museum.jpg',
      galleryImages: const [],
      rating: 4.4,
      reviewCount: 198,
      estimatedVisitMinutes: 120,
      category: AttractionCategory.history,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['History tours', 'Demonstrations', 'Family activities'],
      openingHours: '10:00 AM – 5:00 PM (June–Sept)',
      admissionFee: '\$10 adult / \$5 child',
      isIndigenousSite: false,
      bestTimeToVisit: 'Heritage Days in August.',
      parkingInfo: 'Free on-site parking.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.5028,
      longitude: -89.2389,
    ),

    // ============ 23. International Friendship Gardens ============
    const Attraction(
      id: 'attr_023',
      name: 'International Friendship Gardens',
      shortDescription:
          '110-acre multicultural garden with pavilions from 16 nations.',
      fullDescription:
          'A 110-acre garden celebrating Thunder Bay\'s ethnic communities with pavilions and landscapes representing 16 nations. Beautiful walking paths and summer cultural festivals.',
      imageUrl:
          'https://images.unsplash.com/photo-1490750967868-88aa4486c946?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/friendship_gardens.jpg',
      galleryImages: const [],
      rating: 4.5,
      reviewCount: 287,
      estimatedVisitMinutes: 75,
      category: AttractionCategory.culture,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Walking', 'Cultural learning', 'Festivals'],
      openingHours: 'Dawn to dusk',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Folklore Festival in early July.',
      parkingInfo: 'Free lot at the Victoria Avenue entrance.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3953,
      longitude: -89.2517,
    ),

    // ============ 24. Silver Islet ============
    const Attraction(
      id: 'attr_024',
      name: 'Silver Islet',
      shortDescription:
          'Historic 1870s silver mining village at the tip of the Sibley Peninsula.',
      fullDescription:
          'A historic 1870s silver mining village at the tip of the Sibley Peninsula. Once the richest silver mine in the world, now a postcard-perfect cottage community with the famous General Store still operating.',
      imageUrl:
          'https://images.unsplash.com/photo-1520637836862-4d197d17c55a?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/silver_islet.jpg',
      galleryImages: const [],
      rating: 4.7,
      reviewCount: 356,
      estimatedVisitMinutes: 120,
      category: AttractionCategory.history,
      bestSeasons: const [Season.summer, Season.fall],
      activities: const ['Sightseeing', 'General store visit', 'Photography'],
      openingHours: 'Village always open / Store 10 AM – 6 PM seasonal',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'August evenings — golden light on the islet ruins.',
      parkingInfo: 'Free street parking in the village.',
      isWheelchairAccessible: true,
      isFamilyFriendly: true,
      latitude: 48.3206,
      longitude: -88.7917,
    ),

    // ============ 25. Lake Superior Shoreline Lookout ============
    const Attraction(
      id: 'attr_025',
      name: 'Lake Superior Shoreline Lookout',
      shortDescription:
          'Dramatic clifftop sunset viewpoint along Highway 17 east.',
      fullDescription:
          'Dramatic clifftop viewpoints along Highway 17 east of Thunder Bay, overlooking the world\'s largest freshwater lake. Best at sunset when the basalt cliffs glow amber and the horizon stretches forever.',
      imageUrl:
          'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=1280&q=80&auto=format&fit=crop',
      localImagePath: 'assets/images/attractions/superior_lookout.jpg',
      galleryImages: const [],
      rating: 4.6,
      reviewCount: 234,
      estimatedVisitMinutes: 60,
      category: AttractionCategory.waterfront,
      bestSeasons: const [Season.spring, Season.summer, Season.fall],
      activities: const ['Sightseeing', 'Photography', 'Sunset viewing'],
      openingHours: 'Open 24 hours',
      admissionFee: 'Free',
      isIndigenousSite: false,
      bestTimeToVisit: 'Sunset for amber-glow cliffs.',
      parkingInfo: 'Gravel pull-off along Highway 17.',
      isWheelchairAccessible: false,
      isFamilyFriendly: true,
      latitude: 48.6500,
      longitude: -88.4000,
    ),
  ];

  static List<Restaurant> get restaurants => [
        ...RestaurantsDataPart1.restaurants,
        ...RestaurantsDataPart2.restaurants,
      ];
}