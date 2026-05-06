package com.school.model.admin;

import java.util.Date;

public class Staff {
    private int staff_id;
    private String name;
    private String role;
    private String mobile;
    private String email;
    private String gender;
    private Date dob;
    private double salary;
    private String status;
    private String photo;
    private String address;
    private Date joining_date;

    public int getStaff_id() { return staff_id; }
    public void setStaff_id(int staff_id) { this.staff_id = staff_id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public Date getJoining_date() { return joining_date; }
    public void setJoining_date(Date joining_date) { this.joining_date = joining_date; }
}