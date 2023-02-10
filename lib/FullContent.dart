import 'package:flutter/material.dart';

class FullContent extends StatelessWidget {
  const FullContent({Key? key}) : super(key: key);

  static const String _title = 'Orion';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
    child: AppBar(
          title: Container(
            width: 200,
            alignment: Alignment.center,
            child: Image.asset('images/Orion.png'),
          ),
          backgroundColor: const Color(0x6FE8D298),
          elevation: 0.0,
          titleSpacing: 10.0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        ),
        body: const FullContentWidget(),
      ),
    );
  }
}

class FullContentWidget extends StatefulWidget {
  const FullContentWidget({Key? key}) : super(key: key);

  @override
  State<FullContentWidget> createState() => _FullContentWidgetState();
}

class _FullContentWidgetState extends State<FullContentWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x6FE8D298),
      child:
        Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                    child: const Text(
                      'Full Content',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Get Help',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Date: ',
                      style: TextStyle(fontSize: 17),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Time: ',
                      style: TextStyle(fontSize: 17),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Location: ',
                      style: TextStyle(fontSize: 17),
                    )),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 60,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon( // <-- Icon
                          Icons.video_camera_back_sharp,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        label: Text(''),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xA121732E),
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ), // <-- Text
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon( // <-- Icon
                          Icons.video_collection_sharp,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        label: Text(''),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xA121732E),
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),// <-- Text
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon( // <-- Icon
                          Icons.alarm_add_sharp,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        label: Text(''),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xA121732E),
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),// <-- Text
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon( // <-- Icon
                          Icons.keyboard_voice_sharp,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        label: Text(''),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xA121732E),
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),// <-- Text
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 60,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: Icon( // <-- Icon
                          Icons.add_a_photo_sharp,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        label: Text(''),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(
                                0xA121732E),
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ), // <-- Text
                      ),
                    ),
                  ],
                )
              ],
            )),
    );
  }
}