
#' Pacey Performance Podcast Shiny App
#' @import shiny
#' @import shinydashboard
#' @import bs4Dash
#' @import waiter
#' @import fresh
#' @import ggimage
#' @import magick
#' @import ggplot2
#' @import shinycssloaders
#' @import DT
#' @return Shiny Application
#' @export
#'
#' @examples
#' paceypodcastR_app


paceypodcastR_app <- function(){

  # use_package("shiny")
  # use_package("shinydashboard")
  # use_package("bs4Dash")
  # use_package("waiter")
  # use_package("fresh")
  # use_package("ggimage")
  # use_package("ggplot2")
  # use_package("shinycssloaders")
  # use_package("DT")
  # use_import_from("base64enc", "dataURI")
  # use_import_from("shinydashboardPlus", "socialButton")

  #create custom theme using Pacey Performance Colors
  theme <- fresh::create_theme(
    fresh::bs4dash_status(
      primary = "#ed5339"
    ),
    fresh::bs4dash_layout(
      main_bg = "grey"
    ),
    fresh::bs4dash_vars(
      navbar_light_color = "#bec5cb",
      navbar_light_active_color = "#FFF",
      navbar_light_hover_color = "#FFF",
      navbar_dark_color = "#bec5cb"
    )
  )

  #load images
  wordcloud_image <- base64enc::dataURI(file=system.file("figures", "wordcloud_image.png", package = "paceypodcastRdemo"), mime="image/png")
  hexsticker_image <- base64enc::dataURI(file=system.file("figures", "hexsticker.png", package = "paceypodcastRdemo"), mime="image/png")

  ui = bs4Dash::dashboardPage(
    dark = TRUE,
    freshTheme = theme,
    controlbar = bs4Dash::dashboardControlbar(bs4Dash::skinSelector(), pinned = FALSE, width = 300),
    header = bs4Dash::dashboardHeader(
      titleWidth = 150,
      title = bs4Dash::dashboardBrand(
        title = "paceypodcastR",
        color = "primary",
        href = "https://www.sportsmith.co/",
        image = "https://i.scdn.co/image/ab67656300005f1f99e33407b788649983481028",
      ),
      rightUi =  bs4Dash::userOutput("user")
    ),
    sidebar = bs4Dash::dashboardSidebar(width = 150,
                                        bs4Dash::sidebarMenu(
                                          bs4Dash::menuItem(
                                            "Social",
                                            tabName = "twittertimeline",
                                            icon = shiny::icon("twitter")
                                          ),
                                          bs4Dash::menuItem(
                                            "Analysis",
                                            tabName = "analysis",
                                            icon = shiny::icon("chart-simple")
                                          ),
                                          bs4Dash::menuItem(
                                            "Timeline",
                                            tabName = "timeline",
                                            icon = shiny::icon("timeline")
                                          ),
                                          bs4Dash::menuItem(
                                            "Episodes",
                                            tabName = "episodes",
                                            icon = shiny::icon("table")
                                          )
                                        )),
    body = bs4Dash::dashboardBody(
      shiny::tags$style("@import url(https://use.fontawesome.com/releases/v6.1.2/css/all.css);"),
      skin = "dark",
      bs4Dash::tabItems(
        # Twitter
        bs4Dash::tabItem(tabName = "twittertimeline",
                         shiny::fluidRow(
                           shiny::column(width = 6, align = 'center',
                                         shiny::div(shiny::tags$img(src=hexsticker_image, height = 300, width = 250, align = "center"), style = "align: center;"),
                                         bs4Dash::box(
                                           title = "Spotify - Latest Episode",
                                           width = NULL,
                                           height = NULL,
                                           shiny::tags$iframe(
                                             style="border-radius:12px",
                                             src="https://open.spotify.com/embed/show/4J7lhwdc8jCT92CyKluXQr?utm_source=generator",
                                             width="100%",
                                             height="380",
                                             frameBorder="0",
                                             allowfullscreen="",
                                             scrolling = "yes",
                                             allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture;",
                                             loading="lazy")
                                         )

                           ),
                           # Spotify
                           shiny::column(width = 6,
                                         shiny::tags$head(
                                           shiny::tags$script(
                                             '!function(d,s,id){var js,fjs=d.getElementsByTagName(s)    [0],p=/^http:/.test(d.location)?\'http\':\'https\';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+"://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");'
                                           )
                                         ),
                                         bs4Dash::box(
                                           title = "Twitter",
                                           width = NULL,
                                           height = NULL,
                                           shiny::a("Tweets by @SportsmithHQ", class =
                                                      "twitter-timeline"
                                                    , href = "https://twitter.com/SportsmithHQ")
                                         ))

                         )),
        bs4Dash::tabItem(tabName = "analysis",
                         shiny::fluidRow(
                           shiny::column(width = 5,
                                         bs4Dash::box(width = NULL, height =450, title = "Episode Title - Most Used Words", collapsible = TRUE, align = 'center',
                                                      shiny::tags$img(src=wordcloud_image, height = 400, width = 500, align = "center")
                                         )
                           ),
                           shiny::column(width = 7,
                                         bs4Dash::box(width = NULL, height =450, title = "Episode Duration Trends", collapsible = TRUE,
                                                      shinycssloaders::withSpinner(shiny::plotOutput("duration_show_type_ouput"), color = "white")
                                         )),
                           shiny::column(width = 6,
                                         bs4Dash::box(width = NULL, height =450, title = "Monthly Episode Duration", collapsible = TRUE,
                                                      shinycssloaders::withSpinner(shiny::plotOutput("duration_month_ouput"), color = "white")
                                         )),
                           shiny::column(width = 6,
                                         bs4Dash::box(width = NULL, height =450, title = "Yearly Episode Duration", collapsible = TRUE,
                                                      shinycssloaders::withSpinner(shiny::plotOutput("duration_year_ouput"), color = "white")
                                         ))
                         )),
        bs4Dash::tabItem(tabName = "timeline",
                         shiny::fluidRow(
                           shiny::column(2),
                           shiny::column(width = 8, align = "center",
                                         bs4Dash::box(width = NULL, height=NULL, title = "Timeline", collapsible = TRUE,
                                                      shinycssloaders::withSpinner(shiny::plotOutput("timeline_chart_output", height = 750, width = 900), color = "white")
                                         )),
                           shiny::column(2)
                         )),
        bs4Dash::tabItem(tabName = "episodes",
                         shiny::fluidRow(
                           shiny::tags$head(shiny::tags$style(shiny::HTML(
                             "
                  .dataTables_length label,
                  .dataTables_filter label,
                  table.dataTable tr:nth-child(even) {background-color: #ed5339 !important; color: white;}
                  table.dataTable tr:nth-child(odd) {background-color: darkgrey !important; color: white;}
                  table.dataTable a {color: black;}
                  th { text-align: center; }
                  .dataTables_info {
                      color: white!important;
                      }

                  .paginate_button {
                      background: white!important;
                  }

                  thead {
                      color: white; text-align: center;
                      }

                  "))),
                           shiny::column(width = 12, align = "center",
                                         bs4Dash::box(width = NULL, height=NULL, title = "Episodes", collapsible = TRUE,
                                                      shinycssloaders::withSpinner(DT::DTOutput("episodes_table_output"), color = "white")
                                         ))
                         ))

      ))
  )


  server = function(input, output, session) {

    #source("podcast_data.R")


    output$duration_show_type_ouput <- shiny::renderPlot({

      #source("duration_show_type_chart.R")
      return(duration_show_type_chart())

    })

    output$duration_month_ouput <- shiny::renderPlot({

      #source("duration_month_chart.R")
      return(duration_month_chart())

    })

    output$duration_year_ouput <- shiny::renderPlot({

      #source("duration_year_chart.R")
      return(duration_year_chart())

    })


    output$timeline_chart_output <- shiny::renderPlot({

      #source("timeline_chart.R")
      return(timeline_chart())

    })

    output$episodes_table_output <- DT::renderDT({

      #source("episodes_table.R")
      return(episodes_table())

    })




    ####### user profile

    output$user <- shinydashboardPlus::renderUser({
      bs4Dash::dashboardUser(
        name = "Ryan Curtis",
        image = "https://ryan-curtis.netlify.app/author/dr.-ryan-curtis/avatar_hud36951747e40dfa69b4606221f685db5_538473_270x270_fill_q90_lanczos_center.jpg",
        title = "NFL Combine App",
        subtitle = "Author",
        footer = p("@RyanM_Curtis", class = "text-center"),
        shiny::fluidRow(
          shiny::div(style = "text-align: center;",

                     bs4Dash::dashboardUserItem(
                       width = 12,
                       shiny::div(style = "text-align: center;",
                                  shinydashboardPlus::socialButton(
                                    href = "https://twitter.com/RyanM_Curtis",
                                    icon = icon("twitter", "fa-2x")
                                  ),
                                  shinydashboardPlus::socialButton(
                                    href = "https://github.com/rmcurtis43",
                                    icon = icon("github", "fa-2x")
                                  )
                       ))
          )
        )
      )
    })

  }



  shiny::shinyApp(ui, server)



}

