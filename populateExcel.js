// document
//   .getElementById("expenseForm")
//   .addEventListener("submit", function (event) {
//     event.preventDefault();

//     // Read data from form
//     var school = document.getElementById("school").value;
//     var periodEnding = new Date(document.getElementById("periodEnding").value);
//     var tripPurpose = document.getElementById("tripPurpose").value;

//     // Calculate the dates for the week
//     var dates = [];
//     for (var i = 0; i < 7; i++) {
//       var date = new Date(periodEnding);
//       date.setDate(date.getDate() - periodEnding.getDay() + i);
//       dates.push(
//         date.getMonth() + 1 + "/" + date.getDate() + "/" + date.getFullYear()
//       );
//     }

//     // Function to load the Excel template and populate it
//     function loadTemplateAndPopulate(url) {
//       var oReq = new XMLHttpRequest();
//       oReq.open("GET", url, true);
//       oReq.responseType = "arraybuffer";

//       oReq.onload = function (e) {
//         var arraybuffer = oReq.response;
//         var data = new Uint8Array(arraybuffer);
//         var workbook = XLSX.read(data, { type: "array" });

//         var firstSheetName = workbook.SheetNames[0];
//         var worksheet = workbook.Sheets[firstSheetName];

//         // Populate the worksheet with form data
//         worksheet["A5"].v = school; // Cell A5 for School
//         worksheet["F5"].v = tripPurpose; // Cell F5 for Trip Purpose
//         worksheet["F4"].v = XLSX.utils.format_cell({ v: periodEnding, t: "d" }); // Cell F4 for Period Ending

//         // Populate the dates
//         var dateCells = ["D7", "E7", "F7", "G7", "H7", "I7", "J7"]; // Cells for the dates from Sunday to Saturday
//         dates.forEach(function (date, index) {
//           worksheet[dateCells[index]].v = date;
//           worksheet[dateCells[index]].t = "s"; // Set the cell type to string
//         });

//         // Write the workbook to a new file
//         XLSX.writeFile(workbook, "PopulatedTemplate.xlsx");
//       };

//       oReq.send();
//     }

//     // URL to your Excel template
//     var templateURL = "expense_report.xlsx"; // Replace with the actual URL
//     loadTemplateAndPopulate(templateURL);
//   });
