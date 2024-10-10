import 'package:flutter/material.dart';

Widget BuildGradientButtonWidget({required String text, required VoidCallback onPressed}){
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff53dae3),
            Color(0xff297fff)
          ], // Gradiente do botão
          stops: [0.25, 0.75],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}