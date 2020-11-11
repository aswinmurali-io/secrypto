import 'package:flutter/material.dart';
import 'package:secrypto/partials/accessibility.dart';

class SecryptoTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
  final Function onChanged;
  final Function suffixIconOnTap;
  final TextEditingController controller;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final Iterable<String> autofillHints;

  const SecryptoTextField(
      {Key key,
      this.hintText,
      this.prefixIconData,
      this.suffixIconData,
      this.obscureText,
      this.onChanged,
      this.suffixIconOnTap,
      this.controller,
      this.validator,
      this.keyboardType,
      this.autofillHints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        onTap: () async => await msgAccesiblity("Textbox selected!"),
        controller: controller,
        style: TextStyle(fontSize: 14.0),
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: Icon(prefixIconData, size: 18),
          filled: true,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          suffixIcon: GestureDetector(
              onTap: suffixIconOnTap,
              child: Icon(
                suffixIconData,
                size: 18,
                color: Colors.blue,
              )),
        ),
        onChanged: onChanged,
        keyboardType: keyboardType,
      ),
    );
  }
}
