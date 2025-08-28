import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import my_queue
import node.{type Node}
import state.{type State}

pub fn main() -> Nil {
  let initial_state = "A"
  let goal_state = "J"

  let path = tree_search(initial_state, goal_state, successor_fn)

  case path {
    None -> echo "No path found :("
    Some(nodes) ->
      "Found path: "
      <> nodes
      |> list.map(fn(node) { node.state })
      |> list.reverse()
      |> string.join(" ")
  }
  |> io.println()
}

fn tree_search(
  initial_state: State,
  goal_state: State,
  successor_fn: fn(State) -> List(State),
) -> Option(List(Node(State))) {
  let fringe = my_queue.new()
  let initial_node = node.new(initial_state)
  let fringe = fringe |> my_queue.insert(initial_node)
  fringe
  |> my_queue.each_and_update(fn(fringe) {
    let assert Some(#(fringe, node)) = fringe |> my_queue.pop_first()
    case node.state == goal_state {
      True -> #(fringe, Some(node |> node.path()))
      False -> {
        let children = node |> node.expand(successor_fn)
        let fringe = my_queue.insert_all(fringe, children)
        {
          "Fringe: "
          <> fringe.elements
          |> list.map(fn(node) { node.state })
          |> string.join(" ")
        }
        |> io.println
        #(fringe, None)
      }
    }
  })
}

fn successor_fn(state: State) -> List(State) {
  case state {
    "A" -> ["B", "C"]
    "B" -> ["D", "E"]
    "C" -> ["F", "G"]
    "D" -> []
    "E" -> []
    "F" -> []
    "G" -> ["H", "I", "J"]
    "H" -> []
    "I" -> []
    "J" -> []
    _ -> []
  }
}
