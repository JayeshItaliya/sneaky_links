import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Attachments extends StatefulWidget {
  String url;
  Attachments(this.url);

  @override
  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  bool audio = true;

  final audioPlayer = AudioPlayer();
  bool isloading = true;
  bool isPlaying = false;
  bool isText = true;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;

        isloading=false;
        print("++++++++++++duration"+duration.toString());
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;

      });
    });

  }
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if(duration.inHours>0)hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Container(
        // height: MediaQuery.of(context)
        //     .size
        //     .height *
        //     0.1,
        width: MediaQuery.of(context)
            .size
            .width *
            0.65,
        padding: EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(30),
          color: Colors.transparent,
        ),
        child: Row(
          children: [

            Padding(
              padding:
              const EdgeInsets.only(
                  right: 0.0,
                  top: 2,
                  bottom: 8,
                  left: 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  // isloading?Align(
                  //     alignment:Alignment.bottomLeft,
                  //     child: SizedBox(
                  //       height: 20.0,
                  //       width: 20.0,
                  //       child: CircularProgressIndicator(
                  //
                  //         color: Colors.white,
                  //         strokeWidth: 4,
                  //
                  //       ),
                  //     )):
                  isPlaying?
                  IconButton(
                    icon: Icon(
                      Icons.pause,
                    ), // Icon
                    iconSize: 37,
                    color: Colors.white,
                    onPressed: () async {
                      await audioPlayer
                          .pause();
                      setState(() {
                        isPlaying=!isPlaying;
                        print(isPlaying);


                      });
                      print("IsPLayiong1");

                    },
                  ):
                  IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                    ),
                    // Icon
                    iconSize: 37,
                    color: Colors.white,
                    onPressed: () async {

                      setState(() {
                        isText = false;
                        isPlaying=!isPlaying;
                        print(isPlaying);

                        print("IsPLaying");
                        print(duration);
                      });
                      print("true"+widget.url);
                      String url =widget.url;
                      await audioPlayer
                          .play(url);
                      print("true1");
                    },

                  ),
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                        left: 30.0,
                        top: 0),
                    child: Align(
                      alignment: Alignment
                          .centerRight,
                      child: Column(
                        children: [
                          Slider(
                            activeColor: Colors
                                .white,
                            inactiveColor:
                            Colors
                                .white,
                            min: 0,

                            max: duration
                                .inSeconds
                                .toDouble(),
                            value: position
                                .inSeconds
                                .toDouble(),
                            onChanged:
                                (value) async {
                              print( "hey audio");
                              print(audioPlayer.getDuration());
                              // audioPlayer.onDurationChanged.listen((Duration duration) {
                              //   print('max duration: ${duration.inSeconds}');
                              // });

                              position =
                              Duration(
                                  seconds:
                                  value.toInt());
                              await audioPlayer
                                  .seek(
                                  position);

                              /// Optional:Play audio if was paused
                              await audioPlayer.resume();

                              setState(() {
                                isPlaying=true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets
                        .only(
                        top:40,
                        left: 48),
                    child: Align(
                      alignment: Alignment
                          .bottomLeft,
                      child: isText
                          ? Text(
                        "${formatTime(duration)}",
                        style:
                        TextStyle(
                          fontSize:
                          16,
                          color: Colors
                              .white,
                        ),
                      )
                          : Text(
                        "${formatTime(position)}",
                        style:
                        TextStyle(
                          fontSize:
                          16,
                          color: Colors
                              .white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      )
    );
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}




