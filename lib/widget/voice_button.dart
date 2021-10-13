import 'package:flutter/material.dart';
import '../provider/utils.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({Key? key}) : super(key: key);
  static const routeName = '/voicePage';

  @override
  _VoiceButtonState createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  SpeechToText? _speech;
  bool _isListening = false;
  String _text = "";

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: Text('Edith Voice Page',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0)),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      backgroundColor: Colors.deepPurple[200],
      floatingActionButton: AvatarGlow(
        startDelay: Duration(milliseconds: 1000),
        glowColor: Colors.deepPurple,
        endRadius: 45.0,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        // showTwoGlows: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          backgroundColor: Colors.deepPurple[300],
          hoverColor: Colors.teal[100],
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Text('Voice',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0)),
                    SizedBox(width: 10.0),
                    Text('Command',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize: 25.0)),
                    SizedBox(width: 60.0),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title:
                                    Text('Guidence for using voice commands'),
                                content: Container(
                                  height: 120,
                                  child: Column(
                                    children: [
                                      Text(
                                          "Some availble commands for now are:\n \n1) Writing Mail \n2) Opening YouTube \n3) Checking Weather"),
                                    ],
                                  ),
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok'),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: AvatarGlow(
                          startDelay: Duration(milliseconds: 1000),
                          glowColor: Colors.white,
                          endRadius: 45.0,
                          duration: Duration(milliseconds: 2000),
                          repeat: true,
                          // showTwoGlows: true,
                          repeatPauseDuration: Duration(milliseconds: 100),
                          child: Icon(Icons.note_add_outlined)),
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Kindly tap the mic button to input voice command :)',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 18.0)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: Container(
                padding: EdgeInsets.only(top: 40, left: 15),
                child: Text(
                  _text,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech!.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        if (_text.isEmpty) {
          _text = '';
        }
        setState(() {
          _isListening = true;
        });
        _speech!.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
          }),
        );
      }
    } else {
      Future.delayed(Duration(seconds: 1), () {
        Utils.scanText(_text);
      });
      setState(() {
        _isListening = false;
      });
      _speech!.stop();
    }
  }
}
