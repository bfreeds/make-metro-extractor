# Metro Extracts Downloader  

This tool uses the command line utility `Make` to *make* it simple to download OpenStreetMap data via [Mapzen's Metro Extracts](https://mapzen.com/data/metro-extracts/).

**Note:  Because [Mapzen is shutting down](https://mapzen.com/blog/shutdown/), this tool will only work until February 1st, 2018**

**Features:**
- Supports all Metro Extract data formats
- Configurable geographic area
See [here](https://mapzen.com/documentation/metro-extracts/file-format/) for a great explanation on the different formats available through Metro Extracts.  


# Usage  
1.  Clone this repository  
```shell
$ git clone
```
2.  Download the extract  
```shell
# pass city and state as arguments
$ make CITY=new-york STATE=new-york coastline
# or pass parameters by environment variables if you are running a multiple commands
$ export CITY=new-york
$ export STATE=new-york
$ make coastline
```

The following `make` commands are available:
- `make coastline`
- `make raw`
  - includes both : (*warning -- is large*)
   - `make osm.pbf`
   - `make osm.xml`
- `make osm2pgsql`
  - includes both : (*warning -- is large*)
    - `make osm2pgsql.geojson`
    - `make osm2pgsql.shp`
- `make imposm`
  - includes both : (*warning -- is large*)
    - `make imposm.geojson`
    - `make imposm.shp`
- `make coastline`
  - includes both :
    - `make osm.water.coastline`
    - `make osm.land.coastline`

You can run the combined make commands or the standalone (`$ make imposm.shp`).  The combined commands will download large files -- I would only use them if you have a specific reason to (experiment with different OSM file formatting).
