# Covid-19-Global-Analytics-with-SQL-Tableau

## Overview

The COVID-19 pandemic dramatically impacted countries worldwide, with differing infection rates, mortality, and vaccination responses. This project explores global COVID-19 data to uncover trends in infections, deaths, and vaccination progress across countries and continents. Using SQL for deep data exploration and Tableau for interactive visualization, I created a data-driven story that highlights the pandemic’s global trajectory and response effectiveness.

## Dataset

The project uses COVID-19 data from [Our World in Data](https://ourworldindata.org/coronavirus), which provides global, daily statistics on infections, deaths, and vaccinations. This dataset offers a comprehensive view of the pandemic’s impact across countries and over time, making it ideal for analysis and visualization.

## Methodology

1. **Data Cleaning & Preparation**  
   - Explored the dataset for inconsistencies and missing values.  
   - Converted date fields, numeric metrics, and population data into proper formats.  
   - Split the original dataset into deaths and vaccinations tables for targeted analysis.  

2. **SQL Analysis & Metric Calculation**  
   - Computed key metrics such as **death percentages**, **infection rates relative to population**, and **cumulative vaccination counts**.  
   - Leveraged **window functions** to calculate rolling totals and trends over time.  
   - Used **CTEs and temporary tables** to structure complex queries for ease of analysis.  
   - Identified top 10 countries by case fatality rate and most affected countries by total cases.  
   - Aggregated global cases and deaths to understand worldwide trends and peaks.  

3. **Data Visualization with Tableau**  
   - Designed an **interactive dashboard** to present insights clearly and intuitively.  
   - Built visualizations including **dual-axis charts, heatmaps, bar charts, and time series**.  
   - Enabled filters and interactivity for users to explore trends by **country, continent, and year**.  
   - Highlighted population-adjusted metrics to provide context beyond absolute numbers.  

## Tableau Dashboard

The Tableau dashboard tells a clear story of the pandemic’s global impact, allowing users to explore trends and compare countries. Key features include:

- **Global Cases vs Deaths** – Dual-axis chart showing total cases and deaths worldwide from 2020 to 2024.  
- **Top 10 Countries by Case Fatality Rate** – Highlights countries with the highest death percentages relative to confirmed cases.  
- **Global Spread by Population Percentage** – Visualizes the proportion of each country’s population affected.  
- **Top 10 Most Affected Countries** – Bar chart showing countries with the highest total cases.  
- **Yearly Trends (2020–2024)** – Interactive timeline with a filter to examine yearly changes in cases and deaths.

[View the dashboard here](https://public.tableau.com/app/profile/naima.rashid/viz/Covid-19ImpactAnalysis2020-2024/Dashboard1)

## Key Insights

- Certain countries had disproportionately high death rates relative to case counts.  
- Vaccination campaigns had a clear impact on slowing infection and death growth.  
- Population-adjusted metrics revealed countries most affected relative to their size.  
- Pandemic trends varied across continents, showing the global variability of COVID-19 impact.

## Tools & Technologies

- **SQL (Microsoft SQL Server)** – Data cleaning, aggregation, and analysis  
- **Tableau Public** – Interactive dashboard creation and visualization  
- **Our World in Data** – COVID-19 dataset source

## Conclusion

This project illustrates the profound global impact of COVID-19, revealing how infections, deaths, and vaccination efforts varied across countries and populations. By analyzing trends and comparing regions, it highlights both the human and statistical dimensions of the pandemic.  

Through this project, I gained hands-on experience in **data cleaning, advanced SQL analysis, and interactive visualization with Tableau**. I strengthened my ability to transform raw datasets into meaningful insights, apply complex calculations like rolling totals and population-adjusted metrics, and present findings in a clear, story-driven way. This work reinforced my skills in **data-driven storytelling, analytical thinking, and visualization**, preparing me to tackle real-world data challenges in professional settings.
