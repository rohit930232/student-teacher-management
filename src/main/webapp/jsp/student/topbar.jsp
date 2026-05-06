<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String _sName   = (String) session.getAttribute("fullname");
    String _sPhoto  = (String) session.getAttribute("photo");
    String _pTitle  = (String) request.getAttribute("pageTitle");
    String _sInit   = (_sName != null && _sName.length() > 0) ? String.valueOf(_sName.charAt(0)).toUpperCase() : "S";
    if (_pTitle == null) _pTitle = "Dashboard";
%>
<header class="topbar">
    <div class="topbar-left">
        <h1><%= _pTitle %></h1>
        <p><%= new java.text.SimpleDateFormat("EEEE, dd MMM yyyy").format(new java.util.Date()) %></p>
    </div>
    <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/student/notifications" class="icon-btn" title="Notifications">
            <i class="fas fa-bell"></i>
        </a>
        <a href="<%=request.getContextPath()%>/student/profile" class="topbar-profile-link">
            <% if (_sPhoto != null && !_sPhoto.trim().isEmpty()) { %>
                <img src="<%=request.getContextPath()%>/<%= _sPhoto %>" class="topbar-avatar" alt="Photo">
            <% } else { %>
                <div class="topbar-avatar-placeholder"><%= _sInit %></div>
            <% } %>
            <div class="topbar-info">
                <span><%= _sName %></span>
                <small>Student</small>
            </div>
        </a>
    </div>
</header>