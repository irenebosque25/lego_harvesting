
all_products2 <- read_csv("data/all_products2.csv")
years_products <- read_csv("data/years_products.csv")

colSums(is.na(all_products2))

all_products2 <- all_products2 |> 
  drop_na(price_link) 

years_products <- years_products |> 
  select(Name, year) |> 
  distinct(Name, .keep_all = TRUE)

all <- years_products |> 
  left_join(all_products2, by="Name") |> 
  drop_na()

pieces_category <- all |> 
  filter(year <= 2020) |> 
  group_by(category_name) |>         
  slice_max(order_by = Pieces, n = 15, with_ties = FALSE) %>% 
  ungroup()

# URL de ejemplo (puedes reemplazarla con el link que tengas)
url_guide <- "http://www.bricklink.com/catalogPG.asp?S=43222-1&ColorID=0"

# Leer la página
page_guide <- read_html(url_guide)

# Extraer el "Times Sold"
times_sold <- page_guide %>% 
  xml_find_first("//table[@class='fv']//tr[1]//td[2]/b") %>% 
  html_text(trim = TRUE)

# Extraer el "Total Qty"
total_qty <- page_guide %>%
  xml_find_first("//table[@class='fv']//tr[2]//td[2]/b") %>%
  html_text(trim = TRUE)

# Extraer el "Min Price"
min_price <- page_guide %>%
  xml_find_first("//table[@class='fv']//tr[3]/td[2]/b") %>%
  html_text(trim = TRUE)

# Extraer el "Avg Price"
avg_price <- page_guide %>%
  xml_find_first("//table[@class='fv']//tr[4]//td[2]/b") %>%
  html_text(trim = TRUE)

# Extraer el "Qty Avg Price"
qty_avg_price <- page_guide %>%
  xml_find_first("//table[@class='fv']//tr[5]//td[2]/b") %>%
  html_text(trim = TRUE)

# Extraer el "Max Price"
max_price <- page_guide %>%
  xml_find_first("//table[@class='fv']//tr[6]//td[2]/b") %>%
  html_text(trim = TRUE)

# Crear un tibble con los resultados
pieces_category <- tibble(
  Times_Sold = times_sold,
  Total_Qty = total_qty,
  Min_Price = min_price,
  Avg_Price = avg_price,
  Qty_Avg_Price = qty_avg_price,
  Max_Price = max_price)

results_guide

counter <- 0

# Lista de User-Agents para rotar
user_agents <- c(
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36",
  "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Firefox/89.0"
)

# Opcional: Proxy para evitar bloqueos (descomentar si lo necesitas)
# proxy_url <- "http://usuario:contraseña@proxy_ip:puerto"

# Función optimizada para evitar bloqueos
history_data <- function(price_link) {
  # Seleccionar un User-Agent aleatorio
  random_user_agent <- sample(user_agents, 1)
  
  # Headers para simular navegador real
  headers <- add_headers(
    "User-Agent" = random_user_agent,
    "Accept-Language" = "en-US,en;q=0.9",
    "Referer" = "https://google.com"
  )
  
  # Crear una sesión con cookies y User-Agent
  session <- tryCatch(html_session(price_link, headers), error = function(e) return(NULL))
  
  # Manejo de proxies (descomentar si usas proxy)
  # session <- tryCatch(html_session(price_link, headers, use_proxy(proxy_url)), error = function(e) return(NULL))
  
  if (is.null(session)) {
    print("Error al iniciar la sesión. Probablemente bloqueado.")
    return(tibble(Times_Sold = NA, Total_Qty = NA, Min_Price = NA, 
                  Avg_Price = NA, Qty_Avg_Price = NA, Max_Price = NA))
  }
  
  # Intentar leer el HTML de la página
  price_history_page <- tryCatch(read_html(session), error = function(e) return(NULL))
  
  # Si la página está bloqueada o devuelve CAPTCHA, guardar HTML para revisión
  if (is.null(price_history_page)) {
    print("Página bloqueada o CAPTCHA detectado. Guardando HTML...")
    writeLines(as.character(session), "error_page.html")
    return(tibble(Times_Sold = NA, Total_Qty = NA, Min_Price = NA, 
                  Avg_Price = NA, Qty_Avg_Price = NA, Max_Price = NA))
  }
  
  # Extraer datos con XPaths
  data <- tibble(
    Times_Sold = price_history_page %>%
      xml_find_first("//table[@class='fv']//tr[1]//td[2]/b") %>%
      html_text(trim = TRUE),
    
    Total_Qty = price_history_page %>%
      xml_find_first("//table[@class='fv']//tr[2]//td[2]/b") %>%
      html_text(trim = TRUE),
    
    Min_Price = price_history_page %>%
      xml_find_first("//table[@class='fv']//tr[3]/td[2]/b") %>%
      html_text(trim = TRUE),
    
    Avg_Price = price_history_page %>%
      xml_find_first("//table[@class='fv']//tr[4]//td[2]/b") %>%
      html_text(trim = TRUE),
    
    Qty_Avg_Price = price_history_page %>%
      xml_find_first("//table[@class='fv']//tr[5]//td[2]/b") %>%
      html_text(trim = TRUE),
    
    Max_Price = price_history_page %>%
      xml_find_first("//table[@class='fv']//tr[6]//td[2]/b") %>%
      html_text(trim = TRUE)
  )
  
  # Incrementar el contador de productos
  counter <<- counter + 1
  
  # Pausas con mayor variabilidad para evitar bloqueos
  if (counter %% 7 == 0) {
    pause_time <- runif(1, min = 20, max = 30)  # Pausa más larga cada 7 productos
  } else {
    pause_time <- runif(1, min = 10, max = 15)  # Pausa normal más larga
  }
  
  print(paste("Esperando", round(pause_time, 2), "segundos antes del próximo request..."))
  Sys.sleep(pause_time)
  
  return(data)
}

