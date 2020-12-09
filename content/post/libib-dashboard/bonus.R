library(tidyverse)
library(flexdashboard)
library(slickR)
library(htmlwidgets)
library(reactable)
library(lubridate)

sysfonts::font_add_google(name = "Inter")
showtext::showtext_auto()

my_library <- read_csv("~/personal-website/content/post/libib-dashboard/data/libib_export.csv")

df <-
  my_library %>%
  inner_join(covers, by = c("title" = "cover_title")) %>%
  filter(str_detect(cover_art, "\\.jpg$")) %>%
  select(title, authors, first_name, last_name, rating, status, completed_date, began_date, pages, cover_art) %>%
  mutate(
    rating = rating * 2,
    title = if_else(
      str_detect(title, ", The$"),
      paste0("The ", str_remove(title, ", The$")),
      title
    ),
    title_author = paste0(title, " (", authors, ")")
  )

df %>%
  mutate(
    completed_date = ymd(completed_date),
    completed_month = floor_date(completed_date, "month")
  ) %>%
  filter(year(completed_date) >= 2019) %>%
  count(completed_month) %>%
  ggplot(aes(completed_month, n)) +
  geom_col(fill = "#42c2d0") +
  annotate("text", x = ymd("2020-07-01"), y = 7, label = "Moved to\nMontana!", hjust = 0, family = "Inter", color = "navy") +
  geom_curve(
    x = ymd("2020-08-01"),
    xend = ymd("2020-06-01"),
    y = 6,
    yend = 2.5,
    curvature = -.2,
    arrow = arrow(length = unit(0.07, "inch")),
    color = "orange"
  ) +
  scale_x_date(breaks = "1 month", labels = scales::date_format(format = "%b '%y")) +
  scale_y_continuous(labels = scales::comma_format(accuracy = 1)) +
  coord_cartesian(xlim = c(ymd("2019-01-01"), ymd("2020-11-15"))) +
  theme_minimal() +
  theme(
    text = element_text(family = "Inter"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank(),
    axis.ticks.y = element_line()
  ) +
  labs(
    title = "Books completed, 2019-2020",
    x = NULL,
    y = NULL
  )

ggsave("~/personal-website/content/post/libib-dashboard/bonus.png", width = 11, units = "in")
