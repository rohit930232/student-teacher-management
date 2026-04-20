<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String savedUser = "";
    String savedPass = "";
    String savedRole = "student"; 

    Cookie[] cookies = request.getCookies();

    if(cookies != null){
        for(Cookie c : cookies){
            if(c.getName().equals("username")){
                savedUser = c.getValue();
            }
            if(c.getName().equals("password")){
                savedPass = c.getValue();
            }
            if(c.getName().equals("role")){
                savedRole = c.getValue();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Student Management System</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<div class="container">
    <div class="login-card">
        <img src="<%= request.getContextPath() %>/images/logo.png" class="logo" alt="Logo">
        <h2>Welcome Back!</h2>

        <form action="<%= request.getContextPath() %>/Login" method="post">
            <label>Username</label>
            <input type="text" name="username" placeholder="Enter Your Username" value="<%= savedUser %>" required>

            <label>Password</label>
            <input type="password" name="password" placeholder="Enter Your Password" value="<%= savedPass %>" required>

            <div class="role-select">
                <label>Choose Your Role</label>
                <div class="roles">
                    <input type="radio" name="role" value="student" id="student" <%= savedRole.equals("student") ? "checked" : "" %>>
                    <label for="student" class="role-btn"><span>Student</span></label>

                    <input type="radio" name="role" value="teacher" id="teacher" <%= savedRole.equals("teacher") ? "checked" : "" %>>
                    <label for="teacher" class="role-btn"><span>Teacher</span></label>

                    <input type="radio" name="role" value="admin" id="admin" <%= savedRole.equals("admin") ? "checked" : "" %>>
                    <label for="admin" class="role-btn"><span>Admin</span></label>
                </div>
            </div>

            <a href="#" class="forgot">Forgot Password?</a>
            <button type="submit" class="login-btn">Sign In</button>
        </form>

        <a href="<%= request.getContextPath() %>/jsp/before_register.jsp" class="register-btn">
            <i class="fa-solid fa-user-plus"></i> Create New Account
        </a>

        <div class="divider">
            <span>or continue with</span>
        </div>

        <div class="social-login">
            <a href="#" class="social google" title="Login with Google">
                <i class="fa-brands fa-google"></i>
            </a>
            <a href="#" class="social facebook" title="Login with Facebook">
                <i class="fa-brands fa-facebook-f"></i>
            </a>
            <a href="#" class="social github" title="Login with GitHub">
                <i class="fa-brands fa-github"></i>
            </a>
        </div>
    </div>
</div>

</body>
</html>