package com.example.hrms.model;

public class Designation {
    private int id;
    private String title;
    
    public Designation() {
    }
    
    public Designation(int id, String title) {
        this.id = id;
        this.title = title;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    @Override
    public String toString() {
        return "Designation{" +
                "id=" + id +
                ", title='" + title + '\'' +
                '}';
    }
}
