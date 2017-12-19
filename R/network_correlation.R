# Copyright 2017 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' A function to map individual station correlations
#'
#' This function makes use of the igraph and ggraph packages to create a network object from historical
#' hydrometric data. Still under construction.
#'
#' @param station_number Water Survey of Canada station number.
#' @param cor_threshold Threshold for correlation. Default is 0.6.
#' @param method From `stats::cor()` a character string indicating which correlation coefficient (or covariance)
#' is to be computed. One of "pearson" (default), "kendall", or "spearman": can be abbreviated.`
#'
#' @examples
#' \dontrun{
#' network_correlation("08NM146")
#' }

network_correlation <-
  function(station_number = NULL,
           cor_threshold = 0.6,
           method = c("pearson",
                      "kendall", "spearman")) {

    method <- match.arg(method)



    ## Get daily flows for watershed ssda
    daily_flows_boxed <- tidyhydat::hy_stations()
    daily_flows_boxed <- dplyr::filter(daily_flows_boxed,
                                       substr(STATION_NUMBER, 1, 4) %in% substr(station_number, 1, 4))
    daily_flows_boxed <-
      dplyr::filter(daily_flows_boxed, HYD_STATUS == "ACTIVE")
    daily_flows_boxed <-
      tidyhydat::hy_daily_flows(daily_flows_boxed$STATION_NUMBER)


    ## This is a bit inefficient because I am calculating ALL correlations
    ## then subsetting for the ones of interest.
    flow_cor <- daily_flows_boxed %>%
      tidyr::spread(STATION_NUMBER, Value) %>%
      dplyr::select(-Date,-Symbol,-Parameter)

    flow_cor <- corrr::correlate(flow_cor, method = method)
    flow_cor <- corrr::stretch(flow_cor)
    flow_cor <- dplyr::filter(flow_cor,!is.na(r))
    flow_cor <- dplyr::filter(flow_cor, abs(r) >= cor_threshold)

    flow_cor <- flow_cor %>%
      dplyr::left_join(tidyhydat::allstations, by = c("x" = "STATION_NUMBER")) %>%
      dplyr::left_join(tidyhydat::allstations, by = c("y" = "STATION_NUMBER")) %>%
      dplyr::select(STATION_NAME.x, STATION_NAME.y, r) %>%
      dplyr::rename(x = STATION_NAME.x, y = STATION_NAME.y)

    ## Convert to an igraph object for plotting
    graph_correlation <- igraph::graph_from_data_frame(flow_cor,
                                                       directed = TRUE)

    #graph_correlation <- igraph::graph_from_data_frame(flow_cor,
    #                                                   directed = FALSE)

    ## Station name
    stn_name <- tidyhydat::hy_stations(station_number)$STATION_NAME

    graph_sub <-
      igraph::subgraph.edges(graph_correlation, igraph::E(graph_correlation)[inc(stn_name)])


    ## Get lat long for relevant stations
    latlong_layout_ggmap <-
      tidyhydat::hy_stations(prov_terr_state_loc = "BC") %>%
      dplyr::filter(STATION_NAME %in% igraph::V(graph_sub)$name) %>%
      dplyr::select(LONGITUDE, LATITUDE, STATION_NAME) %>%
      dplyr::rename(x = LONGITUDE, y = LATITUDE)

    ## Create the spatial layout based on latitude and longitude.
    spatial_layout_ggmap <- ggraph::create_layout(graph = graph_sub,
                                                  layout = "manual",
                                                  node.positions = latlong_layout_ggmap)


    ## Actual plot
    #map <-
    #  ggmap::get_map(
    #    location = c(
    #      lon = mean(latlong_layout_ggmap$x),
    #      lat = mean(latlong_layout_ggmap$y)
    #    ),
    #    source = "google",
    #    maptype = 'satellite',
    #    zoom = zoom
    #  )

    ## Requisite watershed
    drainages <- bcmaps::wsc_drainages() %>%
      dplyr::filter(SUB_SUB_DRAINAGE_AREA_CD == substr(station_number, 1, 4)) %>%
      #st_intersection(bcmaps::bc_bound_hres()) %>%
      sf::st_transform(crs = 4326)

    drainages_sp <- as(drainages, "Spatial")
    drainages_for <- ggplot2::fortify(drainages_sp)


    ## Actual plot
    ## TODO: Add colour scale to edges
    cor_graph <- ggraph::ggraph(spatial_layout_ggmap) +
      ggraph::geom_edge_link(aes(edge_alpha = abs(r)), edge_width = 1.5) +
      ggplot2::geom_polygon(aes(long,lat), data = drainages_for, fill = NA, colour = "red") +
      #scale_edge_colour_gradientn(limits = c(-1, 1), colors = 4) +
      guides(colour = guide_edge_colourbar()) +
      ggraph::geom_node_point(color = "black", size = 5) +
      ggraph::geom_node_text(aes(label = name), repel = TRUE, colour = "black") +
      ggplot2::labs(title = paste0("Uniqueness of ", stn_name, " in ",
                                   unique(drainages$SUB_SUB_DRAINAGE_AREA_NAME), " basin"),
                    subtitle = paste0("Evaluated with correlation coefficient of ", cor_threshold),
                    x = "Longitude",
                    y = "Latitude") +
      ggplot2::coord_equal() +
      ggplot2::theme_minimal()
      #ggraph::theme_graph(background = 'grey20', text_colour = 'white')

    #cor_map <-
    #  ggmap::ggmap(map, base_layer = cor_graph) +
    #  #geom_polygon(data = sp_fort, aes(long, lat), fill = "white", colour = "black") +
    #  ggraph::geom_edge_link(aes(edge_alpha = abs(r), color = r), edge_width = 1.5) +
    #  #ggplot2::guides(edge_alpha = "none") +
    #  #ggraph::scale_edge_colour_viridis(limits = c(-1, 1)) +
    #  ggraph::geom_node_point(color = "white", size = 5) +
    #  ggraph::geom_node_text(aes(label = name), repel = TRUE, colour = "white") +
    #  ggplot2::theme_minimal()

    print(cor_graph)
  }
