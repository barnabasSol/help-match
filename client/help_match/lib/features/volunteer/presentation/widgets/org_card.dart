import 'package:flutter/material.dart';
 
class OrganizationCard extends StatelessWidget {
  final String orgName;
  final String type;
  final String imageUrl;
  final bool isVerified;
  final String baseURL = "https://hm.barney-host.site/";
  const OrganizationCard(
      {super.key,
      required this.orgName,
      required this.type,
      required this.imageUrl,
      required this.isVerified});

  @override
  Widget build(BuildContext context) {                                                                                                        
    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 200,
          height: 400,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity, // Ensures it respects the parent size
                height: double.infinity,
                child: Image.network(
                'https://th.bing.com/th/id/OIP.uL9scGt9_A3laD6BiiUrFQAAAA?rs=1&pid=ImgDetMain',
                  headers: const {
                    'Authorization':
                        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImRhZ2kiLCJyb2xlIjoidXNlciIsImlzcyI6Imh0dHBzOi8vaG0uYmFybmV5LWhvc3Quc2l0ZSIsInN1YiI6IjNkNjc0MWFhLWU4NTQtMTFlZi1hZjgwLTNiMGZlNjg0MDZkMSIsImF1ZCI6WyJjb20uYmFybmV5LWhvc3QuaG0iXSwiZXhwIjoxNzQwNzI2MDc5LCJpYXQiOjE3NDAzMDM2Mzl9.gotqoKq74bxAqYPLL6f3puiGcYbdmxigNNcu06Bi4VE',
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  fit: BoxFit
                      .fill, // Ensures it fills without breaking aspect ratio
                ),
              ),
              Positioned(
                  left: 6,
                  top: 3,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: Text(
                        type,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 248, 248, 248),
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                  )),
              Positioned(
                  right: 4,
                  top: 5,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.bookmark,
                        color: Colors.white,
                      ),
                    ),
                  )),
              Positioned(
                left: 0,
                right: 0, // Ensures it takes full width
                bottom: 0, // Starts from this Positioned to the end of Stack
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.87),
                  ),
                  child: Row(
                    children: [
                      Text(
                        orgName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
