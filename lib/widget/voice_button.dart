import 'package:flutter/material.dart';
import '../provider/utils.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({Key? key}) : super(key: key);
  static const routeName = '/voicePage';

  @override
  _VoiceButtonState createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  SpeechToText? _speech;
  bool _isListening = false;
  String _text = "Press the button and start speeking";

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
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        backgroundColor: Colors.deepPurple[300],
        hoverColor: Colors.teal[100],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: 10.0),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
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
                        fontSize: 25.0))
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 40, left: 15),
              child: _isListening
                  ? Text(
                      _text,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    )
                  : Text('Kindly tap the mic button to input voice command:)',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontSize: 18.0)),
            ),
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
