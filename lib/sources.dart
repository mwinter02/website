
class Sources {
  Sources._();
  static const String github = 'mwinter02';
  static const String linkedIn = 'https://www.linkedin.com/in/mwinter02/';
  static const String email = 'marcuswinter2002@gmail.com';


  static final Uri linkedInLaunchUri = Uri.parse(linkedIn);
  static final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );
}

class AssetSources {
  AssetSources._();
  static const String resume = 'assets/Resume - Marcus Winter.pdf';

  static const String bannerAirobic = 'assets/images/banners/airobic.jpg';
  static const String bannerArgo = 'assets/images/banners/argo.jpg';
  static const String bannerCollider = 'assets/images/banners/collider.jpg';
  static const String bannerPacman = 'assets/images/banners/pacman.jpg';
  static const String bannerPngChaser = 'assets/images/banners/pngchaser.jpg';
  static const String bannerTerrain = 'assets/images/banners/terrainpainter.jpg';
  static const String bannerUrbanize = 'assets/images/banners/urbanize.jpg';
  static const String bannerZombies = 'assets/images/banners/zombies.jpg';

  static const String picFish = 'assets/images/fish.jpg';
  static const String picPink = 'assets/images/pink.jpg';
  static const String picProfile = 'assets/images/profile.jpg';
  static const String picGrad = 'assets/images/grad.jpg';
  static const String picRow = 'assets/images/row.jpg';
  static const String picTahoe = 'assets/images/tahoe.jpg';

}