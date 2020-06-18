OSSAB_dict_raw <- data.frame()

for (questionnaire in c("MRT", "PAT", "PFT", "SRT")) {
  dict_raw <- read.csv(paste0("data_raw/dicts/", questionnaire, "_dict.csv"), sep = ";", stringsAsFactors = FALSE, header = TRUE)
  dict_raw$key <- sub("^", paste0(questionnaire, "_"), dict_raw$key)
  OSSAB_dict_raw <- dplyr::bind_rows(OSSAB_dict_raw, dict_raw)
}

general_dict_raw <- read.csv("data_raw/dicts/GENERAL_dict.csv", sep = ";", stringsAsFactors = FALSE, header = TRUE)
OSSAB_dict <- psychTestR::i18n_dict$new(dplyr::bind_rows(OSSAB_dict_raw, general_dict_raw))

usethis::use_data(OSSAB_dict, overwrite = TRUE)
