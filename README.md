# Logistic Regression in R

![License](https://img.shields.io/badge/license-MIT-blue) 
![Language](https://img.shields.io/badge/R-4.0%2B-blue)
![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen)

## 📖 Overview
This repository contains an R package for logistic regression using **Newton-Raphson** and **IRLS** methods. The package provides tools for fitting logistic regression models from scratch without external dependencies.

### Features
- Newton-Raphson and IRLS implementation.
- Handles singular Hessian matrices.
- Includes convergence diagnostics.

---

## 🛠️ Installation
Clone this repository to your local machine and install the package:

```bash
# Clone the repository
git clone https://github.com/yulN0X/custom_logistic_regression

# Navigate to the directory
cd custom_logistic_regression
```

## 🚀 Usage
```R
# Load the package
library(myLogisticRegression)

# Example data
X <- matrix(c(1, 2, 3, 4, 5), ncol = 1)
y <- c(0, 0, 1, 1, 1)

# Fit the logistic regression model
model <- logistic_regression_nr_irls(X, y)

# Output
print(model$method)
print(model$beta)
print(model$fit)
```
## 📊 Visualization
```R
plot(X, y, main = "Logistic Regression Fit", col = "blue")
lines(sort(X[, 1]), model$fit[order(X[, 1])], col = "red", lwd = 2)
```
