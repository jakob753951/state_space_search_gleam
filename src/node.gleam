import gleam/list
import gleam/option.{type Option, None, Some}

pub type Node(s) {
  Node(state: s, parent_node: Option(Node(s)), depth: Int)
}

pub fn new(initial_state: s) -> Node(s) {
  Node(state: initial_state, parent_node: None, depth: 0)
}

pub fn path(node: Node(s)) -> List(Node(s)) {
  case node.parent_node {
    None -> [node]
    Some(parent) -> [node, ..path(parent)]
  }
}

pub fn expand(node: Node(s), successor_fn: fn(s) -> List(s)) -> List(Node(s)) {
  let child_states = successor_fn(node.state)
  child_states
  |> list.map(fn(child_state) {
    Node(state: child_state, parent_node: Some(node), depth: node.depth + 1)
  })
}
