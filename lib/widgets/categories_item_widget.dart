import 'package:flutter/material.dart';
import '../data/models/categoties_model.dart';
import '../pages/robots_by_category_page.dart';

Widget CategoryItemWidget({required BuildContext context, required CategoriesModel item}){
  return GestureDetector(
    onTap: () {
      print('Selected Category: ${item.category_id}');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RobotsByCategoryPage(
              category_id: item.category_id,
            )),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade600),
        color: Colors.grey.shade800,
      ),
      child: Column(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(16),
          //   //child: Image.network(item.lf_photo),
          //   child: Image.network(
          //       'https://images.ctfassets.net/cnu0m8re1exe/6fVCq8MwHs552WbNadncGb/1bd5a233597acb5485c691c8110270b2/shutterstock_710379334.jpg?fm=jpg&fl=progressive&w=660&h=433&fit=fill'),
          // ),
          Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category_name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.category_description.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      item.category_rules,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                  Icon(Icons.arrow_right)
              ]
            ),
          )
        ],
      ),
    ),
  );
}