#' Logistic Regression using Newton-Raphson and IRLS
#'
#' Fungsi untuk melakukan regresi logistik menggunakan metode Newton-Raphson dan IRLS.
#'
#' @param X Matrix atau data frame berisi variabel independen (predictors).
#' @param y Vector berisi variabel dependen (response) berupa data biner (0/1).
#' @param tol Toleransi untuk konvergensi (default: 1e-6).
#' @param max_iter Jumlah maksimum iterasi (default: 100).
#' @param alpha Faktor pembelajaran untuk mengurangi langkah pembaruan (default: 1).
#'
#' @return Sebuah list dengan elemen berikut:
#' \item{method}{Nama metode yang digunakan ("Newton-Raphson with IRLS").}
#' \item{beta}{Koefisien regresi.}
#' \item{fit}{Probabilitas prediksi (P(y = 1)) untuk data input.}
#' \item{converged}{TRUE jika konvergen, FALSE jika tidak.}
#' @examples
#' # Contoh data
#' X <- matrix(c(1, 2, 3, 4, 5), ncol = 1) # Variabel independen
#' y <- matrix(c(0, 0, 1, 1, 1), ncol = 1) # Variabel dependen biner
#'
#' # Membuat model regresi logistik
#' model <- logistic_regression_nr_irls(X, y)
#'
#' # Menampilkan hasil
#' print(model$method)
#' print(model$beta)
#' print(model$fit)
#' @export
logistic_regression_nr_irls <- function(X, y, tol = 1e-6, max_iter = 100, alpha = 1) {
  # Menambahkan intercept (kolom 1 di X)
  X <- cbind(1, X)
  n <- nrow(X)
  p <- ncol(X)

  # Validasi input
  if (length(unique(y)) < 2) stop("Variabel y harus memiliki setidaknya dua kelas unik (0 dan 1).")
  if (any(y != 0 & y != 1)) stop("Variabel y hanya boleh terdiri dari nilai 0 dan 1.")

  # Inisialisasi koefisien beta
  beta <- matrix(0, nrow = p, ncol = 1)

  # Fungsi sigmoid
  sigmoid <- function(z) {
    return(1 / (1 + exp(-z)))
  }

  # Iterasi Newton-Raphson
  converged <- FALSE
  for (i in 1:max_iter) {
    z <- X %*% beta
    fit <- sigmoid(z)
    fit <- pmin(pmax(fit, 1e-15), 1 - 1e-15)

    W <- diag(as.vector(fit * (1 - fit)))
    gradient <- t(X) %*% (y - fit)
    hessian <- -t(X) %*% W %*% X

    # Regularisasi untuk mencegah singularitas
    hessian <- hessian + diag(1e-6, p)

    # Pembaruan beta dengan learning rate
    beta_new <- tryCatch(
      beta - alpha * solve(hessian) %*% gradient,
      error = function(e) {
        warning("Hessian is singular, using pseudo-inverse.")
        beta - alpha * MASS::ginv(hessian) %*% gradient
      }
    )

    if (max(abs(beta_new - beta)) < tol) {
      beta <- beta_new
      converged <- TRUE
      break
    }
    beta <- beta_new
  }

  # Output
  return(list(
    method = "Newton-Raphson with IRLS",
    beta = beta,
    fit = as.vector(sigmoid(X %*% beta)),
    converged = converged
  ))
}
