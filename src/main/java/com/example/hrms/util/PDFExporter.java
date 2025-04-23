package com.example.hrms.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Utility class for exporting data to PDF format
 */
public class PDFExporter {

    /**
     * Export data to PDF
     *
     * @param response The HTTP response
     * @param title The title of the PDF
     * @param headers The column headers
     * @param data The data to export
     * @param filename The filename of the PDF
     */
    public static void exportToPDF(HttpServletResponse response, String title, 
                                  List<String> headers, List<List<String>> data, String filename) throws IOException, DocumentException {
        // Set response headers
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        
        // Create document
        Document document = new Document(PageSize.A4.rotate());
        PdfWriter.getInstance(document, response.getOutputStream());
        
        // Open document
        document.open();
        
        // Add title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
        Paragraph titleParagraph = new Paragraph(title, titleFont);
        titleParagraph.setAlignment(Element.ALIGN_CENTER);
        titleParagraph.setSpacingAfter(20);
        document.add(titleParagraph);
        
        // Add date
        Font dateFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.DARK_GRAY);
        Paragraph dateParagraph = new Paragraph("Generated on: " + java.time.LocalDate.now().toString(), dateFont);
        dateParagraph.setAlignment(Element.ALIGN_RIGHT);
        dateParagraph.setSpacingAfter(20);
        document.add(dateParagraph);
        
        // Create table
        PdfPTable table = new PdfPTable(headers.size());
        table.setWidthPercentage(100);
        
        // Add header row
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(new BaseColor(41, 128, 185)); // Blue header
            cell.setPadding(8);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
        
        // Add data rows
        Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK);
        boolean alternate = false;
        for (List<String> row : data) {
            for (String cell : row) {
                PdfPCell pdfCell = new PdfPCell(new Phrase(cell, dataFont));
                if (alternate) {
                    pdfCell.setBackgroundColor(new BaseColor(240, 240, 240)); // Light gray for alternate rows
                }
                pdfCell.setPadding(6);
                table.addCell(pdfCell);
            }
            alternate = !alternate;
        }
        
        // Add table to document
        document.add(table);
        
        // Close document
        document.close();
    }
    
    /**
     * Export chart data to PDF
     *
     * @param response The HTTP response
     * @param title The title of the PDF
     * @param chartData The chart data to export
     * @param filename The filename of the PDF
     */
    public static void exportChartToPDF(HttpServletResponse response, String title, 
                                       Map<String, Object> chartData, String filename) throws IOException, DocumentException {
        // Set response headers
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        
        // Create document
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, response.getOutputStream());
        
        // Open document
        document.open();
        
        // Add title
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
        Paragraph titleParagraph = new Paragraph(title, titleFont);
        titleParagraph.setAlignment(Element.ALIGN_CENTER);
        titleParagraph.setSpacingAfter(20);
        document.add(titleParagraph);
        
        // Add date
        Font dateFont = FontFactory.getFont(FontFactory.HELVETICA, 12, BaseColor.DARK_GRAY);
        Paragraph dateParagraph = new Paragraph("Generated on: " + java.time.LocalDate.now().toString(), dateFont);
        dateParagraph.setAlignment(Element.ALIGN_RIGHT);
        dateParagraph.setSpacingAfter(20);
        document.add(dateParagraph);
        
        // Create table for chart data
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(80);
        table.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        // Add header row
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
        
        PdfPCell labelHeader = new PdfPCell(new Phrase("Label", headerFont));
        labelHeader.setBackgroundColor(new BaseColor(41, 128, 185));
        labelHeader.setPadding(8);
        labelHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(labelHeader);
        
        PdfPCell valueHeader = new PdfPCell(new Phrase("Value", headerFont));
        valueHeader.setBackgroundColor(new BaseColor(41, 128, 185));
        valueHeader.setPadding(8);
        valueHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(valueHeader);
        
        // Add data rows
        Font dataFont = FontFactory.getFont(FontFactory.HELVETICA, 11, BaseColor.BLACK);
        boolean alternate = false;
        
        // Get labels and data
        List<String> labels = (List<String>) chartData.get("labels");
        List<Object> values = (List<Object>) chartData.get("data");
        
        for (int i = 0; i < labels.size(); i++) {
            // Label cell
            PdfPCell labelCell = new PdfPCell(new Phrase(labels.get(i), dataFont));
            if (alternate) {
                labelCell.setBackgroundColor(new BaseColor(240, 240, 240));
            }
            labelCell.setPadding(6);
            table.addCell(labelCell);
            
            // Value cell
            String valueStr = values.get(i).toString();
            PdfPCell valueCell = new PdfPCell(new Phrase(valueStr, dataFont));
            if (alternate) {
                valueCell.setBackgroundColor(new BaseColor(240, 240, 240));
            }
            valueCell.setPadding(6);
            valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(valueCell);
            
            alternate = !alternate;
        }
        
        // Add table to document
        document.add(table);
        
        // Add summary
        Font summaryFont = FontFactory.getFont(FontFactory.HELVETICA_ITALIC, 12, BaseColor.DARK_GRAY);
        Paragraph summaryParagraph = new Paragraph("This report was generated from the HRMS system.", summaryFont);
        summaryParagraph.setAlignment(Element.ALIGN_CENTER);
        summaryParagraph.setSpacingBefore(20);
        document.add(summaryParagraph);
        
        // Close document
        document.close();
    }
}
