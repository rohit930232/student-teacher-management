package com.school.model.student;

import java.util.Date;

public class Student {
    private int student_id;
    private String username;
    private String name;
    private String email;
    private String password;
    private String student_mobile;
    private String permanent_address;
    private String temporary_address;
    private String photo;
    private int class_id;
    private String father_name;
    private String mother_name;
    private String parents_mobile;
    private String father_occupation;
    private String mother_occupation;
    private double annual_income;
    private Date dob;
    private String blood_group;
    private String gender;
    private int roll_number;
    private double fees_paid;
    private double fees_remaining;
    public Student() {}

    public Student(String username, String name, String email, String password, 
                   String student_mobile, String permanent_address, String temporary_address, 
                   String photo, int class_id, String father_name, String mother_name, 
                   String parents_mobile, String father_occupation, String mother_occupation, 
                   double annual_income, Date dob, String blood_group, String gender, int roll_number) {
        this.username = username;
        this.name = name;
        this.email = email;
        this.password = password;
        this.student_mobile = student_mobile;
        this.permanent_address = permanent_address;
        this.temporary_address = temporary_address;
        this.photo = photo;
        this.class_id = class_id;
        this.father_name = father_name;
        this.mother_name = mother_name;
        this.parents_mobile = parents_mobile;
        this.father_occupation = father_occupation;
        this.mother_occupation = mother_occupation;
        this.annual_income = annual_income;
        this.dob = dob;
        this.blood_group = blood_group;
        this.gender = gender;
        this.roll_number = roll_number;
    }

    public int getStudent_id() { return student_id; }
    public void setStudent_id(int student_id) { this.student_id = student_id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getStudent_mobile() { return student_mobile; }
    public void setStudent_mobile(String student_mobile) { this.student_mobile = student_mobile; }

    public String getPermanent_address() { return permanent_address; }
    public void setPermanent_address(String permanent_address) { this.permanent_address = permanent_address; }

    public String getTemporary_address() { return temporary_address; }
    public void setTemporary_address(String temporary_address) { this.temporary_address = temporary_address; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public int getClass_id() { return class_id; }
    public void setClass_id(int class_id) { this.class_id = class_id; }

    public String getFather_name() { return father_name; }
    public void setFather_name(String father_name) { this.father_name = father_name; }

    public String getMother_name() { return mother_name; }
    public void setMother_name(String mother_name) { this.mother_name = mother_name; }

    public String getParents_mobile() { return parents_mobile; }
    public void setParents_mobile(String parents_mobile) { this.parents_mobile = parents_mobile; }

    public String getFather_occupation() { return father_occupation; }
    public void setFather_occupation(String father_occupation) { this.father_occupation = father_occupation; }

    public String getMother_occupation() { return mother_occupation; }
    public void setMother_occupation(String mother_occupation) { this.mother_occupation = mother_occupation; }

    public double getAnnual_income() { return annual_income; }
    public void setAnnual_income(double annual_income) { this.annual_income = annual_income; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getBlood_group() { return blood_group; }
    public void setBlood_group(String blood_group) { this.blood_group = blood_group; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public int getRoll_number() { return roll_number; }
    public void setRoll_number(int roll_number) { this.roll_number = roll_number; }

    public double getFees_paid() { return fees_paid; }
    public void setFees_paid(double fees_paid) { this.fees_paid = fees_paid; }

    public double getFees_remaining() { return fees_remaining; }
    public void setFees_remaining(double fees_remaining) { this.fees_remaining = fees_remaining; }
}