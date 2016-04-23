# Reproducible random numbers
set.seed(123, kind = "Mersenne-Twister")

# We want 50 vectors of p-values
vec_id <- 1:50

# Methods
met <- c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")

# Create folder where to put files
if (!dir.exists("out")) dir.create("out");

# Generate the vectors
for (i in vec_id) {

  # How many p-values in current vector (max 500)
  npvals <- round(runif(1, 1, 500));

  # Generate vector of p-values
  pvals <- rbeta(npvals, 0.5, 0.5)

  # Matrix of p-values
  mpvals <- matrix(nrow = 1 + length(met), ncol = npvals)
  mpvals[1, ] <- pvals

  # Adjust p-values using the available methods
  for (j in 1:length(met)) {
    mpvals[j + 1, ] <- p.adjust(pvals, method = met[j])
  }

  # Save results to file in folder "out"
  write.table(mpvals, file = paste0("out/pvals", i, ".tsv"),
              col.names = F, row.names = F)

}
