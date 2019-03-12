R GIS
================

-   [Vector data](#vector-data)
    -   [Classes](#classes)
    -   [Input/Output](#inputoutput)
    -   [Data and metadata access](#data-and-metadata-access)
    -   [Spatial analysis](#spatial-analysis)
-   [Raster data](#raster-data)
    -   [Classes](#classes-1)
    -   [Input/output](#inputoutput-1)
    -   [Manipulation](#manipulation)
-   [Coordinate reference systems](#coordinate-reference-systems)
    -   [Set or get projection](#set-or-get-projection)
    -   [Transformations](#transformations)
    -   [Specifying projections](#specifying-projections)

<style type="text/css">
.table {

    width: 100%;

}
</style>
Vector data
===========

``` r
> library(sp) # provides classes
> library(maptools) # provides i/o, coercion
```

    Checking rgeos availability: TRUE

### Classes

-   `SpatialPoints`, `SpatialPointsDataFrame`
-   `SpatialLines`, `SpatialLinesDataFrame`
-   `SpatialPolygons`, `SpatialPolygonsDataFrame`
-   `SpatialRing`, `SpatialRingDataFrame`
-   `SpatialMultiPoints`, `SpatialMultiPointsDataFrame`
-   `SpatialGrid`, `SpatialGridDataFrame`
-   `SpatialPixels`, `SpatialPixelsDataFrame`

### Input/Output

``` r
> # READING shapefiles
> readShapePoints(fn)
> readShapeLines(fn)
> readShapePoly(fn)
> readShapeSpatial(fn)
> 
> # WRITTING shapefiles
> writePointsShape(x, fn)
> writeLinesShape(x, fn)
> writePolygonsShape(x, fn)
> writeSpatialShape(x, fn)
> 
> # more general - incl. geodatabases etc.
> library(rgdal)
> ogrDrivers()  # list supported drivers
> ogrListLayers(dsn)  # list layers from Data Source Name (dsn)
> ogrInfo(dsn, layer)  # layer info
> ogrFIDs()  # list field IDs (FIDs)
> OGRSpatialRef()  # projection (proj4string)
> readOGR(dsn, layer)  # reading (reads also projection)
> writeOGR(dsn, layer)  # writting (writes also projection)
```

### Data and metadata access

*Creating toy data - `SpatialPointsDataFrame`*

``` r
> d = data.frame(ID = sample(LETTERS, 10), x = rnorm(10), y = rnorm(10), ELE = 300 + rnorm(10, 20, 6)^2)
> row.names(d) = d$ID
> p = SpatialPointsDataFrame(d[, 2:3], d)
```

###### Number of objects

``` r
> length(p)
```

    [1] 10

###### Getting names of variables from attribute table (for `Spatial*DataFrame` only)

``` r
> names(p)
```

    [1] "ID"  "x"   "y"   "ELE"

###### Accessing attribute table

``` r
> p@data
```

      ID          x          y      ELE
    V  V -0.3554076  1.3808582 368.7343
    X  X  0.3692138 -0.1787797 581.2927
    K  K -1.7176594  0.5422562 599.9657
    O  O -0.8310263 -1.4832738 483.7743
    L  L -0.3290916 -1.9310792 665.6286
    D  D -0.1802002 -0.5408274 685.8548
    T  T  0.4233974 -0.9478419 710.4715
    A  A -0.5372500 -0.9145432 436.3466
    B  B  1.2272444  0.5124241 957.0161
    N  N  0.1798468  1.8188425 442.0102

###### Accessing individual variables

``` r
> # by name
> p$ID 
> p@data$ID 
> p@data[, 'ID']
> 
> # by position
> p@data[, 3]
```

###### Selecting individual objects

``` r
> p[3:4, ] # by position
> p['B', ] # by name
> p[p$ELE < 500, ] # by condition
```

### Spatial analysis

``` r
> library(rgeos) # provides many functions
```

<table>
<colgroup>
<col width="28%" />
<col width="71%" />
</colgroup>
<thead>
<tr class="header">
<th>command</th>
<th>meaning</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>gBuffer(spgeom, byid, width)</code></td>
<td>creates buffer of specified width, possibly separately for each geometry (when <code>by = TRUE</code>)</td>
</tr>
<tr class="even">
<td><code>gCentroid</code></td>
<td>get centroid</td>
</tr>
<tr class="odd">
<td><code>gContains</code>, <code>gCovers</code></td>
<td>geometry relationships</td>
</tr>
<tr class="even">
<td><code>gDelaunayTriangulation</code></td>
<td>triangulation</td>
</tr>
<tr class="odd">
<td><code>gDifference</code></td>
<td>geometry difference</td>
</tr>
<tr class="even">
<td><code>gDistance</code></td>
<td>distance in map units</td>
</tr>
<tr class="odd">
<td><code>gIntersection</code></td>
<td>find intersection of two spgeoms</td>
</tr>
<tr class="even">
<td><code>gIntersects(spgeom1, spgeom2)</code></td>
<td>does spgeom1 intersect spegeom2</td>
</tr>
<tr class="odd">
<td><code>gLength</code></td>
<td>geometry length</td>
</tr>
<tr class="even">
<td><code>gSimplify</code></td>
<td>simplify geometry</td>
</tr>
<tr class="odd">
<td><code>gUnion</code>, <code>gUnionCascaded</code></td>
<td>union geometries</td>
</tr>
<tr class="even">
<td><code>gWithinDistance</code></td>
<td>returns <code>TRUE</code> if the distance of two geometries is less then specified distance</td>
</tr>
</tbody>
</table>

Raster data
===========

``` r
> library(raster)
```

### Classes

<table>
<colgroup>
<col width="12%" />
<col width="87%" />
</colgroup>
<thead>
<tr class="header">
<th>class</th>
<th></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>raster</code></td>
<td>raster layer</td>
</tr>
<tr class="even">
<td><code>brick</code></td>
<td>in-memory multi/layer raster object</td>
</tr>
<tr class="odd">
<td><code>stack</code></td>
<td>collection of raster layers with the same spatial extent and resolution</td>
</tr>
</tbody>
</table>

### Input/output

``` r
> # reading rasters
> raster(file)
> brick(list(file1, file2, ...))
> stack(list(file1, file2, ...))
> 
> # writting rasters
> writeRaster(r, 'file')
```

### Manipulation

###### Working with layers

``` r
> # create brick from 2 layers
> b = brick(layer1, layer2)
> # select first layer
> b[[1]]
```

###### Getting and setting values

``` r
> getValues(x) # extract values
> values(x) # the same
> 
> setValues(x, values) # set values
> values(x) = values # the same
```

###### Raster calculations

``` r
> x + y # sum the values of raster x and raster y
> x / y # etc. ...
> mean(x) # mean of x across layers
> 
> calc(x, fun) # apply fun to values of raster x
> cellStats(x, fun) # compute statistics for the cells of each layer of a Raster* object
```

###### Modification of raster objects

``` r
> resample(x, y) # transfer values from raster x to raster y (with same projection but different resolution)
> projectRaster(x, y) # project raster x to projection and resolution of raster y
> aggregate(x, fact) # aggregate values to lower resolution
> disaggregate(x, fact) # create raster with higher resolution
> 
> crop(x, s) # crop raster x by spatial object s
> mask(x, s) # mask values of raster x by spatial object s
> extract(x, s, fun) # extract values from raster r according to spatial object s, optionally using aggregate function fun
```

Coordinate reference systems
============================

-   specified as "proj4string"

###### Set or get projection

``` r
> # getting projection
> projection(x)
> crs(temp)
> x@crs # for raster class
> x@proj4string # for sp* classes
> 
> # setting proj4string (this is different from projecting raster)
> projection(x) = crsString
> crs(x) = crsString
```

###### Transformations

``` r
> # vectors
> spTransform(x, CRS) # transform x (with specified CRS) to new CRS
> 
> # raster
> projectRaster(r, crs = CRS) # project raster r to new CRS
```

###### Specifying projections

``` r
> # WGS
> CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')
```

    CRS arguments:
     +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0 

``` r
> # krovak S-JTSK
> CRS('+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +alpha=0 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +units=m +no_defs')
```

    CRS arguments:
     +proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +k=0.9999 +x_0=0
    +y_0=0 +ellps=bessel +units=m +no_defs 

``` r
> # specification by epsg
> CRS('+init=epsg:4326') # WGS
```

    CRS arguments:
     +init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84
    +towgs84=0,0,0 

``` r
> CRS('+init=epsg:2065') # krovak
```

    CRS arguments:
     +init=epsg:2065 +proj=krovak +lat_0=49.5 +lon_0=42.5 +k=0.9999
    +x_0=0 +y_0=0 +ellps=bessel
    +towgs84=570.8,85.7,462.8,4.998,1.587,5.261,3.56 +pm=ferro
    +units=m +no_defs 

------------------------------------------------------------------------
