class Internacional {
  String? id;
  String? name;
  String? url;
  String? picSmall;
  String? picMedium;
  String? uniques;
  String? views;
  String? rank;

  Internacional(
      {this.id,
      this.name,
      this.url,
      this.picSmall,
      this.picMedium,
      this.uniques,
      this.views,
      this.rank});

  Internacional.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    picSmall = json['pic_small'];
    picMedium = json['pic_medium'];
    uniques = json['uniques'];
    views = json['views'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['pic_small'] = this.picSmall;
    data['pic_medium'] = this.picMedium;
    data['uniques'] = this.uniques;
    data['views'] = this.views;
    data['rank'] = this.rank;
    return data;
  }
}
