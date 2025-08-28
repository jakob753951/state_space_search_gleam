import gleam/list
import gleam/option.{type Option, None, Some}

pub type Queue(t) {
  Queue(elements: List(t), inserter: fn(List(t), t) -> List(t))
}

pub type Type {
  FirstInFirstOut
  FirstInLastOut
}

pub fn new(queue_type: Type) -> Queue(t) {
  let inserter = case queue_type {
    FirstInFirstOut -> fifo_insert
    FirstInLastOut -> filo_insert
  }
  Queue([], inserter:)
}

pub fn fifo_insert(elements: List(t), element: t) -> List(t) {
  list.append(elements, [element])
}

pub fn filo_insert(elements: List(t), element: t) -> List(t) {
  [element, ..elements]
}

pub fn insert(queue: Queue(t), element: t) -> Queue(t) {
  Queue(..queue, elements: queue.elements |> queue.inserter(element))
}

pub fn pop_first(queue: Queue(t)) -> Option(#(Queue(t), t)) {
  case queue.elements {
    [head, ..rest] -> Some(#(Queue(..queue, elements: rest), head))
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
