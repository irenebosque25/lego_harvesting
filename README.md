# Lego Scraper for R

An R-based web scraping project to extract designed to extract historical price data from [BrickLink](https://www.bricklink.com/v2/main.page) a popular marketplace for LEGO sets and pieces and the official [LEGO](https://www.lego.com/es-es) website.

## Motivation

The primary motivation for undertaking this project was to explore the factors that drive the revaluation of LEGO sets, analyze how their prices change over time, and identify which sets offer the highest return on investment. The insights gathered can help discover patterns that influence certain sets' desirability and long-term value. Additionally, these findings serve as a foundation for similar projects in the future.

This repository was created as part of the final project for the *Data Harvesting* course in the **Master's program in Computational Social Sciences** at **Universidad Carlos III de Madrid**.

## Requirements

For proper collection and subsequent analysis, you'll need:

R and R Studio correctly installed and updated.

This project does not require any interaction with Web APIs or open-source automation tools like Selenium. However, to fully perform the analysis, a VPN switching tool is necessary to extract all the information from the product's price guide. After testing several options, we found [**SurfShark**](https://surfshark.com/es/deal/brand?coupon=fullsecurity&utm_campaign=21583930782&utm_content=165430878465&matchtype=e&device=c&gclid=Cj0KCQjw1um-BhDtARIsABjU5x5KCaue4QmdT-cDnIekwASUQzPcKeblzWVoQLai0GT1jKbIZhgDeWMaAp7AEALw_wcB&creative=709813049223&utm_term=surfshark&utm_source=google&utm_medium=cpc&gad_source=1) to be the most useful tool for analyzing different products without getting blocked by the website. Any other VPN tool can be used, but it's important to note that only 17 product prices could be scraped without receiving missing values.

## How Does It Work?

This project aims to collect market price information for second-hand LEGO sets in the following selected categories:

-   Town

-   Disney

-   Harry Potter

-   The Hobbit and The Lord of the Rings

-   Super Heroes

-   Star Wars

-   Super Mario

### Project Overview

The project exclusively uses the R language and is divided into the following main sections:

1.  **Web Scraping on the Official LEGO Website**: Collecting relevant data from the official LEGO site.

2.  **BrickLink Environment Familiarization**: Understanding the BrickLink platform and data structure.

3.  **Selecting Main Categories on the Sets Page**: Identifying the most relevant categories for the analysis.

4.  **Scraping Process**: Collecting data for all available sets.

5.  **Final Data Harvesting**: Extracting the most relevant product data, which includes:

    -   Product Name and Link

    -   Number of Pieces

    -   Year of the Product

    -   Historical Product Prices (Note: This step requires VPN switching)

        All prices were either expressed in euros or converted into euros using current exchange rates.

## Running the Project

To run the project, you’ll need to execute the provided Rmd document. Ensure that you have installed all necessary packages, set up your VPN, and follow the instructions in the notebook.

### Step-by-Step Guide

1.  **Set Up Environment**: Install the required packages.

2.  **Scraping Data**: Follow the steps in the Rmd document to scrape LEGO product data.

3.  **Data Analysis**: Use the gathered data for further analysis, such as tracking price trends and identifying valuable sets.

## Extracted Data

## ![](images/lego_harvesting.jpg)

#### 🤝 All types of contributions and improvements are welcome!
