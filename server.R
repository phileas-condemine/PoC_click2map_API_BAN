

function(input, output, session) {
  
  ## Interactive Map ###########################################
  emplacements=data.frame()
  makeReactiveBinding("emplacements")
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(  ) %>%
      setView(lng = 3, lat = 48, zoom = 7)
  })
  p=data.frame(lng=1.8,lat=48.4)
  observeEvent(input$map_click, { # update the map markers and view on map clicks
    p <- input$map_click
    
    revgeocode=jsonlite::fromJSON(sprintf("https://nominatim.openstreetmap.org/reverse.php?format=json&lat=%s&lon=%s",p$lat,p$lng))
    new_marker=data.frame(lieu=paste(unlist(revgeocode$address),sep="\n",collapse="\n"),
                          lng = p$lng,
                          lat = p$lat,
                          id=as.character(sample(10000,1)))
    print("ajout d'un établissement candidat")
    print(emplacements)
    leafletProxy("map",session)%>%
      addMarkers(data = new_marker,
                 lng= ~lng,
                 lat= ~lat,
                 layerId = ~id,
                 label= ~paste(lieu,id,"\n")
                 )
    emplacements=rbind(emplacements,new_marker)
    emplacements$lng=round(emplacements$lng,1)
    emplacements$lat=round(emplacements$lat,1)
    emplacements <<- emplacements
    output$spots=renderDataTable({datatable(data.frame(lieu=emplacements$lieu), options = list(dom = 't'))})
  })
  observeEvent(input$map_marker_click, {
    id_marker=input$map_marker_click$id
    print(paste("suppression de l'établissement candidat",id_marker))
    emplacements <<- emplacements[!emplacements$id==id_marker,]
    print(emplacements)
    output$spots=renderDataTable({datatable(data.frame(lieu=emplacements$lieu), options = list(dom = 't'))})
    leafletProxy("map", session) %>%
      removeMarker(layerId = id_marker)
    })
  
  # observeEvent(input$Map_marker_click, { # update the location selectInput on map clicks
  #   p <- input$Map_marker_click
  #   if(!is.null(p$id)){
  #     if(is.null(input$location) || input$location!=p$id) updateSelectInput(session, "location", selected=p$id)
  #   }
  # })
}