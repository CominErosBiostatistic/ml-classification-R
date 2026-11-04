# ml-classification-R

Comparison of machine learning models in R to classify patients at risk of heart disease, and a
Shiny app that classifies a new patient with the best model.

The analysis is written and commented in Italian.

## Contents

| File                             | Content                                                            |
| -------------------------------- | ------------------------------------------------------------------ |
| [`analysis.Rmd`](analysis.Rmd)   | R Markdown source: code and comments                               |
| [`analysis.html`](analysis.html) | Rendered report: code output and plots, without patient-level data |
| [`app/app.R`](app/app.R)         | Shiny app that classifies a new patient as at risk or not at risk  |

## Steps

| Step                | What it does                                                                                        |
| ------------------- | --------------------------------------------------------------------------------------------------- |
| Exploration         | Dimensions, variable formats and distributions.                                                     |
| Recoding            | Turns every numeric variable into a categorical one, with clinical thresholds.                      |
| Imputation          | Imputes missing values with K-nearest neighbours.                                                   |
| Balance             | Checks the balance of the outcome by sex, blood pressure and cholesterol, and tests oversampling.   |
| Model selection     | Selects the variables with BIC, Mallows' Cp and adjusted R².                                        |
| Model comparison    | Compares KNN, LDA, QDA, logistic regression and a neural network over 100 random train/test splits. |
| Tuning              | Tunes the neural network with 10-fold cross-validation, maximising sensitivity.                     |
| Variable importance | Measures variable importance with `varImp` and `DALEX`.                                             |
| App                 | Saves the tuned network for the Shiny app.                                                          |

## App

![Shiny app classifying a patient](app/screenshot.png)

## How to run it

1. Place the dataset in `data/DATA.csv`. The data are not included in this repository.
2. Knit `analysis.Rmd`, or run `rmarkdown::render("analysis.Rmd")` from the project folder.
   This also saves the tuned model in `app/model_nn.rds`.
3. Start the app with `shiny::runApp("app")`.

Packages: `DataExplorer`, `ggplot2`, `Hmisc`, `VIM`, `ROSE`, `dplyr`, `leaps`, `caret`, `nnet`,
`neuralnet`, `boot`, `MASS`, `class`, `DALEX`, `shiny`.

## Limitations

- The dataset contains repeated rows. The same patient can fall both in the training and in the test
  set, so the performance estimates are optimistic.
- The outcome in the data is coded the opposite way to its description (0 = disease). The analysis
  recodes it so that 1 identifies patients with heart disease.

## License

Released under the [MIT License](LICENSE).
