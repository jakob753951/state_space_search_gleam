import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import my_queue
import node.{type Node}
import state.{type State}

pub fn main() -> Nil {
  let initial_state = "you"
  let goal_state = "out"

  let path =
    tree_search(
      from: initial_state,
      is_goal: fn(state) { state == goal_state },
      successor_fn:,
    )

  case path {
    None -> echo "No path found :("
    Some(goal_node) ->
      "Found path: "
      <> goal_node
      |> node.path()
      |> list.map(fn(node) { node.state })
      |> list.reverse()
      |> string.join(" ")
  }
  |> io.println()
}

fn tree_search(
  from initial_state: State,
  is_goal is_goal: fn(State) -> Bool,
  successor_fn successor_fn: fn(State) -> List(State),
) -> Option(Node(State)) {
  let fringe = my_queue.new(my_queue.FirstInFirstOut)
  let initial_node = node.new(initial_state)
  let fringe = fringe |> my_queue.insert(initial_node)
  fringe
  |> my_queue.each_and_update(fn(fringe) {
    let assert Some(#(fringe, node)) = fringe |> my_queue.pop_first()
    case is_goal(node.state) {
      True -> #(fringe, Some(node))
      False -> {
        let children = node |> node.expand(successor_fn)
        let fringe = my_queue.insert_all(fringe, children)
        #(fringe, None)
      }
    }
  })
}

fn successor_fn(state: State) -> List(State) {
  case state {
    "aaa" -> ["you", "hhh"]
    "you" -> ["bbb", "ccc"]
    "bbb" -> ["ddd", "eee"]
    "ccc" -> ["ddd", "eee", "fff"]
    "ddd" -> ["ggg"]
    "eee" -> ["out"]
    "fff" -> ["out"]
    "ggg" -> ["out"]
    "hhh" -> ["ccc", "fff", "iii"]
    "iii" -> ["out"]
    _ -> []
  }
}
