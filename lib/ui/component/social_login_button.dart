import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContinueWithTwitterButton extends StatelessWidget {
  const ContinueWithTwitterButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ContinueWithThirdPartyProviderButton(
      onPressed: onPressed,
      icon: FontAwesomeIcons.twitter,
      text: 'Twitterで続ける',
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF1DA1F2),
    );
  }
}

class ContinueWithFacebookButton extends StatelessWidget {
  const ContinueWithFacebookButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ContinueWithThirdPartyProviderButton(
      onPressed: onPressed,
      icon: FontAwesomeIcons.facebook,
      text: 'Facebookで続ける',
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF1877f2),
    );
  }
}

class ContinueWithAppleButton extends StatelessWidget {
  const ContinueWithAppleButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return _ContinueWithThirdPartyProviderButton(
      onPressed: onPressed,
      icon: FontAwesomeIcons.apple,
      text: 'Appleで続ける',
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    );
  }
}

class _ContinueWithThirdPartyProviderButton extends StatelessWidget {
  const _ContinueWithThirdPartyProviderButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.foregroundColor,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: foregroundColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
