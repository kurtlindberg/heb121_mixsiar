# HEB 121: Stable Isotope Methods in Modern and Paleo Ecology

library(MixSIAR)
library(ggplot2)


### Load input data files ###
# Load mixture data
mix <- load_mix_data(
  filename = "mix/mix_cerling_2003_bovids_diet.csv",
  iso_names = c("d13c"),
  factors = "species",
  fac_random = FALSE,
  fac_nested = FALSE,
  cont_effects = NULL
)

# Load endmember sources file
source <- load_source_data(
  filename = "source/source_cerling_1999_plants.csv",
  source_factors = NULL,
  conc_dep = FALSE,
  data_type = "means",
  mix
)

# Load discrimination factor file
discr <- load_discr_data(
  filename = "discr/discr_cerling_2003_bovids_diet.csv",
  mix
)


### Optional pre-model run plots: ###
# Plot mixture and source data
plot_data(
  filename = "plots/isospace_plot_diet",
  plot_save_pdf = FALSE,
  plot_save_png = TRUE,
  mix,
  source,
  discr
)

# Plot prior structure
plot_prior(
  alpha.prior = 1,
  source,
  filename = "plots/prior_plot_diet",
  plot_save_pdf = FALSE,
  plot_save_png = TRUE
)


### Run MixSIAR ###
# Model settings
model_filename = "MixSIAR_model.txt"
resid_err <- FALSE
process_err <- TRUE
write_JAGS_model(
  model_filename,
  resid_err,
  process_err,
  mix,
  source
)

# Start MixSIAR
jags.1 <- run_model(
  run="normal",
  mix,
  source,
  discr,
  model_filename
)


### Export MixSIAR outputs ###
# Output settings
output_options <- list(
  summary_save = TRUE,
  summary_name = "outputs/output_bovids_2end_diet",
  sup_post = TRUE,
  plot_post_save_pdf = FALSE,
  plot_post_name = "plots/posterior_density_diet",
  sup_pairs = TRUE,
  plot_pairs_save_pdf = FALSE,
  plot_pairs_name = "plots/pairs_plot_diet",
  sup_xy = TRUE,
  plot_xy_save_pdf = FALSE,
  plot_xy_name = "plots/xy_plot_diet",
  gelman = TRUE,
  heidel = FALSE,
  geweke = TRUE,
  diag_save = TRUE,
  diag_name = "diagnostics/diag_bovids_2end_diet",
  indiv_effect = FALSE,
  plot_post_save_png = TRUE,
  plot_pairs_save_png = TRUE,
  plot_xy_save_png = FALSE,
  diag_save_ggmcmc = TRUE
)

# Save model outputs
output_JAGS(
  jags.1,
  mix,
  source,
  output_options
)
