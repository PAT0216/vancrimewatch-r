library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(readr)

# -- Load data ----------------------------------------------------------------
df <- read_csv("data/combined_crime_data_2023_2025.csv", show_col_types = FALSE)
df$year <- as.character(df$YEAR)

neighbourhoods <- sort(unique(df$NEIGHBOURHOOD))
crime_types <- sort(unique(df$TYPE))

# -- UI -----------------------------------------------------------------------
ui <- fluidPage(
    titlePanel("VanCrimeWatch (R)"),
    sidebarLayout(
        sidebarPanel(
            width = 3,
            selectInput(
                "neighbourhood",
                "Select Neighbourhood:",
                choices  = c("All" = "", neighbourhoods),
                selected = "",
                multiple = FALSE
            ),
            selectInput(
                "crime_type",
                "Select Crime Type:",
                choices  = c("All" = "", crime_types),
                selected = "",
                multiple = FALSE
            )
        ),
        mainPanel(
            width = 9,
            plotlyOutput("timeline_chart", height = "400px"),
            br(),
            DTOutput("data_table")
        )
    )
)

# -- Server -------------------------------------------------------------------
server <- function(input, output, session) {
    # Reactive calc: filter dataframe based on inputs
    filtered_data <- reactive({
        result <- df

        if (input$neighbourhood != "") {
            result <- result |> filter(NEIGHBOURHOOD == input$neighbourhood)
        }

        if (input$crime_type != "") {
            result <- result |> filter(TYPE == input$crime_type)
        }

        result
    })

    # Output 1: Crime timeline (monthly counts per year)
    output$timeline_chart <- renderPlotly({
        fdata <- filtered_data()

        month_labels <- c(
            "Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
        )

        grouped <- fdata |>
            group_by(year, MONTH) |>
            summarise(count = n(), .groups = "drop") |>
            mutate(month_label = factor(month_labels[MONTH],
                levels = month_labels
            ))

        p <- plot_ly(grouped,
            x = ~month_label, y = ~count, color = ~year,
            type = "scatter", mode = "lines+markers",
            hoverinfo = "text",
            text = ~ paste(year, "-", month_label, "<br>Incidents:", count)
        ) |>
            layout(
                title = "Crime Timeline (Monthly)",
                xaxis = list(title = "Month"),
                yaxis = list(title = "Incidents"),
                legend = list(orientation = "h", x = 0.3, y = -0.15),
                hovermode = "x unified"
            )

        p
    })

    # Output 2: Filtered data table
    output$data_table <- renderDT({
        filtered_data() |>
            select(TYPE, YEAR, MONTH, DAY, HOUR, NEIGHBOURHOOD, HUNDRED_BLOCK) |>
            datatable(
                options = list(pageLength = 10, scrollX = TRUE),
                rownames = FALSE
            )
    })
}

# -- Run app ------------------------------------------------------------------
shinyApp(ui, server)
