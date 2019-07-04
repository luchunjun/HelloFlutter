import 'package:json_annotation/json_annotation.dart';
class PicModel {
  PicModel(this.createdAt,this.publishedAt,this.type,this.url,this.desc);
  String createdAt;
  String publishedAt;
  String type;
  String url;
  String   desc;
}