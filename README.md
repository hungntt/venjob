Website: http://venjob.herokuapp.com/
- Ruby version: 6
- Database: mysql2
- Stylesheet: bootstrap 4, scss

# DATABASE
* Create model User with Devise.
* Create other models and their associations based on the database model.
* Migrate into the mysql database


# SET UP SOLR SERVER
* Import from MySQL to Solr (version 8.3.1)
    * Set up Dataimport
        * Move to the config folder of the core
            * Find the data folder of the core (find at the Overview), for example:  `````/var/solr/data/venjob/data`````
            * Open cmd to edit the ```solrconfig.xml``` file: 
                * ```sudo -s```
                * ```cd /data/venjob/conf```
                * ```gedit solrconfig.xml```
                * Add to file ```solrconfig.xml``` 2 lines:
                    * Import lib: ```<lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-.*\.jar" />```
                    * Import RequestHandler: ``` <requestHandler name="/dataimport" class="org.apache.solr.handler.dataimport.DataImportHandler">
                                                    <lst name="defaults">
                                                      <str name="config">/home/username/data-config.xml</str>
                                                    </lst>
                                                  </requestHandler>
                                                  ```
        * Configuring DataSources
        
                

       
