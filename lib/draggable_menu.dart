import 'package:flutter/material.dart';

class DialogInfoRow extends StatelessWidget {
  final String bubbleText;
  final String secondText;

  DialogInfoRow(
    this.bubbleText, this.secondText,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(16.0),
            color: Colors.blueAccent,
          ),
          child: SizedBox(
            width: 120,
            child: Text(
              bubbleText,
              style: TextStyle(fontSize: 28),
              textAlign: TextAlign.center
            ),
          ),
        ),
        SizedBox(width: 15),
        Text(
          secondText,
          style: TextStyle(fontSize: 24)
        ),
      ]
    );
  }
}

class ParkDialog extends StatelessWidget {
  const ParkDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              /*DialogInfoRow("\$2.00", "Per Hour"),
              Text(
                "\$0.50 per 15 Minutes",
                style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)
              ),
              SizedBox(height: 20),

              DialogInfoRow("5 Hours", "Maximum Time"),

              Text(
                  "Parking Hours: 7am to 10pm",
                  style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline)
              ),
              SizedBox(height: 20),*/

              Text(
                "2899-2849 Dwight Way",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 100,
                        weight: 9000,
                      ),
                      SizedBox(
                        //width: 60,
                        child: Text("\$0.50 per\n15 minutes", textAlign: TextAlign.center),
                      )
                    ],
                  ),

                  Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 100,
                        weight: 9000,
                      ),
                      SizedBox(
                        //width: 60,
                        child: Text("Maximum time:\n5 Hours", maxLines: 2, textAlign: TextAlign.center),
                      )
                    ],
                  ),
                ]
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("Park", style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(color: Colors.white, fontSize: 14)
                  ),
                  onPressed: () {},
                ),
              )
            ],
          )
        ]
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
            trailing: []
          );
        }, suggestionsBuilder:
        (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {
            setState(() {
              controller.closeView(item);
            });
          },
        );
      });
    });
  }
  
}