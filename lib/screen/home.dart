import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ayat/widgets/custom_text.dart';
import 'package:ayat/widgets/loop_controll.dart';
import 'package:ayat/widgets/music_card.dart';
import 'package:ayat/widgets/position_seek_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Audio? selectedAudio;
  bool isNavShow = false;
  int globalIndex = 0;
  Random rnd = new Random();
  bool isShuffle = false;
  bool isLoop = false;
  LoopMode? loopMode;
  List<Audio> audioList = [
    Audio.network(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
        metas: Metas(
            title: 'Song1',
            artist: 'Artist1',
            album: 'album1',
            //: MetasImage.network("assets/images/country.jpg"),
            id: 'https://thumbs.dreamstime.com/b/environment-earth-day-hands-trees-growing-seedlings-bokeh-green-background-female-hand-holding-tree-nature-field-gra-130247647.jpg')),
    Audio.network(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
        metas: Metas(
            title: 'Song2',
            artist: 'Artist2',
            album: 'album1',
            id: 'https://tinypng.com/images/social/website.jpg')),
    Audio.network(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
        metas: Metas(
            title: 'Song3',
            artist: 'Artist3',
            album: 'album1',
            id: 'https://static.addtoany.com/images/dracaena-cinnabari.jpg')),
  ];
  @override
  void initState() {
    super.initState();
    audioPlayer.playlistAudioFinished.listen(
      (event) {
        print('playlistAudioFinished : $event');

        if (globalIndex == (audioList.length - 1)) {
          globalIndex = 0;
          setState(() {});
          selectedAudio = audioList[globalIndex];
          setState(() {});
        } else if (globalIndex < audioList.length - 1) {
          globalIndex++;
          setState(() {});
          selectedAudio = audioList[globalIndex];
          setState(() {});
        }
      },
    );

    setupPlaylist();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void setupPlaylist() async {
    audioPlayer.open(
      Playlist(audios: audioList),
      notificationSettings: NotificationSettings(
        customPrevAction: (player) {
          if (globalIndex > 0) {
            globalIndex--;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
            player.playlistPlayAtIndex(globalIndex);
            setState(() {});
          } else if (globalIndex == 0) {
            globalIndex = audioList.length - 1;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
            // player.previous(keepLoopMode: false);
            player.playlistPlayAtIndex(globalIndex);
            setState(() {});
          }
        },
        customNextAction: (player) {
          if (globalIndex == (audioList.length - 1)) {
            globalIndex = 0;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
          } else if (globalIndex < audioList.length - 1) {
            globalIndex++;
            setState(() {});
            selectedAudio = audioList[globalIndex];
            setState(() {});
          }
          player.next();
        },
      ),
      showNotification: true,
      autoStart: false,
      // loopMode: isLoop == true ? LoopMode.single : LoopMode.none
    );
  }

  playMusic() async {
    // await audioPlayer.play();
    await audioPlayer.playlistPlayAtIndex(globalIndex);
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    await audioPlayer.previous();
    // await audioPlayer.prev();
  }

  skipNext() async {
    await audioPlayer.next(keepLoopMode: true);
    // globalIndex++;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child:
                    audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                  return Column(
                    children: [
                      Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              itemCount: audioList.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemExtent: 125,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    globalIndex = index;
                                    selectedAudio = audioList[globalIndex];
                                    isNavShow = true;
                                    setState(() {});
                                    isPlaying ? pauseMusic() : playMusic();
                                  },
                                  child: Container(
                                    height: 100,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          audioList[index].metas.id!,
                                          height: 130,
                                          width: 110,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(audioList[index].metas.title!),
                                        Text(audioList[index].metas.artist!),
                                        Text(audioList[index].metas.album!),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              iconSize: 50,
                              icon: Icon(Icons.skip_previous_rounded),
                              onPressed: () => skipPrevious()),
                          IconButton(
                              iconSize: 50,
                              icon: Icon(isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded),
                              onPressed: () =>
                                  isPlaying ? pauseMusic() : playMusic()),
                          IconButton(
                              iconSize: 50,
                              icon: Icon(Icons.skip_next_rounded),
                              onPressed: () {
                                globalIndex++;
                                selectedAudio = audioList[globalIndex];

                                setState(() {});
                                skipNext();
                              })
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isNavShow == false
            ? Container(
                height: 50,
              )
            : audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        useRootNavigator: true,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: buildPlayer(),
                          );
                        });
                  },
                  child: Container(
                    height: 50,
                    color: Colors.redAccent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.network(
                                // selectedMuisc!.imageUrl,
                                selectedAudio!.metas.id!,
                                height: 50,
                                width: 40,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  // text: selectedMuisc!.title,
                                  text: selectedAudio!.metas.title,
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  // text: selectedMuisc!.lebel,
                                  text: selectedAudio!.metas.artist!,
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // audioPlayerState == PlayerState.PLAYING
                                //     ? pauseMusic()
                                //     : playMusic();
                                isPlaying ? pauseMusic() : playMusic();
                              },
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     // audioPlayerState == PlayerState.PLAYING
                            //     //     ? pauseMusic()
                            //     //     : playMusic();
                            //     skipNext();
                            //     selectedAudio;
                            //     setState(() {});
                            //   },
                            //   child: Icon(
                            //     Icons.skip_next_rounded,
                            //     color: Colors.white,
                            //     size: 30,
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }));
  }

  Widget buildPlayer() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return StatefulBuilder(
      builder: ((context, setState) {
        return audioPlayer.builderIsPlaying(builder: (context, isPlaying) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              elevation: 0.0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 26,
                  )),
              title: Column(
                children: [
                  CustomText(
                    text: selectedAudio!.metas.title,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  CustomText(
                    text: selectedAudio!.metas.artist,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: 26,
                  ),
                )
              ],
            ),
            body: SafeArea(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.network(
                    selectedAudio!.metas.id!,
                    height: height * 0.4,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: selectedAudio!.metas.title,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomText(
                            text: selectedAudio!.metas.artist,
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            size: 30,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      audioPlayer.builderRealtimePlayingInfos(
                          builder: ((context, infos) {
                        return Text(
                          infos.currentPosition.inSeconds < 60
                              ? '00:${infos.currentPosition.inSeconds}'
                              : '${(infos.currentPosition.inSeconds / 60).toInt()} : ${(infos.currentPosition.inSeconds % 60).toInt()}',
                          style: TextStyle(color: Colors.white),
                        );
                      })),
                      Container(
                        width: 250,
                        child: audioPlayer.builderRealtimePlayingInfos(
                          builder: (context, infos) {
                            return PositionSeekWidget(
                              currentPosition: infos.currentPosition,
                              duration: infos.duration,
                              seekTo: (to) {
                                audioPlayer.seek(to);
                              },
                            );
                          },
                        ),
                      ),
                      audioPlayer.builderRealtimePlayingInfos(
                          builder: ((context, infos) {
                        int minute = (infos.duration.inSeconds / 60).toInt();
                        int reminder = (infos.duration.inSeconds % 60);
                        return Text(
                          // infos.duration.inMinutes.toString(),
                          '${minute.toString()} : $reminder',
                          style: TextStyle(color: Colors.white),
                        );
                      })),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            // if (isShuffle == false) {
                            //   isShuffle = true;

                            //   int randomIndex =
                            //       rnd.nextInt((audioList.length - 1) - 0);
                            //   globalIndex = randomIndex;
                            //   setState(() {});
                            //   selectedAudio = audioList[globalIndex];
                            //   playMusic();
                            //   setState(() {});
                            // } else {
                            //   isNavShow = false;
                            //   setState(() {});
                            // }
                          },
                          icon: Icon(Icons.shuffle,
                              size: 28,
                              color: isShuffle == false
                                  ? Colors.white
                                  : Colors.blueGrey)),
                      IconButton(
                          onPressed: () {
                            if (globalIndex > 0) {
                              globalIndex--;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                              audioPlayer.playlistPlayAtIndex(globalIndex);
                              setState(() {});
                            } else if (globalIndex == 0) {
                              globalIndex = audioList.length - 1;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                              // player.previous(keepLoopMode: false);
                              audioPlayer.playlistPlayAtIndex(globalIndex);
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            size: 34,
                            color: Colors.white,
                          )),
                      GestureDetector(
                        onTap: () {
                          // audioPlayerState == PlayerState.PLAYING
                          //     ? pauseMusic()
                          //     : playMusic();
                          // setState(() {});
                          isPlaying ? pauseMusic() : playMusic();
                        },
                        child: Icon(
                          // audioPlayerState == PlayerState.PLAYING
                          isPlaying
                              ? Icons.pause_circle_filled_outlined
                              : Icons.play_circle_fill_outlined,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // audioPlayerState == PlayerState.PLAYING
                          //     ? pauseMusic()
                          //     : playMusic();
                          // setState(() {});
                          audioPlayer.stop();
                        },
                        child: Icon(
                          // audioPlayerState == PlayerState.PLAYING
                          Icons.stop_sharp,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (globalIndex == (audioList.length - 1)) {
                              globalIndex = 0;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                            } else if (globalIndex < audioList.length - 1) {
                              globalIndex++;
                              setState(() {});
                              selectedAudio = audioList[globalIndex];
                              setState(() {});
                            }
                            skipNext();
                          },
                          icon: Icon(
                            Icons.skip_next,
                            size: 34,
                            color: Colors.white,
                          )),

                      audioPlayer.builderLoopMode(builder: (context, loop) {
                        return PlayerBuilder.isPlaying(
                            player: audioPlayer,
                            builder: (context, isPlaying) {
                              return LoopControll(
                                loopMode: loop,
                                toggleLoop: () {
                                  audioPlayer.toggleLoop();
                                },
                              );
                            });
                      }),
                      // IconButton(
                      //     onPressed: () {

                      //       // if (isLoop == false) {
                      //       //   isLoop = true;
                      //       //   setState(() {});
                      //       //   audioPlayer.setLoopMode(LoopMode.single);
                      //       //   audioPlayer.toggleLoop();
                      //       // } else {
                      //       //   isLoop = false;
                      //       //   setState(() {});
                      //       // }
                      //     },
                      //     icon: Icon(
                      //       Icons.loop_outlined,
                      //       size: 28,
                      //       color: isLoop == false
                      //           ? Colors.white
                      //           : Colors.blueGrey,
                      //     )),
                    ],
                  )
                ],
              ),
            )),
          );
        });
      }),
    );
  }
}
