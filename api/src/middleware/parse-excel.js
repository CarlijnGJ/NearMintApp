const xlsx = require('xlsx');

function parseExcel(filePath) {
    const workbook = xlsx.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const data = xlsx.utils.sheet_to_json(sheet);
  
    const filteredData = data.map(row => {
      let filteredRow = {};
      Object.keys(row).forEach(key => {
        if (row[key] !== 0) {
          filteredRow[key] = row[key];
        }
      });
      return filteredRow;
    }).filter(row => Object.keys(row).length > 0);
  
    console.log(filteredData);
  };

module.exports = parseExcel;
