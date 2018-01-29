#	Downloads an OSM extract from Mapzen based on the location provided
#	Choose your data format by running the appropriate make command
# For help choosing a format see https://mapzen.com/documentation/metro-extracts/file-format/
#	The following data formats are available:
  # "raw" includes:
		#osm.pbf
		#osm.xml
	# "osm2pgsql" includes:
	  #	osm2pgsql.geojson
		#	osm2pgsql.shp
	# "imposm" includes:
		#	imposm.geojson
		#	imposm.shp
	# "coastline" includes:
		#	osm.water.coastline
		#	osm.land.coastline

# Requires arguments CITY and STATE to be passed
# Pass as command argument (ex. make CITY="new-york" STATE="new-york" coastline)
# Or as environment variable $ export CITY=new-york
# Note: spaces should be separated with a dash (ex. "new-york")
PLACE = $(CITY)_$(STATE)

#	Throw an error if CITY or STATE are not set
ifndef CITY
$(error CITY is not set)
endif
ifndef STATE
$(error STATE is not set)
endif

#	RAW OSM
raw: osm.pbf osm.xml

# protobuf format
osm.pbf:
	mkdir -p raw
	wget -O raw/$(PLACE).osm.pbf https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).osm.pbf

# xml format
osm.xml: osm.bz2
	bzip2 -d raw raw/$< #  "$<" is the variable for the first requirement ('osm.bz2')
	rm raw/$<

osm.bz2:
	wget -O raw/$(PLACE).osm.bz2 https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).osm.bz2


#	BY GEOMETRY
osm2pgsql: osm2pgsql.geojson osm2pgsql.shp

#	osm2pgsql geojson
osm2pgsql.geojson: $(PLACE).osm2pgsql.geojson.zip
	unzip -d osm2pgsql osm2pgsql/$<
	rm osm2pgsql/$<

$(PLACE).osm2pgsql.geojson.zip:
	mkdir -p osm2pgsql
	wget -O osm2pgsql/$(PLACE).osm2pgsql-geojson.zip https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).osm2pgsql-geojson.zip

#	osm2pgsql shapefiles
osm2pgsql.shp: $(PLACE).osm2pgsql.shp.zip
	unzip -d osm2pgsql osm2pgsql/$<
	rm osm2pgsql/$<

$(PLACE).osm2pgsql.shp.zip:
	mkdir -p osm2pgsql
	wget -O osm2pgsql/$(PLACE).osm2pgsql.shp.zip https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).osm2pgsql-shapefiles.zip


# BY OSM TAG
imposm: imposm.geojson imposm.shp

#	imposm geojson
imposm.geojson: $(PLACE).imposm.geojson.zip
	unzip -d imposm imposm/$<
	rm imposm/$<

$(PLACE).imposm.geojson.zip:
	wget -O imposm/$(PLACE).imposm.geojson.zip https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).imposm-geojson.zip

#	imposm shapefiles
imposm.shp: $(PLACE).imposm.shp.zip
	unzip -d imposm imposm/$<
	rm imposm/$<

$(PLACE).imposm.shp.zip:
	mkdir -p imposm
	wget -O imposm/$(PLACE).imposm.shp.zip https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).imposm-shapefiles.zip


#	COASTLINE
coastline: osm.water.coastline osm.land.coastline

# water coastlines
osm.water.coastline: $(PLACE).osm.water.coastline.shp.zip
	unzip -d coastline coastline/$<
	rm coastline/$<

$(PLACE).osm.water.coastline.shp.zip:
	mkdir -p coastline
	wget -O coastline/$(PLACE).osm.water.coastline.shp.zip https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).water.coastline.zip

# land coastlines
osm.land.coastline: $(PLACE).osm.land.coastline.shp.zip
	unzip -d coastline coastline/$<
	rm coastline/$<

$(PLACE).osm.land.coastline.shp.zip:
	mkdir -p coastline
	wget -O coastline/$(PLACE).osm.land.coastline.shp.zip https://s3.amazonaws.com/metro-extracts.mapzen.com/$(PLACE).land.coastline.zip
