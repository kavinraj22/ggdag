#' Familial relationships between variables
#'
#' Parents and children are those nodes that either directly cause or are caused
#' by the variable, respectively. Ancestors and descendants are those nodes that
#' are on the path to or descend from the variable. The \code{node_*()}
#' functions label variables depending on their relationship. The
#' \code{ggdag_*()} functions plot the results. See
#' \code{dagitty::\link[dagitty]{children}} for details.
#'
#' @param .tdy_dag input graph, an object of class \code{tidy_dagitty} or
#'   \code{dagitty}
#' @param ... additional arguments passed to \code{tidy_dagitty()}
#' @param .var a character vector, the variable to be assessed (must by in DAG)
#' @param as_factor logical. Should the relationship variable be a factor?
#'
#' @return a \code{tidy_dagitty} with an column related to the given
#'   relationship for variable D relationship or a \code{ggplot}
#' @export
#'
#' @examples
#' dag <- dagify(y ~ x + z2 + w2 + w1,
#'   x ~ z1 + w1,
#'   z1 ~ w1 + v,
#'   z2 ~ w2 + v,
#'   w1 ~~ w2)
#'
#' ggdag_children(dag, "w1")
#'
#' dag %>%
#'   node_children("w1") %>%
#'   ggplot(aes(x = x, y = y, xend = xend, yend = yend, color = children)) +
#'   geom_dag_edges() +
#'   geom_dag_node() +
#'   geom_dag_text(col = "white") +
#'   geom_dag_label_repel(aes(label = children, fill = children), col = "white", show.legend = FALSE) +
#'   theme_dag() + scale_dag(breaks  = c("parent", "child"))
#'
#' ggdag_parents(dag, "y")
#'
#' ggdag_ancestors(dag, "x")
#'
#' ggdag_descendants(dag, "w1")
#'
#' dag %>%
#'   node_parents("y") %>%
#'   ggplot(aes(x = x, y = y, xend = xend, yend = yend, color = parent)) +
#'   geom_dag_edges() +
#'   geom_dag_node() +
#'   geom_dag_text(col = "white") +
#'   geom_dag_label_repel(aes(label = parent, fill = parent), col = "white", show.legend = FALSE) +
#'   theme_dag() + scale_dag(breaks  = c("parent", "child"))
#'
#' @rdname variable_family
#' @name Assess familial relationships between variables
node_children <- function(.tdy_dag, .var, as_factor = TRUE) {
  .tdy_dag <- if_not_tidy_daggity(.tdy_dag)

  .children <- dagitty::children(.tdy_dag$dag, .var)
  .tdy_dag$data <- dplyr::mutate(.tdy_dag$data,
                                 children = ifelse(name %in% .children, "child",
                                                   ifelse(name == .var, "parent",
                                                          NA)))
  if (as_factor) .tdy_dag$data$children <- factor(.tdy_dag$data$children, exclude = NA)
  .tdy_dag
}

#' @rdname variable_family
#' @export
node_parents <- function(.tdy_dag, .var, as_factor = TRUE) {
  .tdy_dag <- if_not_tidy_daggity(.tdy_dag)

  .parent <- dagitty::parents(.tdy_dag$dag, .var)
  .tdy_dag$data <- dplyr::mutate(.tdy_dag$data,
                                 parent = ifelse(name %in% .parent, "parent",
                                                 ifelse(name == .var, "child",
                                                        NA)))
  if (as_factor) .tdy_dag$data$parent <- factor(.tdy_dag$data$parent, exclude = NA)
  .tdy_dag
}

#' @rdname variable_family
#' @export
node_ancestors <- function(.tdy_dag, .var, as_factor = TRUE) {
  .tdy_dag <- if_not_tidy_daggity(.tdy_dag)

  .ancestors <- dagitty::ancestors(.tdy_dag$dag, .var)[-1]
  .tdy_dag$data <- dplyr::mutate(.tdy_dag$data,
                                 ancestor = ifelse(name %in% .ancestors, "ancestor",
                                                   ifelse(name == .var, "descendant",
                                                          NA)))
  if (as_factor) .tdy_dag$data$ancestor <- factor(.tdy_dag$data$ancestor, exclude = NA)
  .tdy_dag
}

#' @rdname variable_family
#' @export
node_descendants <- function(.tdy_dag, .var, as_factor = TRUE) {
  .tdy_dag <- if_not_tidy_daggity(.tdy_dag)

  .descendants <- dagitty::descendants(.tdy_dag$dag, .var)[-1]
  .tdy_dag$data <- dplyr::mutate(.tdy_dag$data,
                                 descendant = ifelse(name %in% .descendants, "descendant",
                                                     ifelse(name == .var, "ancestor",
                                                            NA)))
  if (as_factor) .tdy_dag$data$descendant <- factor(.tdy_dag$data$descendant, exclude = NA)
  .tdy_dag
}

#' @rdname variable_family
#' @export
ggdag_children <- function(.tdy_dag, .var, ...) {
  if_not_tidy_daggity(.tdy_dag, ...) %>%
    node_children(.var) %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = children)) +
    geom_dag_edges() +
    geom_dag_node() +
    geom_dag_text(col = "white") +
    theme_dag() +
    scale_dag(breaks  = c("parent", "child"))
}

#' @rdname variable_family
#' @export
ggdag_parents <- function(.tdy_dag, .var, ...) {
  if_not_tidy_daggity(.tdy_dag, ...) %>%
    node_parents(.var) %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = parent)) +
    geom_dag_edges() +
    geom_dag_node() +
    geom_dag_text(col = "white") +
    theme_dag() +
    scale_dag(breaks  = c("parent", "child"))
}

#' @rdname variable_family
#' @export
ggdag_ancestors <- function(.tdy_dag, .var, ...) {
  if_not_tidy_daggity(.tdy_dag, ...) %>%
    node_ancestors(.var) %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = ancestor)) +
    geom_dag_edges() +
    geom_dag_node() +
    geom_dag_text(col = "white") +
    theme_dag() +
    scale_dag(breaks  = c("ancestor", "descendant"))
}

#' @rdname variable_family
#' @export
ggdag_descendants <- function(.tdy_dag, .var, ...) {
  if_not_tidy_daggity(.tdy_dag, ...) %>%
    node_descendants(.var) %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y, xend = xend, yend = yend, color = descendant)) +
    geom_dag_edges() +
    geom_dag_node() +
    geom_dag_text(col = "white") +
    theme_dag() +
    scale_dag(breaks  = c("ancestor", "descendant"))
}
