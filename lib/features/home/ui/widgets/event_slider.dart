import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:finity/blocs/event/ad_bloc.dart';
import 'package:finity/blocs/user/user_bloc.dart'; // Import UserBloc
import 'package:finity/features/home/ui/pages/event_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventSlider extends StatefulWidget {
  const EventSlider({super.key});

  @override
  State<EventSlider> createState() => _EventSliderState();
}

class _EventSliderState extends State<EventSlider> {
  @override
  @override
  void initState() {
    super.initState();

    final adBloc = context.read<AdBloc>();
    final userBloc = context.read<UserBloc>();

    // Check if the UserBloc is already loaded with a user.
    final currentState = userBloc.state;
    if (currentState is UserLoaded) {
      _fetchNearbyAds(adBloc, currentState);
    }

    // Listen to changes in UserBloc to fetch nearby ads/events
    userBloc.stream.listen((state) {
      if (state is UserLoaded) {
        _fetchNearbyAds(adBloc, state);
      }
    });
  }

  void _fetchNearbyAds(AdBloc adBloc, UserLoaded state) {
    final location = state.user.location;
    adBloc.add(FetchNearByAdEvent(
      longitude: location[0],
      latitude: location[1],
      maxDistance: 10000,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdBloc, AdState>(
      builder: (context, state) {
        if (state is AdLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AdError) {
          return Center(child: Text('Error: ${state.error}'));
        } else if (state is AdSuccess) {
          List<String> eventName =
              state.events.map((event) => event.title as String).toList();
          state.events.map((event) => event.title).toList();
          // log('Events: $eventName');
          return CarouselSlider(
            options: CarouselOptions(
              height: 190.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: state.events.map((event) {
              return Builder(
                builder: (BuildContext context) {
                  // Display the first image in the list
                  String imageUrl = event.image.isNotEmpty
                      ? event.image[0]
                      : 'https://example.com/default-image.jpg';

                  return InkWell(
                    onTap: () {
                      // Navigate to EventDetailScreen
                      Navigator.of(context).pushNamed(
                          EventDetailScreen.routeName,
                          arguments: event);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Colors.black54,
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          log('Unknown state: $state');
          return Container(
            height: 90,
            width: 90,
            color: Colors.white,
          ); // Return empty container if state is not recognized
        }
      },
    );
  }
}