products_hp <- pieces_category |> 
  filter(category_name == "Harry Potter") |> 
  mutate(history_data = map(price_link, history_data)) 

products1 <- products_hp |> 
  unnest(history_data)

products_dis <- pieces_category |> 
  filter(category_name == "Disney") |> 
  mutate(history_data = map(price_link, history_data)) 

products2 <- products_dis |> 
  unnest(history_data)

products_sw <- pieces_category |> 
  filter(category_name == "Star Wars") |> 
  mutate(history_data = map(price_link, history_data)) 

products3 <- products_sw |> 
  unnest(history_data)

products_lotr <- pieces_category |> 
  filter(category_name == "The Hobbit and The Lord of the Rings") |> 
  mutate(history_data = map(price_link, history_data)) 

products4 <- products_lotr |> 
  unnest(history_data)

products_town <- pieces_category |> 
  filter(category_name == "Town") |> 
  mutate(history_data = map(price_link, history_data)) 

products5 <- products_town |> 
  unnest(history_data)

products_sm <- pieces_category |> 
  filter(category_name == "Super Mario") |> 
  mutate(history_data = map(price_link, history_data)) 

products6 <- products_sm |> 
  unnest(history_data)

products_sh <- pieces_category |> 
  filter(category_name == "Super Heroes") |> 
  mutate(history_data = map(price_link, history_data)) 

products7 <- products_sh |> 
  unnest(history_data)

final_products <- bind_rows(products1, products2, products3, products4, 
                         products5, products6, products7)

final_products <- final_products |> 
  clean_names()

final_products <- final_products |> 
  mutate(
    currency = str_extract(min_price, "^[A-Za-z]+"), # Extrae la moneda
    min_price = as.numeric(str_replace_all(str_extract(min_price, "[0-9,.]+"), ",", "")),
    avg_price = as.numeric(str_replace_all(str_extract(avg_price, "[0-9,.]+"), ",", "")),  
    qty_avg_price = as.numeric(str_replace_all(str_extract(qty_avg_price, "[0-9,.]+"), ",", "")),  
    max_price = as.numeric(str_replace_all(str_extract(max_price, "[0-9,.]+"), ",", "")))

exchange_rates <- c(
  "EUR" = 1,      # 1 EUR = 1 EUR
  "ILS" = 4.00,   # 1 ILS ≈ 0.25 EUR
  "GBP" = 0.85,   # 1 GBP ≈ 1.18 EUR
  "US"  = 1.08,   # 1 USD ≈ 0.93 EUR
  "ROL" = 4.97    # 1 ROL ≈ 0.20 EUR
)

final_products <- final_products |> 
  mutate(
    exchange_rate = exchange_rates[currency],  # Exchange rate based on the currency
    min_price = min_price / exchange_rate,
    avg_price = avg_price / exchange_rate,
    qty_avg_price = qty_avg_price / exchange_rate,
    max_price = max_price / exchange_rate) |> 
  select(-currency, -exchange_rate)

write.csv(final_products, "data/final_brick.csv", row.names = FALSE)

ui <- fluidPage(
  titlePanel("Products per category, prices and pieces"),
  verticalLayout(
      selectInput("x_var", 
                  label = "Select the variable for the X axis:", 
                  choices = c("min_price", "max_price", "avg_price"),
                  selected = "min_price"),
      plotlyOutput("scatter_plot", height = "600px")))

# Servidor para la aplicación
server <- function(input, output) {
  
  output$scatter_plot <- renderPlotly({
    # Selección dinámica del eje X con base en la variable seleccionada
    plot_data <- final_products %>%
      mutate(variable = case_when(
        input$x_var == "min_price" ~ min_price,
        input$x_var == "max_price" ~ max_price,
        input$x_var == "avg_price" ~ avg_price))
    
    # Crear gráfico con plotly
    p <- plot_ly(plot_data, x = ~variable, y = ~pieces, type = 'scatter', 
                 mode = 'markers', color = ~category_name, text = ~name,  # Mostrar el nombre del producto al pasar el cursor
                 hoverinfo = 'text+x+y') # Mostrar nombre, valor X y Y en el tooltip
    p })
}

shinyApp(ui = ui, server = server)
