
class AppSetting{
  final int id;
  String type;
  String value;

  AppSetting({this.id,this.type,this.value});

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      "id":id,
      'type':type,
      'value':value,
    };
  }

}