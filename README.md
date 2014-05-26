DLForcedGraphView
=================

iOS and OS X implementation of [forced graph](http://en.wikipedia.org/wiki/Force-directed_graph_drawing) using SpriteKit.

Demo
-----------------
![demo](https://raw.githubusercontent.com/garnett/DLForcedGraphView/master/img/demo.gif)

Installation
-----------------
```pod 'DLForcedGraphView', '~> 0.1'```

Usage
-----------------
Add ```DLForcedGraphView``` as a subview and add graph edges to display:

```objc
NSArray *edges = @[
  DLMakeEdge(0, 1),
  DLMakeEdge(1, 2),
  DLMakeEdge(2, 0),
];

[forcedGraphView.graphScene addEdges:edges];
```
