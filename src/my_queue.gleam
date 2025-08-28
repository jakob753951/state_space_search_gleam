import gleam/list
import gleam/option.{type Option, None, Some}

pub type Queue(t) {
  Queue(elements: List(t))
}

pub fn new() -> Queue(t) {
  Queue([])
}

pub fn insert(queue: Queue(t), element: t) -> Queue(t) {
  Queue(..queue, elements: queue.elements |> list.append([element]))
}

pub fn pop_first(queue: Queue(t)) -> Option(#(Queue(t), t)) {
  case queue.elements {
    [head, ..rest] -> Some(#(Queue(rest), head))
    [] -> None
  }
}

pub fn insert_all(queue: Queue(t), elements: List(t)) -> Queue(t) {
  list.fold(elements, queue, insert)
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
