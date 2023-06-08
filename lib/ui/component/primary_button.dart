import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                DisplayDefinition.cornerRadiusSizeLarge,
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(text),
        ),
      ),
    );
  }
}
