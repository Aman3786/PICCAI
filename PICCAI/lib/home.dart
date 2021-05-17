import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  String pred = "Model's  Prediction..";
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() { 
    super.initState();
    loadModel().then((value){
      setState(() {
        _loading = true;
      });
    });  
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.4,
        imageMean: 127.5,
        imageStd: 127.5,
        );

    setState(() {
      if (output.length < 1){
        _output = [{'label':'Cannot predict..'}];
        _loading = false;
      }
      else{
      _output = output;
      _loading = false;
      }
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/mobilenet.tflite',
        labels: 'assets/mobilenet_labels.txt');
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async{

    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);

  }

  pickGallery() async{

    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'PICC',
              style: GoogleFonts.abhayaLibre(
                  color: Colors.white, fontWeight: FontWeight.w900),
            ),
            Text(
              'AI',
              style: GoogleFonts.abhayaLibre(
                  color: Colors.redAccent, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('CLASSIFY IMAGE',
                    style: GoogleFonts.abhayaLibre(
                        color: Colors.redAccent,
                        fontSize: 25,
                        fontWeight: FontWeight.w600)
                  ),
                SizedBox(height: 20), //
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      _loading 
                      ? Container(
                          child: Column(children: <Widget>[
                            Image.asset('assets/no_image.jpg'),
                            SizedBox(height: 15),
                            Text(
                              pred,
                              style: GoogleFonts.abhayaLibre(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            )
                          ]),
                        )
                      : Container(

                        child: Column(children: <Widget>[
                          Container(
                            height: 250,
                            child: Image.file(_image,fit:BoxFit.cover),
                          ),
                          SizedBox(height: 15),
                            _output != null ? Container(child:Text('${_output[0]['label']}')) : Container(child:Text('Not predict..'))
                        ])

                      ),

                  ])
                ),
                SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton.icon(
                          onPressed: pickImage,
                          icon: Icon(Icons.camera_alt),
                          label: Text('Camera'),
                          color: Colors.redAccent,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.white),
                          )),
                      SizedBox(width: 13),
                      RaisedButton.icon(
                          onPressed:pickGallery,
                          icon: Icon(Icons.image),
                          label: Text('Gallery'),
                          color: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            // side: BorderSide(color: Colors.white),
                          ))
                    ]),
              ],
            ),

          )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _loading = true;
            });
          },
          backgroundColor: Colors.redAccent,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            ),
      ),
    );
  }
}