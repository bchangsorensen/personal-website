library(tidyverse)
library(rvest)
library(lubridate)

# Set range of dates to scrape, from Jan. 1st to yesterday
scrape_dates <-
  as_date(ymd("2020-01-01"):(today() - 1))

scrape_memeorandum <- function(scrape_date) {
  # Convert date to relevant URL
  url <- scrape_date %>%
    format("%y%m%d") %>%
    paste0("https://www.memeorandum.com/", ., "/h1800")
  # Read raw HTML
  raw <- read_html(url)

  tibble( # scrape sub items
    byline = raw %>%
      html_nodes(".lnkr cite") %>%
      html_text(),
    headline = raw %>%
      html_nodes(".lnkr a:nth-child(2)") %>% # first child is redundant
      html_text(),
    scrape_date = scrape_date,
    section = "sub"
  ) %>%
    bind_rows(
      tibble( # scrape main items
        byline = raw %>%
          html_nodes("script ~ cite") %>% # main items are structured differently, need subsequent selector
          html_text(),
        headline = raw %>%
          html_nodes("strong a") %>%
          html_text(),
        scrape_date = scrape_date,
        section = "main"
      )
    ) %>%
    transmute(
      scrape_date,
      outlet = if_else( # parse byline into outlet/author
        str_detect(byline, "\\s\\/\\s"),
        str_extract(byline, "(?<=\\s\\/\\s).+(?=\\:)"),
        str_extract(byline, ".+(?=\\:)")
      ),
      author = str_extract(byline, ".+(?=\\s\\/\\s)"),
      headline,
      section
    )
}

# Loop! Writing files individually in case of error
scrape_dates %>%
  map_dfr(
    .,
    ~ {
      print(now())
      Sys.sleep(10)
      write_csv(
        scrape_memeorandum(.),
        paste0(
          "~/personal-website/content/post/memeorandum-scraping/data/memeorandum_",
          format(., "%y%m%d"),
          ".csv"
        )
      )
    }
  )
