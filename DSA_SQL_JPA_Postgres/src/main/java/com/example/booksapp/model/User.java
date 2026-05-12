package com.example.booksapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @Column(name = "user_id")
    private Integer userId;

    private String location;

    private Integer age;

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
}