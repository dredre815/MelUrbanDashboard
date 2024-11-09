library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinyjs)

# Tableau Public URLs
tableau_urls <- list(
  pedestrian_trends = "https://public.tableau.com/views/PedestrianTrendsMelbourne/TotalofDirectionsbyDates?:showVizHome=no&:embed=true",
  pedestrian_map = "https://public.tableau.com/views/MelbourneCityPedestrianTrafficMap/2?:showVizHome=no&:embed=true",
  foot_traffic_tram = "https://public.tableau.com/views/1_17295736156950/3?:showVizHome=no&:embed=true",
  crash_heatmap = "https://public.tableau.com/views/Accidentheatmap/Sheet3?:showVizHome=no&:embed=true",
  crash_location_map = "https://public.tableau.com/views/Accidentlocationmap/Sheet2?:showVizHome=no&:embed=true"
)

# Define the UI for the Shiny app
ui <- dashboardPage(
  dashboardHeader(title = "Melbourne Urban Mobility Insights"),
  
  # Create the sidebar menu
  dashboardSidebar(
    sidebarMenu(
      # Menu items for different sections of the dashboard
      menuItem("General View", tabName = "general_view", icon = icon("dashboard")),
      menuItem("Pedestrian Dynamics", tabName = "pedestrian", icon = icon("walking")),
      menuItem("Public Transport", tabName = "transport", icon = icon("bus")),
      menuItem("Road Safety", tabName = "safety", icon = icon("shield-alt"))
    )
  ),
  dashboardBody(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
        .wrapper { background-color: transparent!important; }
        
        /* Set light background color for content area */
        .content-wrapper, .right-side { background-color: #FBFBFB; }
        .skin-blue .main-header .logo { background-color: #2c3e50; }
        .skin-blue .main-header .navbar { background-color: #34495e; }
        
        .skin-blue .main-sidebar { background-color: #EEEFF2; }
        
        /* Style boxes with a top border and subtle shadow */
        .box { 
          border-top: 3px solid #3498db; 
          box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24); 
        }
        
        /* Style box headers */
        .box-header { 
          border-bottom: 1px solid #f4f4f4; 
          background-color: #ffffff; 
        }
        .box-title { font-size: 18px; color: #2c3e50; }
        
        /* Highlight active tab */
        .nav-tabs-custom > .nav-tabs > li.active { border-top-color: #3498db; }
        
        /* Style primary buttons */
        .btn-primary { 
          background-color: #3498db; 
          border-color: #2980b9; 
        }
        .btn-primary:hover, .btn-primary:focus { 
          background-color: #2980b9; 
          border-color: #2471a3; 
        }
        
        .tableau-viz { border: none; }
        
        /* Style insight boxes */
        .insight-box { 
          background-color: #ecf0f1; 
          border-left: 5px solid #3498db; 
          padding: 15px; 
          margin-bottom: 20px; 
        }
        .insight-box h4 { color: #2c3e50; margin-top: 0; }
        .insight-box p { color: #34495e; }
        /* Styles for the welcome box */
        .welcome-box {
          text-align: center;
          padding: 30px;
          background: linear-gradient(to bottom right, #34BCDB, #312C50);
          color: white;
          border-radius: 10px;
          margin-bottom: 20px;
        }

        /* Specific background styles for different sections */
        .welcome-box.pedestrian {
          background: linear-gradient(to bottom right, #3498db, #2c3e50);
        }
        .welcome-box.transport {
          background: linear-gradient(135deg, #27ae60, #2c3e50);
        }
        .welcome-box.safety {
          background: linear-gradient(135deg, #e74c3c, #2c3e50);
        }

        /* Styles for the welcome box heading */
        .welcome-box h2 {
          font-size: 2.5em;
          margin-bottom: 20px;
        }

        /* Styles for the welcome box paragraph */
        .welcome-box p {
          color: #F2F2F2;
          max-width: 600px;
        }
        /* Styles for stat cards */
        .stat-card {
          transition: transform 0.3s;
        }
        .stat-card:hover {
          transform: translateY(-5px);
        }
        .stat-card .small-box {
          border-radius: 12px;
          background-color: #fff!important;
          border: 1px solid #F3F3F3;
          overflow: hidden;
        }
        .stat-card .small-box .icon-large {
          font-size: 120px;
          top: 0px;
        }
        .stat-card .small-box .inner {
          padding: 16px;
        }
        .stat-card .small-box p {
          color: #000!important; /* Black text color for paragraphs */
        }
        .stat-card .small-box span {
          color: #8E8E8E;
          font-size: 12px;
        }
        /* Styles for blue background elements */
        .bg-blue .icon-large {
          color: rgba(0, 115, 183, 0.3)!important;
        }
        .bg-blue h3 {
          color: rgba(0, 115, 183, 1)!important;
        }

        /* Styles for green background elements */
        .bg-green .icon-large {
          color: rgba(0, 166, 90, 0.2)!important;
        }
        .bg-green h3 {
          color: rgba(0, 166, 90, 1)!important;
        }

        /* Styles for red background elements */
        .bg-red .icon-large {
          color: rgba(221, 75, 57, 0.2)!important;
        }
        .bg-red h3 {
          color: rgba(221, 75, 57, 1)!important;
        }

        /* Styles for purple background elements */
        .bg-purple .icon-large {
          color: rgba(96, 92, 168, 0.2)!important;
        }
        .bg-purple h3 {
          color: rgba(96, 92, 168, 1)!important;
        }

        /* Styles for insights container */
        .insights-container {
          display: flex;
          justify-content: space-between;
          margin-left: -15px;
          margin-right: -15px;
          flex-wrap: wrap;
          margin-top: 15px;
        }
        /* Styles for insight boxes */
        .insight-box {
          flex-basis: calc(33.33% - 20px);
          margin-bottom: 20px;
          padding: 20px;
          border-radius: 12px;
          background-color: #EEEFF2;
          transition: transform 0.3s, box-shadow 0.3s; /* Smooth transition for hover effects */
          height: 100%;
        }
        
        /* Hover effect for insight boxes */
        .insight-box:hover {
          transform: translateY(-5px);
          box-shadow: 0 6px 8px rgba(0,0,0,0.15);
        }
        
        /* Style for icons inside insight boxes */
        .insight-box i {
          font-size: 2em;
          margin-bottom: 10px;
          color: #3498db;
        }
        
        /* Style for headings inside insight boxes */
        .insight-box h4 {
          font-weight: bold;
        }
        
        /* Style for paragraphs inside insight boxes */
        .insight-box p {
          color: #7F7F7F!important;
        }
        .quick-nav {
          display: flex;
          justify-content: space-around;
          margin-top: 20px;
        }
        .quick-nav .btn {
          padding: 10px 20px;
          font-size: 1.1em;
        }

        /* Animation for fade in left */
        .animated {
          animation-duration: 1s;
          animation-fill-mode: both;
        }
        @keyframes fadeInLeft {
          from {
            opacity: 0;
            transform: translate3d(-100%, 0, 0);
          }
          to {
            opacity: 1;
            transform: translate3d(0, 0, 0);
          }
        }
        .fadeInLeft {
          animation-name: fadeInLeft;
        }

        /* Styles for pedestrian header */
        .pedestrian-header {
          background: linear-gradient(135deg, #3498db, #2c3e50); /* Blue gradient background */
          color: white;
          padding: 20px;
          border-radius: 10px;
          margin-bottom: 20px;
        }
        .pedestrian-header h2 {
          margin-top: 0;
        }

        /* Styles for viz container */
        .viz-container {
          background-color: #fff;
          border-radius: 10px;
          box-shadow: 0 4px 6px rgba(0,0,0,0.1);
          margin-bottom: 20px;
          overflow: hidden;
        }

        /* Styles for viz header */
        .viz-header {
          background-color: #f8f9fa;
          padding: 15px;
          border-bottom: 1px solid #e9ecef;
          display: flex;
          justify-content: space-between;
          align-items: center;
        }
        .viz-header h3 {
          margin: 0;
        }

        /* Styles for tableau viz wrapper */
        .tableau-viz-wrapper {
          margin-top: 15px;
          background-color: #FAFAFA; /* Light gray background */
        }
        .insights-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); /* Responsive grid */
          gap: 20px;
          margin-top: 15px;
        }
        .insight-item {
          background-color: #EEEFF2;
          border-radius: 10px;
          padding: 15px;
          text-align: center;
          transition: transform 0.3s, box-shadow 0.3s; /* Smooth transition for hover effects */
        }
        .insight-item:hover {
          transform: translateY(-5px);
          box-shadow: 0 6px 8px rgba(0,0,0,0.15); /* Add shadow on hover */
        }
        .insight-item i {
          font-size: 2em;
          color: #3498db;
          margin-bottom: 10px;
        }
        .insight-item h4{
          font-weight: bold;
        }

        /* Styles for transport header */
        .transport-header {
          background: linear-gradient(135deg, #27ae60, #2c3e50); /* Green gradient background */
          color: white;
          padding: 20px;
          border-radius: 10px;
          margin-bottom: 20px;
        }
        .transport-header h2 {
          margin-top: 0;
        }
        .safety-header {
          background: linear-gradient(135deg, #e74c3c, #2c3e50);
          color: white;
          padding: 20px;
          border-radius: 10px;
          margin-bottom: 20px;
        }
        .safety-header h2 {
          margin-top: 0;
        }
        body{
          height: 100vh!important;
        }
        .wrapper{
          height: 100%!important;
        }
        .content-wrapper{
          min-height: 100%!important;
        }
        .main-header{
          display: none;
        }
        /* Styles for the collapsed sidebar */
        #sidebarCollapsed {
            position: fixed;
            background: 
                /* Add logo to the top left of the sidebar */
                url(https://ms300k-han.s3.ap-northeast-1.amazonaws.com/IV/logo.svg) no-repeat left 20px top 30px,
                /* Create a gradient background */
                linear-gradient(to bottom right, #EEEFF2 0%, #DAF1EB 50%, #C9D4E9 100%);
            background-size: auto 36px, cover; 
            padding-top: 80px;
            box-shadow: 0px 0px 16px rgba(255, 255, 255, 0.2);
            border-right: 1px solid #E2E2E2;
        }

        /* Styles for expanded sidebar items */
        #sidebarItemExpanded {
          padding-left: 15px;
          padding-right: 15px;
        }
        .sidebar-menu>li{
          margin-top: 15px;
          border-radius: 12px;
          overflow: hidden;
        }
        .sidebar-menu>li>a{
          border-left: none!important;
          color: #7590A1!important;
        }
        .sidebar-menu>li>a>i{
          margin-right: 8px;
          width: 16px;
          text-align: center;
        }
        .sidebar-menu>li:hover>a{
          color: #7590A1!important;
          background: #E2E2E3!important; /* Light gray background on hover */
        }
        .sidebar-menu>li.active>a{
          color: #234A62!important;
          font-weight: bold;
          background: #fff!important;
          box-shadow: 0px 0px 16px rgba(255, 255, 255, 0.2); /* Add shadow to active item */
        }
        .content{
          padding: 24px;
        }
        .welcome-box{
          position: relative;
        }
        .welcome-box{
          margin-left: 15px;
          margin-right: 15px;
          text-align: left;
        }
        .welcome-box>h2{
          margin-top: 0px;
          font-weight: bold;
        }
        .welcome-box>p{
          font-size: 16px;
        }

        /* Styles for the start exploring button */
        .btn-banner{
          border: none!important;
          background: #23384C;
          color: #fff;
          position: absolute;
          right: 30px;
          top: 50%;
          height: 48px;
          padding: 6px 24px;
          border-radius: 8px;
          transform: translate(0px, -50%);
          outline: none;
        }
        .btn-banner:hover{
          background: #2D445A;
          color: #fff;
          outline: none;
        }
        .btn-banner:active{
          background: #0E263C;
          color: #fff;
          outline: none;
        }
        .key-insights{
          margin-left: 15px;
          margin-right: 15px;
          padding-top: 24px;
          border-top: 1px solid #F3F3F3;
        }
        .key-insights h3{
          margin-top: 0px;
        }

        /* Styles for card border */
        .card-border{
          border: 1px solid #F3F3F3;
        }
        .viz-footer{
          background-color: #FAFAFA;
          padding: 15px;
          border-top: 1px solid #EBEBEB; /* Add border to the top of the footer */
        }
        .viz-footer h4{
          font-weight: bold;
        }
        .viz-footer > div{
          display: flex;
          align-items: center;
          color: #2C7396;
        }
        .viz-footer > div i {
          margin-right: 4px;
        }
        .btn-info{
          background-color: #dadada;
          border-color: transparent!important; /* Transparent border */
        }
        @media (max-width: 767px){
          .main-header{
            display: block;
          }
        }
        .quick-nav-section {
          margin-top: 30px;
          text-align: center;
        }

        .quick-nav {
          display: flex;
          justify-content: space-around;
          margin-top: 15px;
        }

        .quick-nav .btn {
          padding: 10px 20px;
          font-size: 1.1em;
        }

        .news-feed, .city-overview {
          background-color: #fff;
          border-radius: 10px;
          padding: 20px;
          margin-top: 30px;
          box-shadow: 0 4px 6px rgba(0,0,0,0.1); /* Add shadow to the card */
        }

        .news-feed h3, .city-overview h3 {
          margin-top: 0;
          color: #2c3e50; /* Darker text color */
        }

        .news-feed ul {
          padding-left: 20px;
        }

        .news-feed li {
          margin-bottom: 10px;
        }

        .city-overview p {
          margin-bottom: 5px;
        }

        /* Styles for did you know section */
        .did-you-know {
          background-color: #f8f9fa;
          border-radius: 10px;
          padding: 20px;
          margin-top: 30px;
          text-align: center;
        }

        .did-you-know h3 {
          margin-top: 0;
          color: #2c3e50;
        }

        .did-you-know i {
          font-size: 2em;
          color: #f39c12;
          margin-bottom: 10px;
        }

        .info-card {
          background-color: #fff;
          border-radius: 10px;
          padding: 20px;
          margin-top: 30px;
          box-shadow: 0 4px 10px rgba(0,0,0,0.1); /* Add shadow to the card */
          transition: all 0.3s ease;
          height: 350px;
          display: flex;
          flex-direction: column;
        }

        .info-card:hover {
          transform: translateY(-5px);
          box-shadow: 0 6px 15px rgba(0,0,0,0.15);
        }

        .info-card h3 {
          color: #2c3e50;
          margin-bottom: 20px;
          border-bottom: 2px solid #ecf0f1; /* Add border to the bottom of the header */
          padding-bottom: 10px;
          font-size: 22px;
        }

        .info-card h3 i {
          margin-right: 10px;
        }

        .latest-updates .news-item {
          margin-bottom: 5px;
        }

        .latest-updates .news-item h4 {
          font-size: 16px;
          margin-bottom: 2px;
          color: #34495e;
        }

        .latest-updates .news-item p {
          font-size: 14px;
          line-height: 1;
          color: #7f8c8d;
        }

        .city-glance .glance-item {
          display: flex;
          align-items: center;
          margin-bottom: 14px;
          font-size: 16px;
        }

        .city-glance .glance-item i {
          margin-right: 10px;
          color: #3498db;
          width: 20px;
          font-size: 18px;
        }

        .did-you-know .fact-content {
          flex-grow: 1;
          display: flex;
          align-items: center;
          justify-content: center;
        }

        .did-you-know p {
          font-style: italic;
          color: #34495e;
          font-size: 18px;
          text-align: center;
          margin: 0;
        }

        .did-you-know .fact-button {
          margin-top: 20px;
        }

        #new_fact {
          width: 100%;
        }
      "))
    ),
    tabItems(
      # General View Tab
      tabItem(tabName = "general_view",
        fluidRow(
          div(
            class = "welcome-box",
            h2("Explore Melbourne's Urban Pulse"),
            p("Dive into comprehensive insights on pedestrian dynamics, public transport, and road safety."),
            actionButton("start_exploring", "Start Exploring", class = "btn-banner")
          )
        ),
        fluidRow(
          column(
            width = 3,
            div(
              class = "stat-card",
              valueBoxOutput("total_pedestrians", width = NULL)
            )
          ),
          column(
            width = 3,
            div(
              class = "stat-card",
              valueBoxOutput("avg_tram_frequency", width = NULL)
            )
          ),
          column(
            width = 3,
            div(
              class = "stat-card",
              valueBoxOutput("total_accidents", width = NULL)
            )
          ),
          column(
            width = 3,
            div(
              class = "stat-card",
              valueBoxOutput("busiest_pedestrian_area", width = NULL)
            )
          )
        ),
        fluidRow(
          div(
            class = "key-insights",
            h3("Key Insights"),
            div(
              class = "insights-container",
              column(
                width = 4,
                div(
                  class = "insight-box animated fadeInLeft",
                  icon("walking"),
                  h4("Pedestrian Traffic Patterns"),
                  p("Weekday foot traffic is 30% higher than weekend traffic, with peak hours between 8-9 AM and 5-6 PM.")
                )
              ),
              column(
                width = 4,
                div(
                  class = "insight-box animated fadeInLeft",
                  icon("bus"),
                  h4("Public Transport Utilization"),
                  p("Tram frequency is positively correlated with foot traffic, suggesting an opportunity for optimizing schedules.")
                )
              ),
              column(
                width = 4,
                div(
                  class = "insight-box animated fadeInLeft",
                  icon("exclamation-triangle"),
                  h4("Road Safety Hotspots"),
                  p("Intersections in the CBD have the highest crash frequency, particularly during peak hours and wet weather conditions.")
                )
              )
            )
          )
        ),
        fluidRow(
          column(
            width = 4,
            div(
              class = "info-card latest-updates",
              h3(icon("newspaper"), "Latest Updates"),
              div(
                class = "news-item",
                h4("Metro Tunnel Nears Completion"),
                p("Three of the five new stations are complete, with Anzac Station expected to open in 2025, transforming city transport.")
              ),
              div(
                class = "news-item",
                h4("New Bike Lanes Completed"),
                p("The final stretch of protected bike lanes on St Kilda Road has been finished, improving cyclist safety.")
              ),
              div(
                class = "news-item",
                h4("Smart Crossings Expand"),
                p("AI-powered pedestrian crossings are being rolled out across more intersections to boost safety.")
              )
            )
          ),
          column(
            width = 4,
            div(
              class = "info-card city-glance",
              h3(icon("city"), "Melbourne at a Glance"),
              div(
                class = "glance-item",
                icon("users"),
                span("Population: 5.31 million (2025 estimate)")
              ),
              div(
                class = "glance-item",
                icon("expand"),
                span(HTML("Area: 9,993 km&sup2;"))
              ),
              div(
                class = "glance-item",
                icon("train"),
                span("Public Transport: 250+ tram stops, 220+ train stations")
              ),
              div(
                class = "glance-item",
                icon("plane-arrival"),
                span("Annual Visitors: 3.1 million international (2024)")
              ),
              div(
                class = "glance-item",
                icon("tree"),
                span("Green Spaces: 480+ hectares of parks and gardens")
              ),
            )
          ),
          column(
            width = 4,
            div(
              class = "info-card did-you-know",
              h3(icon("lightbulb"), "Did You Know?"),
              div(
                class = "fact-content",
                uiOutput("random_fact")
              ),
              div(
                class = "fact-button",
                actionButton("new_fact", "Another fact", icon = icon("sync"))
              )
            )
          )
        )
      ),
      
      # Pedestrian Dynamics Tab
      tabItem(tabName = "pedestrian",
        fluidRow(
          div(
            class = "welcome-box pedestrian",
            h2("Pedestrian Dynamics in Melbourne"),
            p("Explore detailed pedestrian traffic patterns across Melbourne's CBD. Use the interactive visualizations to analyze trends, identify hotspots, and inform urban planning decisions."),
            actionButton("pedestrian_info", "Learn More", class = "btn-banner")
          )
        ),
        fluidRow(
          column(
            width = 6,
            div(
              class = "viz-container card-border",
              div(
                class = "viz-header",
                h3("Weekly Pedestrian Traffic Trends"),
                actionButton("trends_info", "", icon = icon("info-circle"), class = "btn-sm btn-info")
              ),
              div(
                class = "tableau-viz-wrapper",
                tags$iframe(src = tableau_urls$pedestrian_trends, height = "500px", width = "100%", class = "tableau-viz")
              ),
              div(
                class = "viz-footer",
                div(
                  icon("chart-line"),
                  h4("Key Observation"),
                ),
                p("Weekday foot traffic peaks during morning and evening rush hours, while weekend patterns show a more distributed flow throughout the day.")
              )
            )
          ),
          column(
            width = 6,
            div(
              class = "viz-container card-border",
              div(
                class = "viz-header",
                h3("Pedestrian Traffic Map"),
                actionButton("map_info", "", icon = icon("info-circle"), class = "btn-sm btn-info")
              ),
              div(
                class = "tableau-viz-wrapper",
                tags$iframe(src = tableau_urls$pedestrian_map, height = "500px", width = "100%", class = "tableau-viz")
              ),
              div(
                class = "viz-footer",
                div(
                  icon("map-marked-alt"),
                  h4("Hotspot Analysis"),
                ),
                p("The CBD and major shopping districts consistently show the highest pedestrian activity, suggesting potential areas for infrastructure improvements or business opportunities.")
              )
            )
          )
        ),
        fluidRow(
          div(
            class = "key-insights", 
            h3("Pedestrian Insights"),
            div(
              class = "insights-grid",
              div(
                class = "insight-item",
                icon("users"),
                h4("8-9 AM and 5-6 PM on weekdays"),
                p("Peak Hours")
              ),
              div(
                class = "insight-item",
                icon("calendar-alt"),
                h4("Friday"),
                p("Busiest Day")
              ),
              div(
                class = "insight-item",
                icon("map-pin"),
                h4("Flinders Street Station"),
                p("Top Location")
              ),
              div(
                class = "insight-item",
                icon("percentage"),
                h4("30% less traffic on weekends"),
                p("Weekend vs Weekday")
              )
            )
          )
        )
      ),
      
      # Public Transport Tab
      tabItem(tabName = "transport",
        fluidRow(
          div(
            class = "welcome-box transport",
            h2("Public Transport Analysis in Melbourne"),
            p("Analyze the relationship between foot traffic and tram departure frequency. Use these insights to optimize public transport schedules and improve urban mobility."),
            actionButton("transport_info", "Learn More", class = "btn-banner")
          )
        ),
        fluidRow(
          column(
            width = 12,
            div(
              class = "viz-container card-border",
              div(
                class = "viz-header",
                h3("Foot Traffic and Tram Departure Frequency"),
                actionButton("tram_info", "", icon = icon("info-circle"), class = "btn-sm btn-info")
              ),
              div(
                class = "tableau-viz-wrapper",
                tags$iframe(src = tableau_urls$foot_traffic_tram, height = "600px", width = "100%", class = "tableau-viz")
              ),
              div(
                class = "viz-footer",
                div(
                  icon("chart-line"),
                  h4("Correlation Analysis"),
                ),
                p("There's a strong positive correlation between tram frequency and foot traffic, particularly during peak hours. This suggests an opportunity to fine-tune tram schedules to better match demand.")
              )
            )
          )
        ),
        fluidRow(
          div(
            class = "key-insights", 
            h3("Key Transport Insights"),
            div(
              class = "insights-grid",
              div(
                class = "insight-item",
                icon("clock"),
                h4("7-9 AM and 4-6 PM on weekdays"),
                p("Peak Hours")
              ),
              div(
                class = "insight-item",
                icon("users"),
                h4("Routes 96, 86, and 19"),
                p("Busiest Tram Routes")
              ),
              div(
                class = "insight-item",
                icon("map-marker-alt"),
                h4("CBD, St Kilda, and Brunswick"),
                p("High Demand Areas")
              ),
              div(
                class = "insight-item",
                icon("percentage"),
                h4("10% increase in frequency leads to 7% increase in ridership"),
                p("Tram Frequency Impact")
              )
            )
          )
        )
      ),
      
      # Road Safety Tab
      tabItem(tabName = "safety",
        fluidRow(
          div(
            class = "welcome-box safety",
            h2("Road Safety Analysis in Melbourne"),
            p("Explore car crash patterns and distributions across Melbourne. Use these insights to identify high-risk areas and inform targeted safety measures."),
            actionButton("safety_info", "Learn More", class = "btn-banner")
          )
        ),
        fluidRow(
          column(
            width = 6,
            div(
              class = "viz-container card-border",
              div(
                class = "viz-header",
                h3("Car Crash Frequency Heatmap"),
                actionButton("heatmap_info", "", icon = icon("info-circle"), class = "btn-sm btn-info")
              ),
              div(
                class = "tableau-viz-wrapper",
                tags$iframe(src = tableau_urls$crash_heatmap, height = "500px", width = "100%", class = "tableau-viz")
              ),
              div(
                class = "viz-footer",
                div(
                  icon("chart-line"),
                  h4("Temporal Patterns"),
                ),
                p("Crash frequencies peak during morning and evening rush hours, with a notable increase in incidents during wet weather conditions.")
              )
            )
          ),
          column(
            width = 6,
            div(
              class = "viz-container card-border",
              div(
                class = "viz-header",
                h3("Car Crash Location Map"),
                actionButton("location_info", "", icon = icon("info-circle"), class = "btn-sm btn-info")
              ),
              div(
                class = "tableau-viz-wrapper",
                tags$iframe(src = tableau_urls$crash_location_map, height = "500px", width = "100%", class = "tableau-viz")
              ),
              div(
                class = "viz-footer",
                div(
                  icon("map-marked-alt"),
                  h4("Spatial Analysis"),
                ),
                p("Major intersections in the CBD show the highest concentration of crashes. This information can guide targeted infrastructure improvements and traffic management strategies.")
              )
            )
          )
        ),
        fluidRow(
          div(
            class = "key-insights", 
            h3("Key Safety Insights"),
            div(
              class = "insights-grid",
              div(
                class = "insight-item",
                icon("clock"),
                h4("8-9 AM and 5-6 PM on weekdays"),
                p("Peak Accident Hours")
              ),
              div(
                class = "insight-item",
                icon("cloud-rain"),
                h4("30% increase in accidents during rainy conditions"),
                p("Weather Impact")
              ),
              div(
                class = "insight-item",
                icon("High-Risk Locations"),
                h4("CBD intersections and major arterial roads"),
                p("High-Risk Locations")
              ),
              div(
                class = "insight-item",
                icon("car-crash"),
                h4("Rear-end collisions (40% of all accidents)"),
                p("Most Common Type")
              )
            )
          )
        )
      )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # Use shinyjs to set the initial tab
  shinyjs::runjs("$('a[data-value=\"general_view\"]').tab('show');")

  # Render the total pedestrians value box
  output$total_pedestrians <- renderValueBox({
    valueBox(
      "1.2M",
      HTML("Total Pedestrians<br><span>Last 30 Days</span>"),
      icon = icon("walking"),
      color = "blue"
    )
  })
  
  # Render the average tram frequency value box
  output$avg_tram_frequency <- renderValueBox({
    valueBox(
      "5.7 min",
      HTML("Average Tram Frequency<br><span>&nbsp</span>"),
      icon = icon("clock"),
      color = "green"
    )
  })
  
  # Render the total accidents value box
  output$total_accidents <- renderValueBox({
    valueBox(
      "423",
      HTML("Total Accidents<br><span>Last 30 Days</span>"),
      icon = icon("exclamation-triangle"),
      color = "red"
    )
  })
  
  # Render the busiest pedestrian area value box
  output$busiest_pedestrian_area <- renderValueBox({
    valueBox(
      "CBD",
      HTML("Busiest Pedestrian Area<br><span>&nbsp</span>"),
      icon = icon("map-marker-alt"),
      color = "purple"
    )
  })
  
  # Add information modals
  observeEvent(input$pedestrian_info, {
    showModal(modalDialog(
      title = "About Pedestrian Dynamics Analysis",
      HTML("
        <p>This section provides detailed insights into pedestrian movement patterns across Melbourne. 
        The data is collected through sensors placed at key locations throughout the city. 
        Use this information to:</p>
        <ul>
          <li>Understand foot traffic trends and identify busy areas</li>
          <li>Plan urban development and infrastructure improvements</li>
          <li>Optimize retail locations and business hours</li>
          <li>Enhance public safety measures in high-traffic areas</li>
        </ul>
      "),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the transport info modal
  observeEvent(input$transport_info, {
    showModal(modalDialog(
      title = "About Public Transport Analysis",
      HTML("
        <p>This section analyzes the relationship between foot traffic and public transport frequency, 
        focusing on tram services. Use these insights to:</p>
        <ul>
          <li>Optimize tram schedules to match demand patterns</li>
          <li>Identify areas that may benefit from increased service frequency</li>
          <li>Plan for future public transport infrastructure developments</li>
          <li>Improve overall urban mobility and reduce congestion</li>
        </ul>
      "),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the safety info modal
  observeEvent(input$safety_info, {
    showModal(modalDialog(
      title = "About Road Safety Analysis",
      HTML("
        <p>This section provides insights into car crash patterns and distributions across Melbourne. 
        Use this information to:</p>
        <ul>
          <li>Identify high-risk areas and time periods for targeted safety measures</li>
          <li>Plan infrastructure improvements to enhance road safety</li>
          <li>Develop data-driven traffic management strategies</li>
          <li>Inform public safety campaigns and education initiatives</li>
        </ul>
      "),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  observeEvent(input$start_exploring, {
    showModal(modalDialog(
      title = "Welcome to Melbourne Urban Mobility Insights",
      HTML("This dashboard offers a comprehensive view of Melbourne's urban dynamics. Here's what you can explore:
      <ul>
        <li>General View: Get an overview of key statistics and latest updates about the city.</li>
        <li>Pedestrian Dynamics: Analyze foot traffic patterns and hotspots across the CBD.</li>
        <li>Public Transport: Examine the relationship between tram frequency and pedestrian activity.</li>
        <li>Road Safety: Investigate car crash patterns to identify high-risk areas.</li>
      </ul>
      Use the sidebar menu to navigate between these sections. Each tab provides interactive visualizations, key insights, and detailed analysis to help you understand Melbourne's urban pulse. Enjoy exploring!"),
      easyClose = TRUE,
      footer = modalButton("Got it!")
    ))
  })

  # Render the trends info modal
  observeEvent(input$trends_info, {
    showModal(modalDialog(
      title = "Weekly Pedestrian Traffic Trends",
      "This visualization shows the patterns of pedestrian traffic throughout the week. Use it to identify peak hours and compare weekday vs weekend trends.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the map info modal
  observeEvent(input$map_info, {
    showModal(modalDialog(
      title = "Pedestrian Traffic Map",
      "This map displays the distribution of pedestrian activity across Melbourne's CBD. Identify hotspots and areas with high foot traffic to inform urban planning decisions.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the tram info modal
  observeEvent(input$tram_info, {
    showModal(modalDialog(
      title = "Foot Traffic and Tram Departure Frequency",
      "This visualization shows the relationship between pedestrian foot traffic and tram departure frequency. Use it to identify opportunities for optimizing tram schedules and improving service efficiency.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the heatmap info modal
  observeEvent(input$heatmap_info, {
    showModal(modalDialog(
      title = "Car Crash Frequency Heatmap",
      "This heatmap visualizes the frequency of car crashes across different times and locations. Use it to identify high-risk periods and areas for targeted safety interventions.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Render the location info modal
  observeEvent(input$location_info, {
    showModal(modalDialog(
      title = "Car Crash Location Map",
      "This map shows the spatial distribution of car crashes in Melbourne. Identify accident hotspots to prioritize areas for infrastructure improvements and increased traffic management.",
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Quick navigation buttons
  observeEvent(input$to_pedestrian, {
    updateTabItems(session, "sidebarMenu", "pedestrian")
  })
  
  observeEvent(input$to_transport, {
    updateTabItems(session, "sidebarMenu", "transport")
  })
  
  observeEvent(input$to_safety, {
    updateTabItems(session, "sidebarMenu", "safety")
  })

  # Random fact generator
  facts <- reactiveVal(c(
    "Melbourne is often called the coffee capital of Australia, with a vibrant cafe culture that attracts coffee lovers worldwide.",
    "Melbourne has the world's largest tram network, covering over 250 kilometers and making it a vital part of the city's public transport system.",
    "The Royal Botanic Gardens, established in 1846, now span 90 acres and are internationally recognized for their variety of indigenous and exotic plants.",
    "Melbourne is home to the first McCafe, which opened in 1993, revolutionizing fast-food coffee culture.",
    "Known for unpredictable weather, Melbourne locals joke about experiencing 'four seasons in one day,' due to its rapidly changing climate.",
    "The Great Ocean Road, beginning near Melbourne, is the world's largest war memorial, built by soldiers returning from World War I.",
    "Melbourne is known for its street art, with laneways like Hosier Lane acting as outdoor galleries of colorful murals.",
    "Flinders Street Station, an iconic Melbourne landmark, was originally designed for Mumbai, India, but plans were mistakenly switched.",
    "The city hosted the 1956 Summer Olympics, becoming the first city outside Europe and North America to do so."
  ))

  # Render the random fact
  output$random_fact <- renderUI({
    fact <- sample(facts(), 1)
    p(fact)
  })
  
  # Update the random fact
  observeEvent(input$new_fact, {
    output$random_fact <- renderUI({
      fact <- sample(facts(), 1)
      p(fact)
    })
  })
}

shinyApp(ui, server)
