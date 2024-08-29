import 'package:carousel_slider/carousel_slider.dart';
import 'package:finity/blocs/event/ad_bloc.dart';
import 'package:finity/features/home/ui/pages/event_detail_screen.dart';
import 'package:finity/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class EventSlider extends StatefulWidget {
  const EventSlider({super.key});

  @override
  State<EventSlider> createState() => _EventSliderState();
}

class _EventSliderState extends State<EventSlider> {
  @override
  void initState() {
    super.initState();
    // Trigger the event to fetch nearby ads/events
    final adBloc = context.read<AdBloc>();
    List<double> loc =
        Provider.of<UserProvider>(context, listen: false).user.location;

    adBloc.add(FetchNearByAdEvent(
        longitude: loc[0], latitude: loc[1], maxDistance: 10000));
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
          return CarouselSlider(
            options: CarouselOptions(
              height: 190.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: state.events.map((event) {
              return Builder(
                builder: (BuildContext context) {
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
                          image: NetworkImage(event.image),
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
