<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String _tName  = (String) session.getAttribute("fullname");
    String _tPhoto = (String) session.getAttribute("photo");
    String _pTitle = (String) request.getAttribute("pageTitle");
    String _tInit  = (_tName != null && _tName.length() > 0) ? String.valueOf(_tName.charAt(0)).toUpperCase() : "A";
    if (_pTitle == null) _pTitle = "Dashboard";
%>
<header class="topbar">
    <div class="topbar-left">
        <h1><%= _pTitle %></h1>
        <p><%= new java.text.SimpleDateFormat("EEEE, dd MMM yyyy").format(new java.util.Date()) %></p>
    </div>
    <div class="topbar-right">
        <a href="<%=request.getContextPath()%>/admin/notifications" class="icon-btn" title="Notifications">
            <i class="fas fa-bell"></i>
        </a>
        <a href="<%=request.getContextPath()%>/admin/profile" class="topbar-profile-link">
            <% if (_tPhoto != null && !_tPhoto.trim().isEmpty()) { %>
                <img src="<%=request.getContextPath()%>/<%= _tPhoto %>" class="topbar-avatar" alt="Photo">
            <% } else { %>
                <div class="topbar-avatar-placeholder"><%= _tInit %></div>
            <% } %>
            <div class="topbar-info">
                <span><%= _tName %></span>
                <small>Admin</small>
            </div>
        </a>
    </div>
</header>