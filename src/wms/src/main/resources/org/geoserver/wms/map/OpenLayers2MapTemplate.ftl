<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>OpenLayers map preview</title>
        <!-- Import OL CSS, auto import does not work with our minified OL.js build -->
        <link rel="stylesheet" type="text/css" href="${relBaseUrl}/openlayers/theme/default/style.css"/>
        <!-- Basic CSS definitions -->
        <style type="text/css">
            /* General settings */
            body {
                font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
                font-size: small;
            }
            iframe {
                width: 100%;
                height: 250px;
                border: none;
            }
            /* Toolbar styles */
            #toolbar {
                position: relative;
                padding-bottom: 0.5em;
                display: none;
            }
            
            #toolbar ul {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            
            #toolbar ul li {
                float: left;
                padding-right: 1em;
                padding-bottom: 0.5em;
            }
            
            #toolbar ul li a {
                font-weight: bold;
                font-size: smaller;
                vertical-align: middle;
                color: black;
                text-decoration: none;
            }

            #toolbar ul li a:hover {
                text-decoration: underline;
            }
            
            #toolbar ul li * {
                vertical-align: middle;
            }

            /* The map and the location bar */
            #map {
                clear: both;
                position: relative;
                width: ${request.width?c}px;
                height: ${request.height?c}px;
                border: 1px solid black;
            }
            
            #wrapper {
                width: ${request.width?c}px;
            }
            
            #location {
                float: right;
            }
            
            #options {
                position: absolute;
                left: 13px;
                top: 7px;
                z-index: 3000;
            }

            /* Styles used by the default GetFeatureInfo output, added to make IE happy */
            table.featureInfo, table.featureInfo td, table.featureInfo th {
                border: 1px solid #ddd;
                border-collapse: collapse;
                margin: 0;
                padding: 0;
                font-size: 90%;
                padding: .2em .1em;
            }
            
            table.featureInfo th {
                padding: .2em .2em;
                font-weight: bold;
                background: #eee;
            }
            
            table.featureInfo td {
                background: #fff;
            }
            
            table.featureInfo tr.odd td {
                background: #eee;
            }
            
            table.featureInfo caption {
                text-align: left;
                font-size: 100%;
                font-weight: bold;
                padding: .2em .2em;
            }
        </style>
        <!-- Import OpenLayers, reduced, wms read only version -->
        <script src="${relBaseUrl}/openlayers/OpenLayers.js" type="text/javascript">
        </script>
        <script src="${relBaseUrl}/webresources/wms/OpenLayers2Map.js" type="text/javascript"></script>
    </head>
    <body>
        <div id="toolbar" class="d-none">
            <ul>
                <li>
                    <a>WMS version:</a>
                    <select id="wmsVersionSelector">
                        <option value="1.1.1">1.1.1</option>
                        <option value="1.3.0">1.3.0</option>
                    </select>
                </li>
                <li>
                    <a>Tiling:</a>
                    <select id="tilingModeSelector">
                        <option value="untiled">Single tile</option>
                        <option value="tiled">Tiled</option>
                    </select>
                </li>
                <li>
                    <a>Transition effect:</a>
                    <select id="transitionEffectSelector">
                        <option value="">None</option>
                        <option value="resize">Resize</option>
                    </select>
                </li>
                <li>
                    <a>Antialias:</a>
                    <select id="antialiasSelector">
                        <option value="full">Full</option>
                        <option value="text">Text only</option>
                        <option value="none">Disabled</option>
                    </select>
                </li>
                <li>
                    <a>Format:</a>
                    <select id="imageFormatSelector">
                        <option value="image/png">PNG 24bit</option>
                        <option value="image/png8">PNG 8bit</option>
                        <option value="image/gif">GIF</option>
                        <option id="jpeg" value="image/jpeg">JPEG</option>
                        <option id="jpeg-png" value="image/vnd.jpeg-png">JPEG-PNG</option>
                        <option id="jpeg-png8" value="image/vnd.jpeg-png8">JPEG-PNG8</option>
                    </select>
                </li>
                <li>
                    <a>Styles:</a>
                    <select id="styleSelector">
                        <option value="">Default</option>
                        <#list styles as style>          
                          <option value="${style}">${style}</option>  
                        </#list>     
                    </select>
                </li>
                <!-- Commented out for the moment, some code needs to be extended in 
                     order to list the available palettes
                <li>
                    <a>Palette:</a>
                    <select id="paletteSelector">
                        <option value="">None</option>
                        <option value="safe">Web safe</option>
                    </select>
                </li>
                -->
                <li>
                    <a>Width/Height:</a>
                    <select id="widthSelector">
                        <!--
                        These values come from a statistics of the viewable area given a certain screen area
                        (but have been adapted a litte, simplified numbers, added some resolutions for wide screen)
                        You can find them here: http://www.evolt.org/article/Real_World_Browser_Size_Stats_Part_II/20/2297/
                        --><option value="auto">Auto</option>
                        <option value="600">600</option>
                        <option value="750">750</option>
                        <option value="950">950</option>
                        <option value="1000">1000</option>
                        <option value="1200">1200</option>
                        <option value="1400">1400</option>
                        <option value="1600">1600</option>
                        <option value="1900">1900</option>
                    </select>
                    <select id="heightSelector">
                        <option value="auto">Auto</option>
                        <option value="300">300</option>
                        <option value="400">400</option>
                        <option value="500">500</option>
                        <option value="600">600</option>
                        <option value="700">700</option>
                        <option value="800">800</option>
                        <option value="900">900</option>
                        <option value="1000">1000</option>
                    </select>
                </li>
                <li>
                    <a>Filter:</a>
                    <select id="filterType">
                        <option value="cql">CQL</option>
                        <option value="ogc">OGC</option>
                        <option value="fid">FeatureID</option>
                    </select>
                    <input type="text" size="80" id="filter"/>
                    <img id="updateFilterButton" src="${relBaseUrl}/openlayers/img/east-mini.png" title="Apply filter"/>
                    <img id="resetFilterButton" src="${relBaseUrl}/openlayers/img/cancel.png" title="Reset filter"/>
                </li>
            </ul>
        </div>
        <div id="map">
            <img id="options" title="Toggle options toolbar" src="${relBaseUrl}/options.png"/>
        </div>
        <div id="wrapper">
            <div id="location">location</div>
            <div id="scale">
            </div>
        </div>
        <div id="nodelist">
            <em>Click on the map to get feature info</em>
        </div>
        <input type="hidden" id="pureCoverage" value="${pureCoverage}"/>
        <input type="hidden" id="supportsFiltering" value="${supportsFiltering}"/>
        <input type="hidden" id="minX" value="${request.bbox.minX?c}"/>
        <input type="hidden" id="minY" value="${request.bbox.minY?c}"/>
        <input type="hidden" id="maxX" value="${request.bbox.maxX?c}"/>
        <input type="hidden" id="maxY" value="${request.bbox.maxY?c}"/>
        <input type="hidden" id="SRS" value="${request.SRS}"/>
        <input type="hidden" id="yx" value="${yx}"/>
        <input type="hidden" id="maxResolution" value="${maxResolution}"/>
        <input type="hidden" id="baseUrl" value="${baseUrl}"/>
        <input type="hidden" id="servicePath" value="${servicePath}"/>
        <input type="hidden" id="units" value="${units}"/>
        <input type="hidden" id="layerName" value="${layerName}"/>
        <#list parameters as param>
        <input type="hidden" class="param" title="${param.name}" value="${param.value}"/>
        </#list>
    </body>
</html>
