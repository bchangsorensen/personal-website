library(tidyverse)
library(RSocrata)
library(reactable)
library(htmltools)
setwd("~/personal-website/content/post/humira-cost/")

### API endpoints
# https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Charge-Data/Part-D-Prescriber
api_endpoints <-
  tribble(
    ~ endpoint, ~ claim_year,
    # 2018 CY
    "https://data.cms.gov/resource/mhdd-npjx.json", 2018,
    # 2017 CY
    "https://data.cms.gov/resource/77gb-8z53.json", 2017,
    # 2016 CY
    "https://data.cms.gov/resource/yvpj-pmj2.json", 2016,
    # 2015 CY
    "https://data.cms.gov/resource/3z4d-vmhm.json", 2015,
    # 2014 CY
    "https://data.cms.gov/resource/465c-49pb.json", 2014,
    # 2013 CY
    "https://data.cms.gov/resource/4uvc-gbfz.json", 2013
  )

### API Docs: https://dev.socrata.com/foundry/data.cms.gov/mhdd-npjx
api_endpoints$endpoint %>%
  map_dfr(
    ~ mutate(
      read.socrata(
        paste0(., "?generic_name=ADALIMUMAB"),
        app_token = Sys.getenv("CMS_APP_TOKEN"),
        email     = Sys.getenv("CMS_EMAIL"),
        password  = Sys.getenv("CMS_PASSWORD")
      ),
      endpoint = .
    ) %>%
      mutate_at(vars(ends_with("_count"), starts_with("total_"), bene_count_ge65), as.double)
  ) %>%
  left_join(api_endpoints, by = "endpoint") %>%
  select(-endpoint) %>%
  mutate(
    specialty_description = if_else(is.na(specialty_description), specialty_desc, specialty_description),
    claim_year = as.character(claim_year)
  ) %>%
  select(-specialty_desc) %>%
  write_rds("data/cms_adalimumab.rds")
