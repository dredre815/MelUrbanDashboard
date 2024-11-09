# Melbourne Urban Mobility Insights Dashboard

## Overview
An interactive R Shiny dashboard that provides comprehensive insights into Melbourne's urban mobility patterns, including pedestrian dynamics, public transport utilization, and road safety analytics. The dashboard combines multiple data visualizations from Tableau Public with an intuitive user interface to help users understand and analyze urban mobility trends.

## Features

### 1. General View
- Overview of key urban mobility statistics
- Real-time updates on pedestrian counts, tram frequency, and accident reports
- Interactive cards showing city statistics and latest updates
- "Did You Know?" section with interesting Melbourne facts
- Quick navigation to detailed analysis sections

### 2. Pedestrian Dynamics
- Weekly pedestrian traffic trend analysis
- Interactive heat map showing pedestrian activity
- Detailed insights into peak hours and busy locations
- Comparative analysis of weekday vs. weekend patterns

### 3. Public Transport
- Analysis of tram departure frequency
- Correlation between foot traffic and public transport availability
- Interactive visualizations of transport patterns
- Key insights into route utilization and peak hours

### 4. Road Safety
- Car crash frequency heat map
- Accident location mapping
- Temporal and spatial analysis of traffic incidents
- Weather impact on accident rates

## Technical Stack
- **R Shiny**: Main framework for the dashboard
- **R Libraries**:
  - shiny
  - shinydashboard
  - shinyWidgets
  - shinyjs
- **Tableau Public**: External visualizations
- **Custom CSS**: Extensive styling for enhanced user experience

## Installation

1. Clone the repository
2. Install required R packages:
```r
install.packages(c("shiny", "shinydashboard", "shinyWidgets", "shinyjs"))
```

## Run the application:
```r
shiny::runApp()
```

## Dashboard Structure

### UI Components
- Responsive sidebar navigation
- Custom-styled value boxes
- Interactive information cards
- Modal dialogs for detailed information
- Responsive grid layouts

### Visualization Integration
- Embedded Tableau Public visualizations
- Custom-styled visualization containers
- Interactive tooltips and information buttons
- Responsive iframe implementations

### Styling Features
- Custom color schemes
- Responsive design
- Hover effects and animations
- Consistent typography and spacing
- Mobile-friendly layouts

## Data Sources
The dashboard integrates various data visualizations from Tableau Public, including:
- Pedestrian sensor data
- Public transport schedules
- Traffic accident records
- Urban infrastructure information

## Usage
1. Navigate through different sections using the sidebar menu
2. Interact with visualizations to explore specific data points
3. Use information buttons (ℹ️) to learn more about each visualization
4. Access quick insights through the statistics cards
5. Explore random facts about Melbourne using the "Did You Know?" section

## Customization
The dashboard includes extensive CSS customization options for:
- Color schemes
- Layout configurations
- Component styling
- Animation effects
- Responsive breakpoints

## Contributing
Contributions to improve the dashboard are welcome. Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details.