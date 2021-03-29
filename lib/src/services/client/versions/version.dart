class AppVersion {
  final int major;
  final int minor;
  final int patch;

  AppVersion._(this.major, this.minor, this.patch);

  factory AppVersion.fromString(String version) {
    var parsed = version.split(".");
    if(parsed.length > 3 || parsed.length < 3)
      throw "Version should be in the form of MAJOR.MINOR.patch ";
    return new AppVersion._(
      int.parse(parsed[0]), 
      int.parse(parsed[1]), 
      int.parse(parsed[2])
    );
  }

  isLowerOrEqual(AppVersion other) => major < other.major 
      || major == other.major && minor <= other.minor; 

  isLower(AppVersion other) => major < other.major 
      || major == other.major && minor < other.minor;     

  bool isEqual(AppVersion other) 
    => major == other.major && minor == other.minor;

  isGreaterOrEqual(AppVersion other) => major > other.major 
      || major == other.major && minor >= other.minor; 

  isGreater(AppVersion other) => major > other.major 
    || major == other.major && minor > other.minor; 

  bool operator ==(other) => other is AppVersion && other.isEqual(this);

  @override
  int get hashCode => major.hashCode ^ minor.hashCode ^ patch.hashCode;

}