import 'package:flutter/material.dart';

class ActivitiesSection extends StatefulWidget {
  final List<Map<String, dynamic>> thingsToDo;

  const ActivitiesSection({super.key, required this.thingsToDo});

  @override
  State<ActivitiesSection> createState() => _ActivitiesSectionState();
}

class _ActivitiesSectionState extends State<ActivitiesSection> {
  int? _currentlyExpandedIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (widget.thingsToDo.isEmpty) return SizedBox.shrink();
    return ExpansionPanelList(
      elevation: 0,
      materialGapSize: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _currentlyExpandedIndex = isExpanded ? panelIndex : null;
        });
      },
      children: List.generate(widget.thingsToDo.length, (index) {
        final thing = widget.thingsToDo[index];
        final hasContent =
            thing['content'] != null &&
            thing['content'] is List &&
            (thing['content'] as List).isNotEmpty;
        final expanded = hasContent && _currentlyExpandedIndex == index;
        final hasSubtitle =
            thing['subtitle'] != null && thing['subtitle'].isNotEmpty;
        return ExpansionPanel(
          canTapOnHeader: hasContent,
          isExpanded: expanded,
          backgroundColor: expanded
              ? Colors.blueGrey.shade100
              : Colors.transparent,
          headerBuilder: (context, isExpanded) => ListTile(
            contentPadding: EdgeInsets.only(
              right: 0,
              left: 8,
              top: hasSubtitle ? 0 : 8,
              bottom: hasSubtitle ? 2 : 8,
            ),
            title: Text(thing['title'] ?? '', style: TextStyle(fontSize: 14)),
            subtitle: !expanded && hasSubtitle
                ? Text(
                    thing['subtitle'],
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  )
                : null,
            trailing:
                (thing['badge'] != null &&
                    (thing['badge'] as String).isNotEmpty)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        constraints: BoxConstraints(maxWidth: size.width * 0.4),
                        decoration: BoxDecoration(
                          color: Color(0xFFE6E6EB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          thing['badge'],
                          style: TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          body: hasContent
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 12,
                    top: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...((thing['content'] as List?)
                              ?.expand(
                                (itemList) => itemList is List ? itemList : [],
                              )
                              .map<Widget>(
                                (item) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 6,
                                        right: 8,
                                      ),
                                      child: Icon(
                                        Icons.circle,
                                        size: 7,
                                        color: Colors.blueGrey.shade200,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          item['text'] ?? '',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList() ??
                          []),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        );
      }),
    );
  }
}
