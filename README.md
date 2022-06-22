# rufus-porter

## Welcome!

This project seeks to document the art and travels of Rufus Porter, a 19th-century American painter, inventor, and publisher. Called the "Yankee DaVinci", Porter created hundreds of murals and miniature portraits throughout New England between 1815 and 1840. 

### Format

This project consists of an interactive Shiny application, which displays an interactive map of the murals and portraits of the Rufus Porter school. The user can filter the works by artist, as well as toggling to view only signed works or only works with images. The map was built with `leaflet` and `fontAwesome`. 

### Workflow for Updates

**Input**

The script `data-prep.R` takes a .csv file called `rp_art_images.csv` and prepares
it for use in the Shiny app called `art-map`. The `rp_art_images.csv` file should
have (at minimum) the following columns:

| Variable    | Description                      |
| :-----------|----------------------------------|
| location    | Town, State. Where the piece was painted. |
| year        | When was it painted? (approximation OK)   |
| subject     | For portraits, who is it of? For murals, what house is it in? | 
| creator     | Who painted this?                | 
| type        | Portrait or mural?               | 
| attribution | Who decided who painted this?    |
| image      | A URL to the image for this point. Can take file paths, but URLs have been more reliable. |
| img_src    | The website/book/other source the image was found in. |

It is recommended that `rp_art_images.csv` NOT contain a geometry or lat/lon columns, as those will be geocoded in the `data-prep.R` script. 

**Output of the Data Prep Script**

The script `data-prep.r` will add several columns to the `rp_art` data frame, then save it as a .csv file called `art-map/data/rp_art_images_CLEAN.csv`. The output dataframe will have the following columns:

| Variable    | Description                      |
| :-----------|----------------------------------|
| location    | Town, State. Where the piece was painted. |
| year        | When was it painted? (approximation OK)   |
| subject     | For portraits, who is it of? For murals, what house is it in? | 
| creator     | Who painted this?                | 
| type        | Portrait or mural?               | 
| attribution | Who decided who painted this?    |
| icon        | Tells leaflet which icon to use for this point. |
| choice      | For Shiny filtering. The user can select which artist or category of artist they want to view (see data dictionary for explanation of values) |
| lat         | The latitude of the point. |
| lng         | The longitude of the point. |
| popup       | A description of the point, which will pop up when the point is clicked on in the leaflet map. |
| image      | A URL to the image for this point. Can take file paths, but URLs have been more reliable. |
| img_src    | The website/book/other source the image was found in. |

**Workflow**

1. Edit current Excel file of artworks to fit format. Save it as `rp_art_images.csv` in the directory `rufus-porter/art-map/data`. 

2. Run the `data-prep.R` script.

3. Run Shiny app. 

## Data Dictionary

**Attribution Variable Values**

| Value  | Explanation |
|--------|-------------|
| RPM    | This item is in the Rufus Porter Museum collection, or it has been borrowed by the Rufus Porter Museum and they agree on the attribution. |
| Bowdoin | This item is in the Bowdoin College Museum of Art collection, or it was borrowed for Bowdoin's Rufus Porter exhibit and they agreed on the attribution, or it was included in _Rufus Porter's Curious World: Art and Invention in America, 1815-1860_ and the authors agree on the attribution. |
| MFA | This item is in the collection of the Museum of Fine Arts in Boston, and this is who they attribute it to. |
| MSM | This item is in the collection of the Maine State Museum, and this is who they attribute it to. |
| OSV | This item is in the collection of Old Sturbridge Village or in an OSV-owned building, and this is who they attribute it to. |
| Lipman | Jean Lipman included this item in her book _Rufus Porter Rediscovered_. Lipman's attribution of many New England murals to Rufus Porter has since been contested, so the vast majority of Lipman-designated works have now been attributed to the Porter School, rather than to a single artist. |
| Lefko | Linda Carter Lefko and Jane E. Radcliffe included this item in their book _Folk Art Murals of the Rufus Porter School_, and this is who they attribute it to. |
| tradition | Lipman indicated that this work "traditionally attributed" to a certain artist. |
| signed | The artist signed this work. |

**Icon Variable Values**

| Value  | Explanation |
|--------|-------------|
| portrait | This point represents a portrait. The marker will be white with a light blue icon of a person. |
| rp_mural | This point represents a Rufus Porter mural. The marker will be white with a light blue house icon. |
| jdp | This point represents a mural by Jonathan D. Poor. The marker will be white with a light green tree icon. |
| school | This point represents a mural of the Rufus Porter School that is not definitively attributed to any individual. The marker will be light grey with a light blue paintbrush. | 
| other | This point represents a mural attributed to an artist other than Rufus Porter or Jonathan D. Poor. The marker will be dark grey with a light blue paintbrush. |

**Choice Variable Values**

| Value  | Explanation |
|--------|-------------|
| rp | This point represents a Rufus Porter mural or portrait. |
| jdp | This point represents a mural by Jonathan D. Poor. |
| school | This point represents a mural of the Rufus Porter School that is not definitively attributed to any individual.  | 
| other | This point represents a mural attributed to an individual artist other than Rufus Porter or Jonathan D. Poor. |


