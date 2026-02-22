const String _linkedIn = 'https://www.linkedin.com/in/mwinter02/';
const String _emailAddress = 'marcuswinter2002@gmail.com';

final Uri linkedInLaunchUri = Uri.parse(_linkedIn);

final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: _emailAddress,
);