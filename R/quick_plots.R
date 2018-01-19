#' Quickly create a DAG with M-shaped bias
#'
#' @param x Character vector. Optional label. Default is null.
#' @param y Character vector. Optional label. Default is null.
#' @param a Character vector. Optional label. Default is null.
#' @param b Character vector. Optional label. Default is null.
#' @param m Character vector. Optional label. Default is null.
#' @param x_y_associated Logical. Are x and y associated? Default is `FALSE`.
#'
#' @return a DAG of class `dagitty`
#' @export
#'
#' @examples

m_bias <- function(x = NULL, y = NULL, a = NULL, b = NULL, m = NULL, x_y_associated = FALSE) {
  coords <- tibble::tribble(
    ~name, ~x, ~y,
    "x", 0, 0,
    "y", 2, 0,
    "a", 0, 1,
    "b", 2, 1,
    "m", 1, .5
  )

  if (x_y_associated) {
    .dag <- dagify(
      m ~ a + b,
      x ~ a,
      y ~ b + x,
      exposure = x,
      outcome = y,
      coords = coords)
  } else {
  .dag <- dagify(
    m ~ a + b,
    x ~ a,
    y ~ b,
    exposure = x,
    outcome = y,
    coords = coords)
  }

  if (!is.null(c(x, y, a, b, m))) label(.dag) <- c(x = x, y = y, a = a, b = b, m = m)

  .dag
}

#' Title
#'
#' @param x
#' @param y
#' @param a
#' @param b
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
butterfly_bias <- function(x = NULL, y = NULL, a = NULL, b = NULL, m = NULL, x_y_associated = FALSE) {
  coords <- tibble::tribble(
    ~name, ~x, ~y,
    "x", 0, 0,
    "y", 2, 0,
    "a", 0, 1,
    "b", 2, 1,
    "m", 1, .5
  )

  if (x_y_associated) {
    .dag <- dagify(
      m ~ a + b,
      x ~ a + m,
      y ~ b + x + m,
      exposure = x,
      outcome = y,
      coords = coords)
  } else {
    .dag <- dagify(
      m ~ a + b,
      x ~ a + m,
      y ~ b + m,
      exposure = x,
      outcome = y,
      coords = coords)
  }

  if (!is.null(c(x, y, a, b, m))) label(.dag) <- c(x = x, y = y, a = a, b = b, m = m)

  .dag
}

#' Title
#'
#' @param x
#' @param y
#' @param z
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
confounder_triangle <- function(x = NULL, y = NULL, z = NULL, x_y_associated = FALSE) {
  coords <- tibble::tribble(
    ~name, ~x, ~y,
    "x", 0, 0,
    "y", 2, 0,
    "z", 1, 1
  )

  if (x_y_associated) {
    .dag <- dagify(
      x ~ z,
      y ~ x + z,
      exposure = x,
      outcome = y,
      coords = coords)
  } else {
    .dag <- dagify(
      x ~ z,
      y ~ z,
      exposure = x,
      outcome = y,
      coords = coords)
  }

  if (!is.null(c(x, y, z))) label(.dag) <- c(x = x, y = y, z = z)

  .dag
}

#' Title
#'
#' @param x
#' @param y
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
collider_triangle <- function(x = NULL, y = NULL, m = NULL, x_y_associated = FALSE) {
  coords <- tibble::tribble(
    ~name, ~x, ~y,
    "x", 0, 1,
    "y", 2, 1,
    "m", 1, 0
  )

  if (x_y_associated) {
    .dag <- dagify(
      m ~ x + y,
      y ~ x,
      exposure = x,
      outcome = y,
      coords = coords)
  } else {
    .dag <- dagify(
      m ~ x + y,
      exposure = x,
      outcome = y,
      coords = coords)
  }

  if (!is.null(c(x, y, m))) label(.dag) <- c(x = x, y = y, m = m)

  .dag
}

#' Title
#'
#' @param x
#' @param y
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
mediation_triangle <- function(x = NULL, y = NULL, m = NULL, x_y_associated = FALSE) {
  coords <- tibble::tribble(
    ~name, ~x, ~y,
    "x", 0, 0,
    "y", 2, 0,
    "m", 1, 1
  )

  if (x_y_associated) {
    .dag <- dagify(
      m ~ x,
      y ~ x + m,
      exposure = x,
      outcome = y,
      coords = coords)
  } else {
    .dag <- dagify(
      m ~ x,
      y ~ m,
      exposure = x,
      outcome = y,
      coords = coords)
  }

  if (!is.null(c(x, y, m))) label(.dag) <- c(x = x, y = y, m = m)

  .dag
}

#' Title
#'
#' @param x
#' @param y
#' @param a
#' @param b
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
ggdag_m_bias <- function(x = NULL, y = NULL, a = NULL, b = NULL, m = NULL, x_y_associated = FALSE) {
  ggdag(m_bias(x, y, a, b, m, x_y_associated))
}

#' Title
#'
#' @param x
#' @param y
#' @param a
#' @param b
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
ggdag_butterfly_bias <- function(x = NULL, y = NULL, a = NULL, b = NULL, m = NULL, x_y_associated = FALSE) {
  ggdag(butterfly_bias(x, y, a, b, m, x_y_associated))
}

#' Title
#'
#' @param x
#' @param y
#' @param z
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
ggdag_confounder_triangle <- function(x = NULL, y = NULL, z = NULL, x_y_associated = FALSE) {
  ggdag(confounder_triangle(x, y, z, x_y_associated))
}

#' Title
#'
#' @param x
#' @param y
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
ggdag_collider_triangle <- function(x = NULL, y = NULL, m = NULL, x_y_associated = FALSE) {
  ggdag(collider_triangle(x, y, m, x_y_associated))
}

#' Title
#'
#' @param x
#' @param y
#' @param m
#' @param x_y_associated
#'
#' @return
#' @export
#'
#' @examples
ggdag_mediation_triangle <- function(x = NULL, y = NULL, m = NULL, x_y_associated = FALSE) {
  ggdag(mediation_triangle(x, y, m, x_y_associated))
}