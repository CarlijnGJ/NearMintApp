const xlsx = require('xlsx');

function excelDateToSQLTimestamp(serial) {
    const utcDays = Math.floor(serial - 25569);
    const utcValue = utcDays * 86400;
    const dateInfo = new Date(utcValue * 1000);

    const year = dateInfo.getFullYear();
    const month = ('0' + (dateInfo.getMonth() + 1)).slice(-2);
    const day = ('0' + dateInfo.getDate()).slice(-2);
    const hours = ('0' + dateInfo.getHours()).slice(-2);
    const minutes = ('0' + dateInfo.getMinutes()).slice(-2);
    const seconds = ('0' + dateInfo.getSeconds()).slice(-2);

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
}

function excelImportPlayerCreditGeneral(filePath) {
    const workbook = xlsx.readFile(filePath);
    const sheetName = workbook.SheetNames.find(sheet => sheet === 'Player credit general');
    const sheet = workbook.Sheets[sheetName];
    const data = xlsx.utils.sheet_to_json(sheet);
    let filteredDataArray = [];

    const filteredData = data.map(row => {
      let filteredRow = {};
      Object.keys(row).forEach(key => {
        if (row[key] !== 0 && (key === 'Account name' || key === 'credit total')) {
          filteredRow[key] = row[key];
        }
      });
      return filteredRow;
    }).filter(row => Object.keys(row).length > 0).forEach(row => {
        if (row !== ' ' || row !== '') { //to make sure it does not get empty rows
            filteredDataArray.push(row)
        }
    });
    console.log(filteredDataArray);
    return filteredDataArray;
};
function excelImportDailyIncomeAndExpenses(filePath) {
    const workbook = xlsx.readFile(filePath);
    const sheetName = workbook.SheetNames.find(sheet => sheet === 'Daily income & expenses');
    const sheet = workbook.Sheets[sheetName];
    const data = xlsx.utils.sheet_to_json(sheet);
    let filteredDataArray = [];

    const filteredData = data.map(row => {
        let filteredRow = {};
        Object.keys(row).forEach(key => {
            if (row[key] !== 0 && (key === 'Player Name' || key === 'Date' || key === 'Sale amount' || key === 'Discription')) {
                if (key === 'Date') {
                    filteredRow[key] = excelDateToSQLTimestamp(row[key]);
                } else {
                    filteredRow[key] = row[key];
                }
            }
        });
        return filteredRow;
    }).filter(row => Object.keys(row).length > 0).forEach(row => {
        if (row !== ' ' || row !== '') { //to make sure it does not get empty rows
            filteredDataArray.push(row);
        }
    });
    return filteredDataArray;
}
module.exports = {excelImportPlayerCreditGeneral, excelImportDailyIncomeAndExpenses} ;