bootstrapPage(
  tags$head(
  # Include our custom CSS
  includeCSS("styles.css")
  ),
  div(class="outer",
                  leafletOutput("map", width = "100%", height = "100%"),
                  absolutePanel(
                    id = "desc", class = "panel panel-default", fixed = TRUE,
                    draggable = TRUE, top = 0, left = 100, right = "auto", bottom = "auto",
                    width = 330, height = "auto",
                    HTML('<button data-toggle="collapse" data-target="#demo">Aide</button>'),
                    tags$div(id = 'demo',  class="collapse",
                             HTML("<h1> Mode d'emploi</h1>
                                  <ul>
                                  <li> Pour fermer/ouvrir ce menu, cliquer sur 'Aide'.
                                  <li> Pour ajouter des points sur la carte, cliquez où vous le souhaitez.
                                  <li> Pour supprimer un point, cliquez dessus de nouveau.
                                  <li> Les points sont immédiatement géocodés avec nominatim, enregistrés et affichés dans le tableau à droite.
                                  </ul>"))),
                  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                draggable = TRUE, top = 0, left = "auto", right = 20, bottom = "auto",
                                width = 330, height = "auto",
                                HTML('<button data-toggle="collapse" data-target="#etablissements">Etablissements</button>'),
                                tags$div(id="etablissements",
                                         class="collapse",
                                h2("Position des établissements"),
                                dataTableOutput("spots")
                                )
                                )
                  ))