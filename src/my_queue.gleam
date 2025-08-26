import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

pub type Queue(t) =
  List(t)

pub fn new() -> Queue(t) {
  []
}

pub fn insert(queue: Queue(t), element: t) -> Queue(t) {
  queue |> list.append([element])
}

pub fn pop_first(queue: Queue(t)) -> Option(#(Queue(t), t)) {
  case queue {
    [head, ..rest] -> Some(#(rest, head))
    [] -> None
  }
}

pub fn insert_all(queue: Queue(t), elements: List(t)) -> Queue(t) {
  list.append(queue, elements)
}

pub fn map(queue: Queue(t), with function: fn(t) -> a) -> Queue(a) {
  queue
  |> list.map(function)
}

pub fn to_string(queue: Queue(String)) -> String {
  queue
  |> string.join("\n")
}

pub fn each_and_update(
  queue: Queue(t),
  each: fn(Queue(t)) -> #(Queue(t), Option(result)),
) -> Option(result) {
  let #(new_fringe, result) = each(queue)
  case result {
    Some(result) -> Some(result)
    None -> {
      each_and_update(new_fringe, each)
    }
  }
}
