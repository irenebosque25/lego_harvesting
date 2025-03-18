# Lego Scraper for R

An R-based web scraping project to extract designed to extract historical price data from [BrickLink](https://www.bricklink.com/v2/main.page) a popular marketplace for [LEGO](https://www.lego.com/es-es) sets and pieces.

Our primary motivation for undertaking this project was to explore the factors that drive the revaluation of LEGO sets, to analyse how their prices change over time, and to identify which sets offer the highest return on investment. With these results, we can discover patterns that influence the desirability and long-term value of certain sets. As well as their possible adaptation to similar jobs.

## 📋 Requirements

Proper collection and subsequent analysis will require:

-   R and R Studio correctly installed and updated
-   Required packages: *rvest*, *xml2*, *httr*, *stringr*, *tidyverse*, *tibble*, *readr*

This project will not require any interaction with Web APIs or any open-source automation tool such as Selenium.

## 🔎How it works?

This project aims to collect information about the market price of second-hand Legos in the following categories selected: *Town*, *Disney*, *Harry Potter*, *Jurassic Park*, *The Hobbit and The Lord of the Rings*, *Super Heroes*, *Star Wars* and *Super Mario*.

To do this, we created an Rmd document with which, using different web scraping tools within R, we were able to extract relevant information about the sets of these categories.

### Summary of the project

The project uses exclusively R language and is divided into these main sections:

-   Bricklink environment familiarization

-   Select the main categories on the sets page

-   Scraping process to obtain all the sets available

-   Final data harvesting to obtain all the relevant product data:

    -   Name and link

    -   Number of pieces

    -   Year of the product

    -   Historical product prices

## 📊 Extracted Data

## 

#### 🤝 All type of contributions and improvements are welcome!
