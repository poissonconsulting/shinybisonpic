#### Upload Data Help

Get raw data into the app by filling out the template and uploading the file. The uploaded data will be run through a series of checks before it will be accepted by the app.

##### Process

1. Download and fill in template. 
   - Click the **Download Template** button
   - Open the excel file (template-bison.xlsx) that was downloaded to your computer
   - Enter the data into the file
   - Review data to ensure it follows the required data format
2. Upload data.
   - Click the **Browse...** button and select a file
   - If the file is successfully uploaded it will appear in the Uploaded data box
   - If the file is not successfully uploaded a pop up box will appear with an error message
     - Close the pop up box
     - Correct the error
     - Upload the corrected data
     - Repeat until the file is successfully uploaded
   
##### Required Data Format

The Required data format box at the top right of the page contains the checks and rules the data is run through when uploaded. 
The data will not be uploaded to the app until the required data format is followed.
The app is only able to detect one error at a time so this process may take several iterations as you work through various issues in the data format. 

Description of the rows:

- name: Name of the column.
- description: Description of the column.
- example: Example value for the column.
- constraint: The type and allowed range of values for the column.
- missing allowed: Whether missing values are allowed in the column. Missing values are blank cells in the excel file.
- primary key: Columns that make up the primary key for the table, this is the set of columns that make the row unique.
- joins to: Names the table the column joins to, the value must appear in the table listed for it to be allowed.For example a location_id must be in the *location* to be allowed in the *event* table. 

Helpful tips:

- download the template and copy your data in to the template file instead of changing your data file to follow the template format
- words must be identical this includes sheet names, column names and cell values (ie they are case sensitive and space sensitive) 

