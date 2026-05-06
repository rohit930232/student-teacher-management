<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String errorTitle = (String) request.getAttribute("errorTitle");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String redirectUrl = (String) request.getAttribute("redirectUrl");

    if (errorTitle == null) errorTitle = "Something Went Wrong";
    if (errorMessage == null) errorMessage = "An unexpected error occurred. Please try again.";
    if (redirectUrl == null) redirectUrl = request.getContextPath() + "/student/dashboard";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= errorTitle %></title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/exception.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="exception-page">
    <div class="exception-card">
        <div class="exception-icon">
            <i class="fas fa-triangle-exclamation"></i>
        </div>

        <h2><%= errorTitle %></h2>
        <p><%= errorMessage %></p>

        <div class="exception-actions">
            <a href="<%= redirectUrl %>" class="btn-primary">
                <i class="fas fa-rotate-left"></i> Try Again
            </a>
            <a href="<%=request.getContextPath()%>/student/dashboard" class="btn-secondary">
                <i class="fas fa-home"></i> Dashboard
            </a>
        </div>
    </div>
</div>
</body>
</html>
