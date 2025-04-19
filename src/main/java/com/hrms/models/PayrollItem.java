package com.hrms.models;

import java.math.BigDecimal;

public class PayrollItem {
    private int id;
    private int payrollId;
    private String itemType; // ALLOWANCE, DEDUCTION, BONUS, TAX
    private String itemName;
    private BigDecimal amount;
    private String description;
    
    // Constructors
    public PayrollItem() {
    }
    
    public PayrollItem(int payrollId, String itemType, String itemName, BigDecimal amount, String description) {
        this.payrollId = payrollId;
        this.itemType = itemType;
        this.itemName = itemName;
        this.amount = amount;
        this.description = description;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getPayrollId() {
        return payrollId;
    }
    
    public void setPayrollId(int payrollId) {
        this.payrollId = payrollId;
    }
    
    public String getItemType() {
        return itemType;
    }
    
    public void setItemType(String itemType) {
        this.itemType = itemType;
    }
    
    public String getItemName() {
        return itemName;
    }
    
    public void setItemName(String itemName) {
        this.itemName = itemName;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    @Override
    public String toString() {
        return "PayrollItem{" +
                "id=" + id +
                ", payrollId=" + payrollId +
                ", itemType='" + itemType + '\'' +
                ", itemName='" + itemName + '\'' +
                ", amount=" + amount +
                '}';
    }
}
