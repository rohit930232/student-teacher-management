package com.school.model.teacher;

import java.util.Date;

public class Teacher {

    private String username;
    private String name;
    private String email;
    private String password;
    private String mobile;
    private String subject;
    private double salary;
    private String photo;
    private int class_id;

    private Date dob;
    private int age;
    private String gender;
    private String qualification;
    private int experience;
    private String class_teacher;
    private String status;

    private String account_holder;
    private String account_number;
    private String bank_name;
    private String ifsc_code;
    private String branch;
    private String pan_number;
    private String upi_id;

    private String address;
    private String permanent_address;

    // getters setters (short)

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getMobile() { return mobile; }
    public void setMobile(String mobile) { this.mobile = mobile; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public int getClass_id() { return class_id; }
    public void setClass_id(int class_id) { this.class_id = class_id; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getQualification() { return qualification; }
    public void setQualification(String qualification) { this.qualification = qualification; }

    public int getExperience() { return experience; }
    public void setExperience(int experience) { this.experience = experience; }

    public String getClass_teacher() { return class_teacher; }
    public void setClass_teacher(String class_teacher) { this.class_teacher = class_teacher; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAccount_holder() { return account_holder; }
    public void setAccount_holder(String account_holder) { this.account_holder = account_holder; }

    public String getAccount_number() { return account_number; }
    public void setAccount_number(String account_number) { this.account_number = account_number; }

    public String getBank_name() { return bank_name; }
    public void setBank_name(String bank_name) { this.bank_name = bank_name; }

    public String getIfsc_code() { return ifsc_code; }
    public void setIfsc_code(String ifsc_code) { this.ifsc_code = ifsc_code; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }

    public String getPan_number() { return pan_number; }
    public void setPan_number(String pan_number) { this.pan_number = pan_number; }

    public String getUpi_id() { return upi_id; }
    public void setUpi_id(String upi_id) { this.upi_id = upi_id; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPermanent_address() { return permanent_address; }
    public void setPermanent_address(String permanent_address) { this.permanent_address = permanent_address; }
}