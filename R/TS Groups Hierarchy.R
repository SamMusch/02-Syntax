library(tsibble)
library(tidyverse)
library(fable)

tourism <- tsibble::tourism %>%
  mutate(State = recode(State,
                        `New South Wales` = "NSW",
                        `Northern Territory` = "NT",
                        `Queensland` = "QLD",
                        `South Australia` = "SA",
                        `Tasmania` = "TAS",
                        `Victoria` = "VIC",
                        `Western Australia` = "WA"))


ggplot(tourism, aes(x = Quarter, y = Trips)) +
  geom_col() + 
  scale_y_continuous(labels = scales::comma)

tourism



tourism_hts <- tourism %>%
  aggregate_key(State / Region, Trips = sum(Trips))

tourism_hts

tourism_hts %>% as_tibble() %>%
  count(State, Region) %>% View()


tourism_hts %>%
  filter(is_aggregated(Region)) %>%
  autoplot(Trips) +
  labs(y = "Trips ('000)",
       title = "Australian tourism: national and states") +
  facet_wrap(vars(State), scales = "free_y", ncol = 3) +
  theme(legend.position = "none")



