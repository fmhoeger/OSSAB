for (questionnaire in c("MRT", "PAT", "PFT", "SRT")) {
    item_bank_raw <- read.csv(paste0("data_raw/item_banks/", questionnaire, "_item_bank.csv"), sep = ";", stringsAsFactors = FALSE, header = TRUE)
    assign(paste0(questionnaire, "_item_bank"), item_bank_raw)
}

usethis::use_data(MRT_item_bank, PAT_item_bank, PFT_item_bank, SRT_item_bank, overwrite = TRUE)
