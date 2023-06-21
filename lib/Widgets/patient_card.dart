import 'package:flutter/material.dart';

class PatientCard extends StatefulWidget {
  final Color? color;
  final String nom;
  final String prenom;
  final String title;

  final String phone;
  // final String vaccin;
  const PatientCard({
    Key? key,
    this.color,
    required this.nom,
    required this.prenom,
    required this.title,
    required this.phone,
  }) : super(key: key);

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  // String font = 'JetBrainsMono';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage('assetName')),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Colors.lightBlue,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.lightBlue[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 12),
          FieldSet(
            title: 'Nom',
            content: widget.nom,
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          FieldSet(
            title: 'Prenom',
            content: widget.prenom,
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
          FieldSet(
            title: 'Numero de téléphone',
            content: '+222 ${widget.phone}',
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
        ],
      ),
    );

    // } else {
    // return Scaffold(
    //   body: Center(
    //     child: Text(state.toString()),
    //   ),
    // );
  }
  // },
  // );
  // );
}

class FieldSet extends StatelessWidget {
  String? title;
  String? content;
  double? sizeText;
  FieldSet({
    Key? key,
    this.title,
    this.content,
    this.sizeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: TextStyle(
            color: Colors.lightBlue[500],
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          content ?? '',
          style: TextStyle(
            fontSize: sizeText ?? 30,
            // color: Colors.white,
          ),
        ),
      ],
    );
  }
}
