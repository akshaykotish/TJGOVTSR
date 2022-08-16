
class EncylopediaDatas{
  static List<EncylopediaData> encylopediaDatas = <EncylopediaData>[];
}


class EncylopediaData{
  String Name = "";
  String URL = "";
  String Details = "";

  EncylopediaData(String name, String url, String details)
  {
    Name = name;
    URL = url;
    Details = details;
  }
}