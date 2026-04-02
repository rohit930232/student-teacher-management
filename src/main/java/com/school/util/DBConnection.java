package com.school.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	
	private static Connection con;
    public static Connection getConnection() {
        try {
            	String driver="oracle.jdbc.driver.OracleDriver";
            	String url="jdbc:oracle:thin:@localhost:1521:XE";
            	String username="system";
            	String password="tiger";
                Class.forName(driver);
                con = DriverManager.getConnection(url,username,password);
                System.out.println("Database Connected Successfully");   
        } catch (Exception e) {
            System.out.println("Database Connection Error");
            e.printStackTrace();

        }
        return con;
    }
}
