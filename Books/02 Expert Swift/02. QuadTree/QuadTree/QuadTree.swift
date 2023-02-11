/// Sample code from the book, Expert Swift,
/// published at raywenderlich.com, Copyright (c) 2021 Razeware LLC.
/// See LICENSE for details. Thank you for supporting our work!
/// Visit https://www.raywenderlich.com/books/expert-swift

import Foundation
import CoreGraphics.CGBase // CGPoint

struct QuadTree {
  private var root: Node
  private(set) var count = 0

  init(region: CGRect) {
    root = Node(region: region)
  }

  @discardableResult
  mutating func insert(_ point: CGPoint) -> Bool {
    if !isKnownUniquelyReferenced(&root) {
      root = root.copy()
    }
    if root.insert(point) {
      count += 1
      return true
    }
    return false
  }

  func find(in searchRegion: CGRect) -> [CGPoint] {
    root.find(in: searchRegion)
  }

  func points() -> [CGPoint] {
    find(in: root.region)
  }

  private func collectRegions(_ node: Node, into regions: inout [CGRect]) {
    regions.append(node.region)
    if let quad = node.quad {
      for child in quad.all {
        collectRegions(child, into: &regions)
      }
    }
  }

  func regions() -> [CGRect] {
    var regions: [CGRect] = []
    collectRegions(root, into: &regions)
    return regions
  }
}

private final class Node {
  let maxItemCapacity = 4
  var region: CGRect
  var points: [CGPoint] = []
  var quad: Quad?

  init(region: CGRect, points: [CGPoint] = [], quad: Quad? = nil) {
    self.region = region
    self.quad = quad
    self.points = points
    self.points.reserveCapacity(maxItemCapacity)
    precondition(points.count <= maxItemCapacity)
  }

  func copy() -> Node {
    Node(region: region, points: points, quad: quad?.copy())
  }

  func subdivide() {
    precondition(quad == nil, "Already subdivided")
    quad = Quad(region: region)
  }

  func find(in searchRegion: CGRect) -> [CGPoint] {
    guard region.intersects(searchRegion) else {
      return []
    }
    var result = points.filter { searchRegion.contains($0) }
    if let quad = quad {
      result += quad.all.flatMap { $0.find(in: searchRegion) }
    }
    return result
  }

  @discardableResult
  func insert(_ point: CGPoint) -> Bool {
    if !region.contains(point) {
      return false
    }
    if points.count < maxItemCapacity {
      points.append(point)
      return true
    }
    if quad == nil {
      subdivide()
    }
    return quad!.all.contains { $0.insert(point) }
  }

  struct Quad {
    let topLeft: Node
    let topRight: Node
    let bottomLeft: Node
    let bottomRight: Node

    var all: [Node] {
      [topLeft, topRight, bottomLeft, bottomRight]
    }

    init(region: CGRect) {
      let (top, bottom) = region.divided(atDistance: region.height / 2, from: .minYEdge)
      let (topLeft, topRight) = top.divided(atDistance: region.width / 2, from: .minXEdge)
      let (bottomLeft, bottomRight) = bottom.divided(atDistance: region.width / 2, from: .minXEdge)
      self.topLeft = Node(region: topLeft)
      self.topRight = Node(region: topRight)
      self.bottomLeft = Node(region: bottomLeft)
      self.bottomRight = Node(region: bottomRight)
    }

    private init(topLeft: Node, topRight: Node, bottomLeft: Node, bottomRight: Node) {
      self.topLeft = topLeft
      self.topRight = topRight
      self.bottomLeft = bottomLeft
      self.bottomRight = bottomRight
    }

    func copy() -> Quad {
      Quad(topLeft: topLeft, topRight: topRight, bottomLeft: bottomLeft, bottomRight: bottomRight)
    }
  }
}
