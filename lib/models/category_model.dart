import 'package:flutter/material.dart';

import 'package:project1/utilies/app_colors.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textColor = AppColors.white,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'productsCount': productsCount});
    result.addAll({'bgColor': bgColor.toARGB32()});
    result.addAll({'textColor': textColor.toARGB32()});

    return result;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      productsCount: map['productsCount']?.toInt() ?? 0,
      bgColor: Color((map['bgColor'] as int?) ?? AppColors.primary.toARGB32()),
      textColor: Color(
        (map['textColor'] as int?) ?? AppColors.white.toARGB32(),
      ),
    );
  }
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '1',
    name: 'New Arrivals',
    productsCount: 208,
    bgColor: AppColors.grey,
    textColor: AppColors.black,
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
    bgColor: AppColors.green,
    textColor: AppColors.white,
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
    bgColor: AppColors.black,
    textColor: AppColors.white,
  ),
  CategoryModel(
    id: '4',
    name: 'Shoes',
    productsCount: 230,
    bgColor: AppColors.grey,
    textColor: AppColors.black,
  ),
  CategoryModel(
    id: '5',
    name: 'Electronics',
    productsCount: 101,
    bgColor: AppColors.blue,
    textColor: AppColors.white,
  ),
];
