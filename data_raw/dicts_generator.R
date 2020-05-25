for (questionnaire in c("MRT", "PAT", "PFT", "SRT")) {
  dict_raw <- read.csv(paste0("data_raw/dicts/", questionnaire, "_dict.csv"), sep = ";", stringsAsFactors = FALSE, header = TRUE)
  general_dict_raw <- read.csv("data_raw/dicts/GENERAL_dict.csv", sep = ";", stringsAsFactors = FALSE, header = TRUE)
  assign(paste0(questionnaire, "_dict"), psychTestR::i18n_dict$new(dplyr::bind_rows(dict_raw, general_dict_raw)))
}

usethis::use_data(MRT_dict, PAT_dict, PFT_dict, SRT_dict, overwrite = TRUE)
