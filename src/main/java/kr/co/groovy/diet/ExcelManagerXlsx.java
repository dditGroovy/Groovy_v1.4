package kr.co.groovy.diet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelManagerXlsx {

	private static ExcelManagerXlsx excelXlsxMng;

	public ExcelManagerXlsx() {
	}

	public static ExcelManagerXlsx getInstance() {
		if (excelXlsxMng == null)
			excelXlsxMng = new ExcelManagerXlsx();
		return excelXlsxMng;
	}

	public List<HashMap<String, String>> getListXlsxRead(String excel) throws Exception {
		List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		File file = new File(excel);
		if (!file.exists() || !file.isFile() || !file.canRead()) {
			throw new IOException(excel);
		}
		XSSFWorkbook wb = new XSSFWorkbook(new FileInputStream(file));

		int check = 0;

		try {
			for (int i = 0; i < 1; i++) {
				for (Row row : wb.getSheetAt(i)) {
					if (check != 0) {

						HashMap<String, String> hMap = new HashMap<String, String>();
						String valueStr = "";
						int cellLength = (int) row.getLastCellNum();

						for (int j = 0; j < cellLength; j++) {
							Cell cell = row.getCell(j);

							if (cell == null || cell.getCellType() == CellType.BLANK) {
								valueStr = "";
							} else {
								switch (cell.getCellType()) {
								case STRING:
									valueStr = cell.getStringCellValue();
									break;
								case NUMERIC: 
									if (DateUtil.isCellDateFormatted(cell)) { 
										SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.KOREA);
										String formattedStr = dateFormat.format(cell.getDateCellValue());
										valueStr = formattedStr;
										break;
									} else { 
										Double numericCellValue = cell.getNumericCellValue();
										if (Math.floor(numericCellValue) == numericCellValue) { 
																								
											valueStr = numericCellValue.intValue() + ""; 
																						
										} else {
											valueStr = numericCellValue + "";
										}
										break;
									}
								case BOOLEAN:
									valueStr = cell.getBooleanCellValue() + "";
									break;
								}
							}
							hMap.put("cell_" + j, valueStr);
						}
						list.add(hMap);
					}
					check++;
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return list;
	}
}