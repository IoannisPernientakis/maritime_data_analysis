############################################################################################################################
################################# Exploratory Data Analysis of Maritime Trade Volume #######################################
############################################################################################################################

# 1. Load Libraries and Dataset

library(tidyverse)
library(tidyr)
library(scales)

maritime_volume <- read_csv("Desktop/maritime_volume.csv")

glimpse(maritime_volume)


##################################################
# 2. Data Cleaning and Transformation
##################################################

# Use the first row as column names
colnames(maritime_volume) <- maritime_volume[1, ]

# Remove the first row after promoting it to column names
maritime_volume <- maritime_volume[-1, ]

# Rename main categorical columns
colnames(maritime_volume)[1] <- "Areas"
colnames(maritime_volume)[2] <- "Type Of Operation"

# Convert categorical variables
maritime_volume$Areas <- as.factor(maritime_volume$Areas)
maritime_volume$`Type Of Operation` <- as.factor(maritime_volume$`Type Of Operation`)

# Convert yearly columns to numeric
maritime_volume[3:53] <- lapply(
  maritime_volume[3:53],
  as.numeric
)

# Remove decimal values by rounding 
maritime_volume[3:53] <- lapply(
  maritime_volume[3:53],
  round
)

# Remove duplicate rows
maritime_volume <- distinct(maritime_volume)


##################################################
# 3. Reshape Dataset to Long Format
##################################################

maritime_long <- maritime_volume %>%
  pivot_longer(
    cols = `1970`:`2020`,
    names_to = "Year",
    values_to = "Volume"
  )

maritime_long$Year <- as.numeric(maritime_long$Year)


##################################################
# 4. Calculate Growth Rate
##################################################

maritime_long <- maritime_long %>%
  group_by(Areas, `Type Of Operation`) %>%
  arrange(Year) %>%
  mutate(
    Growth_Rate = if_else(
      lag(Volume) == 0 | is.na(lag(Volume)),
      NA_real_,
      (Volume - lag(Volume)) / lag(Volume)
    )
  ) %>%
  ungroup()


##################################################
# 5. Global Maritime Trade Overview For the Major Continents (Africa, America, Asia, Europe, Oceania)
##################################################
major_continents <- c(
  "Africa",
  "America",
  "Asia",
  "Europe",
  "Oceania"
  
continent_operations <- maritime_long %>%
  filter(
    Areas %in% major_continents,
    Year >=2010 &
      Year <= 2020
  )

ggplot(
  continent_operations,
  aes(
    x = Year,
    y = Volume,
    color = Areas,
    group = Areas
  )
) +
  geom_line(linewidth = 1) +
  facet_wrap(~ `Type Of Operation`, scales = "free_y") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  labs(
    title = "Maritime Volume by Operation Type and Continent",
    x = "Year",
    y = "Volume",
    color = "Area"
  )

##################################################
# 6. World Maritime Operations
##################################################

world_operations <- maritime_long %>%
  filter(Areas == "World")

ggplot(
  world_operations,
  aes(
    x = Year,
    y = Volume,
    color = `Type Of Operation`
  )
) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 1.8) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "World Maritime Operations Over Time",
    subtitle = "Comparison of global cargo loading and discharging activity",
    x = "Year",
    y = "Volume",
    color = "Operation Type"
  )


##################################################
# 7. Dry Cargo Analysis: Major Continents
##################################################


dry_cargo <- maritime_long %>%
  filter(
    `Type Of Operation` %in%
      c("Dry cargo loaded", "Dry cargo discharged"),
    Areas %in% major_continents,
    Year >= 2010,
    Year <= 2020
  )


##################################################
# 8. Dry Cargo Loaded
##################################################

dry_cargo_loaded <- dry_cargo %>%
  filter(`Type Of Operation` == "Dry cargo loaded")

ggplot(
  dry_cargo_loaded,
  aes(
    x = Year,
    y = Volume,
    color = Areas
  )
) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 2) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Dry Cargo Loaded by Major Continent",
    subtitle = "Regional comparison of dry cargo loading activity, 2010–2020",
    x = "Year",
    y = "Volume",
    color = "Area"
  )


##################################################
# 9. Dry Cargo Discharged
##################################################

dry_cargo_discharged <- dry_cargo %>%
  filter(`Type Of Operation` == "Dry cargo discharged")

ggplot(
  dry_cargo_discharged,
  aes(
    x = Year,
    y = Volume,
    color = Areas
  )
) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 2) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Dry Cargo Discharged by Major Continent",
    subtitle = "Regional comparison of dry cargo discharging activity, 2010–2020",
    x = "Year",
    y = "Volume",
    color = "Area"
  )


##################################################
# 10. Dry Cargo Growth Rate
##################################################

ggplot(
  dry_cargo_loaded,
  aes(
    x = Year,
    y = Growth_Rate,
    color = Areas
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 1.8) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 0, vjust = 0.5),
    legend.position = "bottom"
  ) +
  labs(
    title = "Dry Cargo Loaded Growth Rate",
    subtitle = "Year-over-year growth rate by major continent",
    x = "Year",
    y = "Growth Rate",
    color = "Area"
  )


