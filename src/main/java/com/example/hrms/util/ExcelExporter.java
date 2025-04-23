package com.example.hrms.util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Utility class for exporting data to Excel format
 */
public class ExcelExporter {

    /**
     * Export data to Excel
     *
     * @param response The HTTP response
     * @param title The title of the Excel sheet
     * @param headers The column headers
     * @param data The data to export
     * @param filename The filename of the Excel file
     */
    public static void exportToExcel(HttpServletResponse response, String title, 
                                    List<String> headers, List<List<String>> data, String filename) throws IOException {
        // Set response headers
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        
        // Create workbook
        Workbook workbook = new XSSFWorkbook();
        
        // Create sheet
        Sheet sheet = workbook.createSheet(title);
        
        // Create header row
        Row headerRow = sheet.createRow(0);
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        Font headerFont = workbook.createFont();
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // Add header cells
        for (int i = 0; i < headers.size(); i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers.get(i));
            cell.setCellStyle(headerStyle);
        }
        
        // Create data rows
        CellStyle evenRowStyle = workbook.createCellStyle();
        evenRowStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        evenRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        CellStyle oddRowStyle = workbook.createCellStyle();
        
        for (int i = 0; i < data.size(); i++) {
            Row row = sheet.createRow(i + 1);
            List<String> rowData = data.get(i);
            
            // Apply alternating row styles
            CellStyle rowStyle = (i % 2 == 0) ? oddRowStyle : evenRowStyle;
            
            for (int j = 0; j < rowData.size(); j++) {
                Cell cell = row.createCell(j);
                cell.setCellValue(rowData.get(j));
                cell.setCellStyle(rowStyle);
            }
        }
        
        // Auto-size columns
        for (int i = 0; i < headers.size(); i++) {
            sheet.autoSizeColumn(i);
        }
        
        // Add title and date in a separate sheet
        Sheet infoSheet = workbook.createSheet("Info");
        Row titleRow = infoSheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Report: " + title);
        
        Row dateRow = infoSheet.createRow(1);
        Cell dateCell = dateRow.createCell(0);
        dateCell.setCellValue("Generated on: " + java.time.LocalDate.now().toString());
        
        // Write to response
        workbook.write(response.getOutputStream());
        workbook.close();
    }
    
    /**
     * Export chart data to Excel
     *
     * @param response The HTTP response
     * @param title The title of the Excel sheet
     * @param chartData The chart data to export
     * @param filename The filename of the Excel file
     */
    public static void exportChartToExcel(HttpServletResponse response, String title, 
                                         Map<String, Object> chartData, String filename) throws IOException {
        // Set response headers
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        
        // Create workbook
        Workbook workbook = new XSSFWorkbook();
        
        // Create sheet
        Sheet sheet = workbook.createSheet(title);
        
        // Create header row
        Row headerRow = sheet.createRow(0);
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.BLUE.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        Font headerFont = workbook.createFont();
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // Add header cells
        Cell labelHeader = headerRow.createCell(0);
        labelHeader.setCellValue("Label");
        labelHeader.setCellStyle(headerStyle);
        
        Cell valueHeader = headerRow.createCell(1);
        valueHeader.setCellValue("Value");
        valueHeader.setCellStyle(headerStyle);
        
        // Create data rows
        CellStyle evenRowStyle = workbook.createCellStyle();
        evenRowStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        evenRowStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        
        CellStyle oddRowStyle = workbook.createCellStyle();
        
        // Get labels and data
        List<String> labels = (List<String>) chartData.get("labels");
        List<Object> values = (List<Object>) chartData.get("data");
        
        for (int i = 0; i < labels.size(); i++) {
            Row row = sheet.createRow(i + 1);
            
            // Apply alternating row styles
            CellStyle rowStyle = (i % 2 == 0) ? oddRowStyle : evenRowStyle;
            
            // Label cell
            Cell labelCell = row.createCell(0);
            labelCell.setCellValue(labels.get(i));
            labelCell.setCellStyle(rowStyle);
            
            // Value cell
            Cell valueCell = row.createCell(1);
            Object value = values.get(i);
            
            if (value instanceof Number) {
                if (value instanceof Double) {
                    valueCell.setCellValue((Double) value);
                } else if (value instanceof Integer) {
                    valueCell.setCellValue((Integer) value);
                } else {
                    valueCell.setCellValue(value.toString());
                }
            } else {
                valueCell.setCellValue(value.toString());
            }
            
            valueCell.setCellStyle(rowStyle);
        }
        
        // Auto-size columns
        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
        
        // Add title and date in a separate sheet
        Sheet infoSheet = workbook.createSheet("Info");
        Row titleRow = infoSheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Report: " + title);
        
        Row dateRow = infoSheet.createRow(1);
        Cell dateCell = dateRow.createCell(0);
        dateCell.setCellValue("Generated on: " + java.time.LocalDate.now().toString());
        
        Row sourceRow = infoSheet.createRow(2);
        Cell sourceCell = sourceRow.createCell(0);
        sourceCell.setCellValue("Source: HRMS System");
        
        // Write to response
        workbook.write(response.getOutputStream());
        workbook.close();
    }
}
