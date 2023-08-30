shinybisonpic User Guide
================
30 August, 2023

shinybisonpic is an online application that allows users to upload,
view, and process their camera trap count data.

## Getting Starting

### Access the App

The app can be accessed using the link:

The app is publicaly avaliable so no username or password is required to
open the webpage.

## Process

### Tab 1. Data Upload

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/home-screen.png" width="100%">
*<font size="-1">Figure x. Data upload tab and opening screen of
app.</font>*

If the app launches successfully you should see this page.

Review the instructions in the help file for the tab by clicking the
blue question mark in the instructions box on the left side of the page.

1.  Download and fill in template.
    - Click the Download Template button
    - Open the excel file (template-bison.xlsx) that was downloaded to
      your computer
    - Enter the data into the file
    - Review data to ensure it follows the required data format
2.  Upload data.
    - Click the Browse… button and select a file
    - If the file is successfully uploaded it will appear in the
      Uploaded data box
    - If the file is not successfully uploaded a pop up box will appear
      with an error message
    - Close the pop up box
    - Correct the error
    - Upload the corrected data
    - Repeat until the file is successfully uploaded

**Required Data Format**

The Required data format box at the top right of the page contains the
checks and rules the data is run through when uploaded. The data will
not be uploaded to the app until the required data format is followed.
The app is only able to detect one error at a time so this process may
take several iterations as you work through various issues in the data
format.

Description of the rows:

- name: Name of the column.
- description: Description of the column.
- example: Example value for the column.
- constraint: The type and allowed range of values for the column.
- missing allowed: Whether missing values are allowed in the column.
  Missing values are blank cells in the excel file.
- primary key: Columns that make up the primary key for the table, this
  is the set of columns that make the row unique.
- joins to: Names the table the column joins to, the value must appear
  in the table listed for it to be allowed.For example a location_id
  must be in the location to be allowed in the event table.

Helpful tips:

- download the template and copy your data in to the template file
  instead of changing your data file to follow the template format
- words must be identical this includes sheet names, column names and
  cell values (ie they are case sensitive and space sensitive)

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/data-upload-successful.png" width="100%">
*<font size="-1">Figure x. Data upload is successful.</font>*

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/data-upload-failure.png" width="100%">
*<font size="-1">Figure x. Data upload failed due to not following the
Required data format.</font>*

### Tab 2. Map Locations

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/map-locations-point.png" width="100%">
*<font size="-1">Figure x. Map Location tab showing the points on the
map with location RLBH012 highlighted as its selected in the drop down
and location RLBH018 clicked on to show a pop-up with the specific
details about the location.</font>*

Explore the location of each camera on the map. The location_id’s from
the location table will be displayed on the map.

**Features**

- Select the location name from the drop down menu to highlight the
  point on the map
- Click on a point on the map to find the name and coordinates for that
  point
- Use your mouse or arrow keys to move around the map
- Use the +/- buttons at the top left of the map or scroll with your
  mouse to zoom in and out
- Select the map type at top left of the map underneath the +/- buttons
  to switch between map types

**Trouble Shooting**

- No points on the map
  - Check that you have uploaded a data set in the Upload Data tab.
  - Check that the latitude and longitude columns in the location table
    have values populated.
  - Check that the coordinates are decimal degree latitude and longitude
    values.
  - Zoom out to see if the points are somewhere else in the world.
- Drop down field is empty
  - Make sure you have uploaded a data set in the Upload Data tab.
  - Check that the location_id column in the location table has values
    populated.
- Map is frozen
  - Refresh your browser and upload the data again.

### Tab 3. Plot Data

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/plot-data-blank-page.png" width="100%">
*<font size="-1">Figure x. Plot Data tab with no variables
selected.</font>*

Explore the ratios of various sex-age groups by selecting any
combinations of values.

For the plot to appear, you must:

- select at least one value for the Numerator
- select at least one value for the Denominator

The plot can be downloaded as a .png file by pressing the Download Plot
button on the top right of the Plots box.

Example To view a plot of female calves against all calves:

In the Numerator tick female calf. In the Denominator tick male calf,
female calf and unknown calf.

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/plot-data-ratios-selected.png" width="100%">
*<font size="-1">Figure x. Plot Data tab showing example data.</font>*

### Tab 4. Download Data

<img src= "https://github.com/poissonconsulting/shinybisonpic/blob/main/vignettes/images/download-data-data-present.png" width="100%">
*<font size="-1">Figure x. Download Data tab showing processed
data.</font>*

Get processed data out of the app that is ready for modeling. Click the
Download Clean Data button.

**Trouble Shooting**

- No data in the Model ready data box
  - Check that you successfully uploaded a data set in the Upload Data
    tab.

### Next Steps in Modeling App

#### TO DO
