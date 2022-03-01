class Item {
  
  final int? id;
  final String content;
  final int isCheck;

  Item({
    this.id,
    required this.content,
    this.isCheck = 0,
  });

  Item.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        content = res["content"],
        isCheck = res["isCheck"];

  Map<String, Object?> toMap() {
    return {'id':id,'content': content, 'isCheck': isCheck};
  } 
  
}