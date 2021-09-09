import 'package:flutter/cupertino.dart';

class ParentProblem{
  dynamic parent;
  dynamic child;

  ParentProblem({
    this.parent,this.child
  });

  factory ParentProblem.fromJson(Map<String, dynamic> json) {
    return ParentProblem(
      parent: json['parent'] as dynamic,
      child: json['child'] as dynamic,
    );
  }


}