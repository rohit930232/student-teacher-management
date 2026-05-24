<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String errorTitle   = (String) request.getAttribute("errorTitle");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String redirectUrl  = (String) request.getAttribute("redirectUrl");
    if (errorTitle   == null) errorTitle   = "Something Went Wrong";
    if (errorMessage == null) errorMessage = "An unexpected error occurred. Please try again.";
    if (redirectUrl  == null) redirectUrl  = request.getContextPath() + "/teacher/dashboard";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= errorTitle %></title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/exception.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="exception-body">
<div class="exception-page">
    <div class="exception-card teacher-theme">
        <div class="exception-icon">
            <i class="fas fa-triangle-exclamation"></i>
        </div>
        <h2><%= errorTitle %></h2>
        <p><%= errorMessage %></p>
        <div class="exception-actions">
            <a href="<%= redirectUrl %>" class="ex-btn ex-btn-primary">
                <i class="fas fa-rotate-left"></i> Try Again
            </a>
            <a href="<%=request.getContextPath()%>/teacher/dashboard" class="ex-btn ex-btn-secondary">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>
    </div>
</div>
</body>
</html>