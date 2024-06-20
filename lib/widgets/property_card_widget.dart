// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PropertyCard extends StatelessWidget {
  final String imagesUrl;
  final String title;
  final String region;
  final String address;
  String? description;
  final int price;
  final int rooms;
  final int bathroom;
  int? floor;
  final int squareMeters;
  int? monthsLease;
  final VoidCallback onTap;
  // final id;

  PropertyCard({
    super.key,
    // required this.id,
    required this.imagesUrl,
    required this.title,
    required this.address,
    required this.region,
    required this.price,
    required this.rooms,
    required this.bathroom,
    required this.squareMeters,
    required this.onTap,
    this.monthsLease,
    this.description,
    this.floor,
    required onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagesUrl.isNotEmpty)
              Image.network(
                imagesUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(26, 147, 192, 1),
                      ),
                      Expanded(
                        child: Text(
                          '$address - $region',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${price.toString()} Euro',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (price < 1000)
                              const TextSpan(
                                text: '/luna',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bathtub,
                                  color: Color.fromRGBO(26, 147, 192, 1)),
                              const SizedBox(width: 3),
                              Text(bathroom.toString(),
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              const Icon(Icons.bed,
                                  color: Color.fromRGBO(26, 147, 192, 1)),
                              const SizedBox(width: 3),
                              Text(rooms.toString(),
                                  style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Row(children: [
                            const Icon(Icons.square_foot,
                                color: Color.fromRGBO(26, 147, 192, 1)),
                            const SizedBox(width: 3),
                            Text('${squareMeters.toString()}m²',
                                style: const TextStyle(color: Colors.grey)),
                          ])
                        ],
                      ),
                    ],
                  ),
                  if (description != null && description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        description!,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                        maxLines: null,
                        softWrap: true,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
