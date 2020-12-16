library(tidyverse)
library(lubridate)
library(plotly)
library(tidytext)
library(ggtext)

data(stop_words)

df <-
  map_dfr(
    list.files("~/personal-website/content/post/memeorandum-scraping/data", full.names = TRUE),
    ~ mutate(
      read_csv(.),
      section = if_else(!is.na(scrape_date), "sub", "main"),
      scrape_date = max(scrape_date, na.rm = TRUE)
    )
  ) %>%
  mutate(headline = str_replace_all(headline, "-", "_"))

# Top words over time
top_words <-
  df %>%
  unnest_tokens(word, headline) %>%
  anti_join(stop_words, by = "word") %>%
  mutate(word = str_remove(word, "\\'s$")) %>%
  count(scrape_date, word) %>%
  group_by(scrape_date) %>%
  slice_max(order_by = n, n = 1, with_ties = FALSE) %>%
  ungroup()

top_words_text <-
  top_words %>%
  filter(word != "trump") %>%
  group_by(word) %>%
  slice_min(order_by = scrape_date) %>%
  ungroup() %>%
  mutate(word = str_to_title(word))

top_words %>%
  ggplot(aes(scrape_date, n)) +
  geom_col(aes(fill = word == "trump"), size = 0, show.legend = FALSE) +
  scale_fill_manual(values = c("red", "grey")) +
  ggrepel::geom_label_repel(
    data = top_words_text,
    aes(label = word),
    vjust = 1,
    force = 20,
    arrow = arrow(angle = 45, length = unit(0.05, "cm"), ends = "last", type = "open")
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    plot.title = element_markdown(face = "bold"),
    plot.subtitle = element_markdown()
  ) +
  labs(
    title = "Which topics broke through Donald Trump's noise?",
    subtitle = "Highlighting days <span style = 'color:red;'>when Trump wasn't the #1 topic</span> on _Memeorandum.com_.",
    y = "Mentions",
    x = NULL
  )

## First appearances
first_appearances <-
  df %>%
  select(scrape_date, headline) %>%
  unnest_tokens(word, headline) %>%
  anti_join(stop_words, by = "word") %>%
  mutate(row_n = row_number()) %>%
  group_by(scrape_date) %>%
  mutate(row_n_date = row_number()) %>%
  ungroup() %>%
  group_by(word) %>%
  mutate(first_appearance = row_n == min(row_n)) %>%
  ungroup()

first_appearances %>%
  ggplot(aes(scrape_date, -row_n_date, fill = first_appearance)) +
  geom_tile() +
  scale_fill_manual(values = c("grey", "red"))

set.seed(94305)
first_appearances %>%
  filter(scrape_date == ymd("2020-12-13"), first_appearance) %>%
  mutate(x = 0, y = 0) %>%
  ggplot(aes(x, y, label = word)) +
  ggrepel::geom_label_repel(segment.alpha = 0, force = 15) +
  theme_void() +
  theme(plot.title = element_markdown(face = "bold")) +
  labs(
    title = "Words first appearing on _Memeorandum.com_ on 12/13/2020"
  )

top_8 <-
  df %>%
  unnest_tokens(word, headline) %>%
  anti_join(stop_words, by = "word") %>%
  mutate(word = str_remove(word, "\\'s$")) %>%
  count(word) %>%
  slice_max(n = 8, order_by = n)

df %>%
  unnest_tokens(word, headline) %>%
  filter(word %in% top_8$word) %>%
  group_by(word) %>%
  arrange(scrape_date) %>%
  mutate(row_n = row_number()) %>%
  ungroup() %>%
  ggplot(aes(scrape_date, row_n, color = word)) +
  geom_line(aes(group = word)) +
  ggrepel::geom_label_repel(
    data = transmute(top_8, scrape_date = ymd("2020-12-13"), row_n = n, word),
    aes(label = word),
    direction = "y"
  ) +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal() +
  theme(plot.title = element_markdown(face = "bold")) +
  labs(
    x = NULL,
    y = "Mentions",
    color = NULL,
    title = "Most common _Memeorandum.com_ headline topics of 2020"
  )
