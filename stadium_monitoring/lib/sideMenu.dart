import 'package:flutter/material.dart';


Widget contentDrawer(BuildContext context){
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 50),
      Container(
        width: 240,
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFE9E9E9),
          border: null,
          borderRadius: BorderRadius.circular(3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 11),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'O app "Monitoramento Inteligente" é um aplicativo projetado para conectar os usuários aos dispositivos inteligentes dentro de ambientes. Com ele, os usuários podem controlar dispositivos, como alto-falantes, luzes e telas, diretamente de seus smartphones.',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
          ),
        ),
      ),
      const SizedBox(height: 30),
      Container(
        width: 240,
        height: 210,
        decoration: BoxDecoration(
          color: const Color(0xFFE9E9E9),
          border: null,
          borderRadius: BorderRadius.circular(3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, 11),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Legenda',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            legendItem('assets/images/Alarm_0.png', 'Sensor Desativado'),
            const SizedBox(height: 8),
            legendItem('assets/images/Alarm_1.png', 'Sem perigo'),
            const SizedBox(height: 8),
            legendItem('assets/images/Alarm_2.png', 'Perigo'),
          ],
        ),
      ),
    ],
  );
}

Widget legendItem(String imagePath, String text) {
  return Container(
    width: 220,
    height: 45,
    decoration: const BoxDecoration(
      color: Colors.white,
      border: null,
    ),
    child: Row(
      children: [
        const SizedBox(width: 15),
        Image.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}