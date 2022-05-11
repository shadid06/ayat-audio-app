import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ayat/widgets/custom_text.dart';
import 'package:ayat/widgets/music_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  Audio? selectedAudio;
  bool isNavShow = false;
  int globalIndex = 0;
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
    setupPlaylist();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  void setupPlaylist() async {
    audioPlayer.open(Playlist(audios: audioList, startIndex: globalIndex),
        showNotification: true, autoStart: false);
  }

  playMusic() async {
    await audioPlayer.play();
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  skipPrevious() async {
    await audioPlayer.previous();
  }

  skipNext() async {
    await audioPlayer.next();
    globalIndex++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Container(
              //   height: 125,
              //   child: ListView.builder(
              //       itemCount: audioList.length,
              //       scrollDirection: Axis.horizontal,
              //       shrinkWrap: true,
              //       itemExtent: 125,
              //       physics: ScrollPhysics(),
              //       itemBuilder: (context, index) {
              //         return MusicCard(
              //           containerHeight: 125,
              //             containerWidth: 90,
              //           title: audioList[index].metas.title,
              //           lebel: audioList[index].metas.artist,
              //           imageUrl: ,
              //         );
              //       }),
              // ),
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
                              itemBuilder: (context, globalIndex) {
                                return GestureDetector(
                                  onTap: () {
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
                                          audioList[globalIndex].metas.id!,
                                          height: 130,
                                          width: 110,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(audioList[globalIndex]
                                            .metas
                                            .title!),
                                        Text(audioList[globalIndex]
                                            .metas
                                            .artist!),
                                        Text(audioList[globalIndex]
                                            .metas
                                            .album!),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     IconButton(
                      //         iconSize: 50,
                      //         icon: Icon(Icons.skip_previous_rounded),
                      //         onPressed: () => skipPrevious()),
                      //     IconButton(
                      //         iconSize: 50,
                      //         icon: Icon(isPlaying
                      //             ? Icons.pause_rounded
                      //             : Icons.play_arrow_rounded),
                      //         onPressed: () =>
                      //             isPlaying ? pauseMusic() : playMusic()),
                      //     IconButton(
                      //         iconSize: 50,
                      //         icon: Icon(Icons.skip_next_rounded),
                      //         onPressed: () =>

                      //          skipNext()

                      //         )
                      //   ],
                      // ),
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
                return Container(
                  height: 50,
                  color: Colors.redAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                );
              }));
  }
}
