package com.example.hrms.util;

import com.example.hrms.model.Employee;
import com.example.hrms.model.Payroll;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.itextpdf.text.pdf.draw.LineSeparator;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Utility class for generating PDF documents
 */
public class PDFService {

    /**
     * Generate a payslip PDF
     *
     * @param payroll  The payroll object
     * @param employee The employee object
     * @return Byte array containing the PDF document
     * @throws DocumentException If there's an error generating the PDF
     */
    public static byte[] generatePayslipPDF(Payroll payroll, Employee employee) throws DocumentException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4);

        try {
            // Create a writer instance (required for PDF generation)
            PdfWriter.getInstance(document, baos);
            document.open();

            // Add company logo or header
            addHeader(document);

            // Add payslip title
            addTitle(document, "PAYSLIP - " + payroll.getFormattedMonth());

            // Add employee information
            addEmployeeInfo(document, employee, payroll);

            // Add earnings and deductions
            addEarningsAndDeductions(document, payroll);

            // Add summary
            addSummary(document, payroll);

            // Add footer
            addFooter(document);

            document.close();
            return baos.toByteArray();
        } catch (DocumentException e) {
            throw e;
        } finally {
            if (document.isOpen()) {
                document.close();
            }
        }
    }

    private static void addHeader(Document document) throws DocumentException {
        Paragraph header = new Paragraph();
        header.setAlignment(Element.ALIGN_CENTER);

        // Company name
        Font companyNameFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Chunk companyName = new Chunk("HRMS COMPANY", companyNameFont);
        header.add(companyName);
        header.add(Chunk.NEWLINE);

        // Company address
        Font addressFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.DARK_GRAY);
        Chunk address = new Chunk("123 Business Street, Suite 100, Business City, 12345", addressFont);
        header.add(address);
        header.add(Chunk.NEWLINE);

        // Company contact
        Chunk contact = new Chunk("Phone: (123) 456-7890 | Email: hr@hrmscompany.com", addressFont);
        header.add(contact);
        header.add(Chunk.NEWLINE);
        header.add(Chunk.NEWLINE);

        document.add(header);

        // Add a separator line
        LineSeparator line = new LineSeparator();
        line.setLineColor(BaseColor.LIGHT_GRAY);
        document.add(new Chunk(line));
        document.add(Chunk.NEWLINE);
    }

    private static void addTitle(Document document, String title) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph titleParagraph = new Paragraph(title, titleFont);
        titleParagraph.setAlignment(Element.ALIGN_CENTER);
        titleParagraph.setSpacingAfter(20);
        document.add(titleParagraph);
    }

    private static void addEmployeeInfo(Document document, Employee employee, Payroll payroll) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        // Define fonts
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 10);

        // Employee ID
        addTableCell(table, "Employee ID:", headerFont);
        addTableCell(table, String.valueOf(employee.getId()), valueFont);

        // Employee Name
        addTableCell(table, "Employee Name:", headerFont);
        addTableCell(table, employee.getName(), valueFont);

        // Department
        addTableCell(table, "Department:", headerFont);
        addTableCell(table, employee.getDepartmentName(), valueFont);

        // Designation
        addTableCell(table, "Designation:", headerFont);
        addTableCell(table, employee.getDesignationTitle(), valueFont);

        // Pay Period
        addTableCell(table, "Pay Period:", headerFont);
        addTableCell(table, payroll.getFormattedMonth(), valueFont);

        // Payment Date
        addTableCell(table, "Payment Date:", headerFont);
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        addTableCell(table, dateFormat.format(payroll.getGenerationDate()), valueFont);

        document.add(table);
        document.add(Chunk.NEWLINE);
    }

    private static void addEarningsAndDeductions(Document document, Payroll payroll) throws DocumentException {
        // Create a table with 2 columns
        PdfPTable mainTable = new PdfPTable(2);
        mainTable.setWidthPercentage(100);
        mainTable.setSpacingBefore(10f);
        mainTable.setSpacingAfter(10f);

        // Define fonts
        Font sectionFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 10);

        // Earnings section
        PdfPCell earningsCell = new PdfPCell();
        earningsCell.setBorder(Rectangle.NO_BORDER);
        Paragraph earningsTitle = new Paragraph("Earnings", sectionFont);
        earningsTitle.setSpacingAfter(5f);
        earningsCell.addElement(earningsTitle);

        // Earnings table
        PdfPTable earningsTable = new PdfPTable(2);
        earningsTable.setWidthPercentage(100);

        // Base Salary
        addTableCell(earningsTable, "Base Salary:", headerFont);
        addTableCell(earningsTable, formatCurrency(payroll.getBaseSalary()), valueFont);

        // Allowances
        addTableCell(earningsTable, "Allowances:", headerFont);
        addTableCell(earningsTable, formatCurrency(payroll.getAllowances()), valueFont);

        // Total Earnings
        BigDecimal totalEarnings = payroll.getBaseSalary().add(payroll.getAllowances());
        addTableCell(earningsTable, "Total Earnings:", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
        addTableCell(earningsTable, formatCurrency(totalEarnings), new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));

        earningsCell.addElement(earningsTable);
        mainTable.addCell(earningsCell);

        // Deductions section
        PdfPCell deductionsCell = new PdfPCell();
        deductionsCell.setBorder(Rectangle.NO_BORDER);
        Paragraph deductionsTitle = new Paragraph("Deductions", sectionFont);
        deductionsTitle.setSpacingAfter(5f);
        deductionsCell.addElement(deductionsTitle);

        // Deductions table
        PdfPTable deductionsTable = new PdfPTable(2);
        deductionsTable.setWidthPercentage(100);

        // Deductions
        addTableCell(deductionsTable, "Deductions:", headerFont);
        addTableCell(deductionsTable, formatCurrency(payroll.getDeductions()), valueFont);

        // Attendance Deductions
        BigDecimal attendanceDeduction = calculateAttendanceDeduction(payroll);
        addTableCell(deductionsTable, "Attendance Deductions:", headerFont);
        addTableCell(deductionsTable, formatCurrency(attendanceDeduction), valueFont);

        // Total Deductions
        BigDecimal totalDeductions = payroll.getDeductions().add(attendanceDeduction);
        addTableCell(deductionsTable, "Total Deductions:", new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));
        addTableCell(deductionsTable, formatCurrency(totalDeductions), new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD));

        deductionsCell.addElement(deductionsTable);
        mainTable.addCell(deductionsCell);

        document.add(mainTable);
        document.add(Chunk.NEWLINE);
    }

    private static void addSummary(Document document, Payroll payroll) throws DocumentException {
        // Add a separator line
        LineSeparator line = new LineSeparator();
        line.setLineColor(BaseColor.LIGHT_GRAY);
        document.add(new Chunk(line));
        document.add(Chunk.NEWLINE);

        // Create a table for the summary
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        table.setSpacingAfter(10f);

        // Define fonts
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, new BaseColor(0, 102, 204));

        // Net Salary
        addTableCell(table, "NET SALARY:", headerFont);
        addTableCell(table, formatCurrency(payroll.getNetSalary()), valueFont);

        // Payment Status
        addTableCell(table, "Payment Status:", headerFont);
        addTableCell(table, payroll.getStatus(), valueFont);

        document.add(table);
        document.add(Chunk.NEWLINE);

        // Add attendance summary
        addAttendanceSummary(document, payroll);
    }

    private static void addAttendanceSummary(Document document, Payroll payroll) throws DocumentException {
        // Add attendance summary title
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("Attendance Summary", titleFont);
        title.setSpacingBefore(10f);
        title.setSpacingAfter(5f);
        document.add(title);

        // Create a table for attendance summary
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100);
        table.setSpacingBefore(5f);
        table.setSpacingAfter(10f);

        // Define fonts
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 10);

        // Add headers
        addTableCell(table, "Days Present", headerFont);
        addTableCell(table, "Days Absent", headerFont);
        addTableCell(table, "Days Late", headerFont);
        addTableCell(table, "Half Days", headerFont);
        addTableCell(table, "Working Days", headerFont);

        // Add values
        addTableCell(table, String.valueOf(payroll.getDaysPresent()), valueFont);
        addTableCell(table, String.valueOf(payroll.getDaysAbsent()), valueFont);
        addTableCell(table, String.valueOf(payroll.getDaysLate()), valueFont);
        addTableCell(table, String.valueOf(payroll.getDaysHalf()), valueFont);
        addTableCell(table, String.valueOf(payroll.getDaysPresent() + payroll.getDaysAbsent() + payroll.getDaysLate() + payroll.getDaysHalf()), valueFont);

        document.add(table);
    }

    private static void addFooter(Document document) throws DocumentException {
        // Add a separator line
        LineSeparator line = new LineSeparator();
        line.setLineColor(BaseColor.LIGHT_GRAY);
        document.add(new Chunk(line));
        document.add(Chunk.NEWLINE);

        // Add footer text
        Font footerFont = new Font(Font.FontFamily.HELVETICA, 8, Font.ITALIC, BaseColor.GRAY);
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);

        // Add current date
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        Chunk dateChunk = new Chunk("Generated on: " + dateFormat.format(new Date()), footerFont);
        footer.add(dateChunk);
        footer.add(Chunk.NEWLINE);

        // Add disclaimer
        Chunk disclaimer = new Chunk("This is a computer-generated document. No signature is required.", footerFont);
        footer.add(disclaimer);

        document.add(footer);
    }

    private static void addTableCell(PdfPTable table, String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(5);
        cell.setBorder(Rectangle.NO_BORDER);
        table.addCell(cell);
    }

    private static String formatCurrency(BigDecimal amount) {
        DecimalFormat df = new DecimalFormat("$#,##0.00");
        return df.format(amount);
    }

    private static BigDecimal calculateAttendanceDeduction(Payroll payroll) {
        // Calculate deduction based on attendance
        BigDecimal dailyRate = payroll.getBaseSalary().divide(new BigDecimal(30), 2, java.math.RoundingMode.HALF_UP);
        BigDecimal absentDeduction = dailyRate.multiply(new BigDecimal(payroll.getDaysAbsent()));
        BigDecimal lateDeduction = dailyRate.multiply(new BigDecimal(payroll.getDaysLate())).multiply(new BigDecimal("0.5"));
        BigDecimal halfDayDeduction = dailyRate.multiply(new BigDecimal(payroll.getDaysHalf())).multiply(new BigDecimal("0.5"));

        return absentDeduction.add(lateDeduction).add(halfDayDeduction);
    }
}