ggplot(
  dry_cargo_discharged,
  aes(
    x = Year,
    y = Growth_Rate,
    color = Areas
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 1.8) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  labs(
    title = "Dry Cargo Discharged Growth Rate",
    subtitle = "Year-over-year growth rate by major continent",
    x = "Year",
    y = "Growth Rate",
    color = "Area"
  )


##################################################
# 11. Net Dry Cargo Trade
##################################################

net_dry_trade <- dry_cargo %>%
  select(
    Areas,
    Year,
    `Type Of Operation`,
    Volume
  ) %>%
  pivot_wider(
    id_cols = c(Areas, Year),
    names_from = `Type Of Operation`,
    values_from = Volume
  ) %>%
  mutate(
    Net_Trade =
      `Dry cargo loaded` -
      `Dry cargo discharged`
  ) %>%
  filter(!is.na(Net_Trade))

ggplot(
  net_dry_trade,
  aes(
    x = Year,
    y = Net_Trade,
    color = Areas
  )
) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 1.8) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Net Dry Cargo Trade by Major Continent",
    subtitle = "Positive values indicate higher loaded volumes than discharged volumes",
    x = "Year",
    y = "Net Trade",
    color = "Area"
  )


##################################################
# 12. Crude Oil Analysis
##################################################

crude_oil <- maritime_long %>%
  filter(
    `Type Of Operation` %in%
      c("Crude oil loaded", "Crude oil discharged"),
    Areas %in% major_continents,
    Year >= 2010,
    Year <= 2020
  ) %>%
  filter(!is.na(Volume))


ggplot(
  crude_oil,
  aes(
    x = Year,
    y = Volume,
    color = `Type Of Operation`
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  facet_wrap(~ Areas) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Crude Oil Loaded vs Discharged by Area",
    subtitle = "Crude oil maritime flows across major continents, 2010–2020",
    x = "Year",
    y = "Volume",
    color = "Operation"
  )


##################################################
# 13. Net Crude Oil Trade
##################################################

net_oil_trade <- crude_oil %>%
  select(
    Areas,
    Year,
    `Type Of Operation`,
    Volume
  ) %>%
  pivot_wider(
    id_cols = c(Areas, Year),
    names_from = `Type Of Operation`,
    values_from = Volume
  ) %>%
  mutate(
    Net_Trade =
      `Crude oil loaded` -
      `Crude oil discharged`
  ) %>%
  filter(!is.na(Net_Trade))

ggplot(
  net_oil_trade,
  aes(
    x = Year,
    y = Net_Trade,
    color = Areas
  )
) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 1.8) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5),
    legend.position = "bottom"
  ) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Net Crude Oil Trade by Major Continent",
    subtitle = "Positive values indicate higher crude oil loading than discharging",
    x = "Year",
    y = "Net Trade",
    color = "Area"
  )

##################################################
# 14. Developed vs Developing Maritime Trade Analysis
##################################################
economic_groups <- maritime_long %>%
  filter(
    
    str_detect(Areas, "Developed") |
      str_detect(Areas, "Developing")
      )

economic_groups <- na.omit(economic_groups)

economic_groups <- economic_groups %>%
  mutate(
    
    Development_Status =
      
      case_when(
        
        str_detect(Areas, "Developed") ~
          "Developed",
        
        
        str_detect(Areas, "Developing") ~
          "Developing"
      )
  )

economic_avg <- economic_groups %>%
  
  group_by(
    Development_Status,
    Year,
    `Type Of Operation`
  ) %>%
  
  summarise(
    
    Avg_Volume =
      mean(Volume, na.rm = TRUE),
    
    .groups = "drop"
  )

ggplot(
  economic_avg,
  aes(
    x = Year,
    y = Avg_Volume,
    color = Development_Status
  )
) +
  
  geom_line(linewidth = 1.5) +
  
  facet_wrap(~ `Type Of Operation`,
             scales = "free_y") +
  
  theme_minimal() +
  
  theme(
    axis.text.x = element_text(
      angle = 90,
      vjust = 0.5
    ),
    
    legend.position = "bottom"
  ) +
  
  scale_y_continuous(
    labels = scales::comma
  ) +
  
  labs(
    title = "Developed vs Developing Maritime Trade",
    
    subtitle =
      "Average maritime trade volume by economic classification",
    
    x = "Year",
    y = "Average Volume",
    color = "Economic Group"
  )
##################################################
# 15. Summary Insights
##################################################

# The analysis indicates that global maritime trade has expanded significantly
# over the examined period, particularly in dry cargo transportation.

# Asia demonstrates strong dominance in dry cargo loading and discharging,
# reflecting its central role in global manufacturing and trade flows.

# Net dry cargo trade highlights regional differences between export-oriented
# and import-oriented maritime activity.

# Crude oil trade patterns vary significantly across regions, reflecting
# differences in energy production, refining capacity, and import demand.

# The COVID-19 period appears to have affected global maritime operations,
# particularly dry cargo flows.

# The analysis highlights the rapid expansion of global maritime
# trade during the last decade, with developing economies
# demonstrating significantly stronger growth across most cargo categories.

# Dry cargo transportation emerged as the dominant trade segment,
# reflecting industrial expansion, manufacturing growth,
# and increasing globalization.

# In contrast, developed economies displayed slower but more stable
# growth patterns, consistent with mature trade systems
# and established logistics infrastructure.

# Overall, the findings suggest a continuing shift of global maritime
# trade activity toward developing regions and emerging economies.