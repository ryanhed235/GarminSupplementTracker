# Garmin Supplement Tracker

A sleek, offline-capable Connect IQ application for Garmin smartwatches (specifically optimized for AMOLED displays like the Venu 3) that allows you to rapidly log daily supplement and macro intake right from your wrist, and automatically beam that data to a private Google Sheet.

## Features
- **Ultra-Fast Ergonomic Tracking**: Custom-built UI with massive tap targets designed for sweaty gym hands. 
- **Offline History Logging**: The watch tracks your supplements offline. If you don't sync for a week, it quietly packages all 7 days of data into a hidden backlog memory bank.
- **Daily Auto-Reset**: The watch automatically takes a snapshot of your totals at the end of the day and resets your live counters to 0 for the next morning.
- **Bulk Cloud Sync**: Pressing "Sync" instantly transmits your entire offline history bank to your Google Drive in a single payload.

---

## ☁️ Setting Up The Google Sheets Integration

If you want the watch to push your supplement logs to the cloud, you need to set up a private webhook using Google Apps Script. 

### Step 1: Create the Spreadsheet
1. Open a new or existing **Google Sheet**.
2. Name the first column `Date` (leave the rest of the columns blank; the script will automatically generate headers for your supplements as they come in).

### Step 2: Deploy the Webhook
1. In your Google Sheet top menu, click **Extensions > Apps Script**.
2. Delete any existing code in the editor, and paste the following script:

```javascript
function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = JSON.parse(e.postData.contents);
  var records = data.records;
  
  var headers = sheet.getRange(1, 1, 1, sheet.getLastColumn() || 1).getValues()[0];
  if (!headers[0]) {
    headers[0] = "Date";
    sheet.getRange(1, 1).setValue("Date");
  }
  
  var lastRow = sheet.getLastRow();
  var existingDates = [];
  if (lastRow > 1) {
    existingDates = sheet.getRange(2, 1, lastRow - 1, 1).getValues().map(function(r) { return String(r[0]); });
  }

  for (var r = 0; r < records.length; r++) {
    var date = records[r].date;
    var supplements = records[r].supplements;
    
    var rowIndex = existingDates.indexOf(date);
    var isNewRow = (rowIndex === -1);
    
    var rowData = new Array(headers.length).fill("");
    if (!isNewRow) {
      rowData = sheet.getRange(rowIndex + 2, 1, 1, headers.length).getValues()[0];
    }
    rowData[0] = date;
    
    for (var i = 0; i < supplements.length; i++) {
      var suppName = supplements[i].name;
      var suppCount = supplements[i].count;
      
      var colIndex = headers.indexOf(suppName);
      if (colIndex === -1) {
        headers.push(suppName);
        colIndex = headers.length - 1;
        sheet.getRange(1, colIndex + 1).setValue(suppName);
        rowData.push(""); 
      }
      
      rowData[colIndex] = suppCount;
    }
    
    if (isNewRow) {
      sheet.appendRow(rowData);
      existingDates.push(date);
    } else {
      sheet.getRange(rowIndex + 2, 1, 1, headers.length).setValues([rowData]);
    }
  }
  
  return ContentService.createTextOutput(JSON.stringify({"status": "success"}))
    .setMimeType(ContentService.MimeType.JSON);
}
```

3. Click the blue **Deploy** button at the top right, and choose **New Deployment**.
4. Click the gear icon next to "Select type" and choose **Web app**.
5. Set "Execute as" to **Me**, and "Who has access" to **Anyone**. 
6. Click **Deploy** (you will have to authorize access to your Google account).
7. Copy the **Web app URL** it generates for you.

### Step 3: Link the Watch
1. Open the **Garmin Connect** app on your phone.
2. Navigate to your Watch Settings > Activities & Apps > Supplement Tracker > Settings.
3. Paste the **Web app URL** into the `Export Webhook URL` field.
4. Save the settings.

You're done! Scroll to the bottom of the main menu on your watch and tap **Sync** to beam your offline records straight to the spreadsheet. If successful, the watch will vibrate once. If it fails, it will buzz three times rapidly and preserve your history to try again later.
