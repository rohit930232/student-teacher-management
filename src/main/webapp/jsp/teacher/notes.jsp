<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "notices");
    request.setAttribute("pageTitle", "Notices");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notices</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/notices.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <div class="top-actions">
                <div class="class-tabs">
                    <a href="<%=request.getContextPath()%>/teacher/notices"
                       class="class-tab <% if(selectedClass.isEmpty()) out.print("active"); %>">
                        <i class="fas fa-globe"></i> All Classes
                    </a>
                    <%
                        List<Map<String,String>> classes = (List<Map<String,String>>) request.getAttribute("classes");
                        if (classes != null) {
                            for (Map<String,String> c : classes) {
                                boolean isActive = c.get("class_id").equals(selectedClass);
                    %>
                    <a href="<%=request.getContextPath()%>/teacher/notices?class_id=<%= c.get("class_id") %>"
                       class="class-tab <%= isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>
                <button class="btn-upload" onclick="openAddModal()"><i class="fas fa-plus"></i> Add Notice</button>
            </div>

            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-bullhorn"></i> Notices <%= !selectedClass.isEmpty() ? "— Class " + selectedClass : "— All Classes" %></h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search..." onkeyup="searchList()"></div>
                </div>
                <div class="notice-list" id="noticeList">
                    <%
                        List<Map<String,String>> notices = (List<Map<String,String>>) request.getAttribute("notices");
                        if (notices != null && !notices.isEmpty()) {
                            for (Map<String,String> n : notices) {
                    %>
                    <div class="notice-item">
                        <div class="notice-icon"><i class="fas fa-bullhorn"></i></div>
                        <div class="notice-body">
                            <p class="notice-msg"><%= n.get("message") %></p>
                            <span class="notice-date"><i class="fas fa-calendar"></i> <%= n.get("date") != null ? n.get("date").substring(0,10) : "" %></span>
                        </div>
                        <form action="<%=request.getContextPath()%>/teacher/notices/delete" method="post" onsubmit="return confirm('Delete?')">
                            <input type="hidden" name="notice_id" value="<%= n.get("notice_id") %>">
                            <input type="hidden" name="class_id" value="<%= selectedClass %>">
                            <button type="submit" class="btn-delete-sm"><i class="fas fa-trash"></i></button>
                        </form>
                    </div>
                    <% } } else { %><div class="empty-state"><i class="fas fa-bullhorn"></i><p>No notices available</p></div><% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ADD NOTICE MODAL -->
<div id="addModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-plus"></i> Add Notice</h3>
            <button onclick="closeAddModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/teacher/notices/add" method="post">
                <div class="form-field"><label>Select Class <small>(optional — leave blank for all)</small></label>
                    <select name="class_id">
                        <option value="">All Classes</option>
                        <%
                            List<Map<String,String>> cls = (List<Map<String,String>>) request.getAttribute("classes");
                            if (cls != null) { for (Map<String,String> c : cls) { %>
                        <option value="<%= c.get("class_id") %>" <%= c.get("class_id").equals(selectedClass) ? "selected" : "" %>><%= c.get("class_name") %></option>
                        <% } } %>
                    </select>
                </div>
                <div class="form-field"><label>Message</label><textarea name="message" rows="4" placeholder="Enter notice message..." required></textarea></div>
                <div class="modal-actions">
                    <button type="button" onclick="closeAddModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Add Notice</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function searchList() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll(".notice-item").forEach(item => item.style.display = item.innerText.toLowerCase().includes(input) ? "" : "none");
}
function openAddModal()  { document.getElementById("addModal").style.display  = "flex"; }
function closeAddModal() { document.getElementById("addModal").style.display  = "none"; }
</script>
</body>
</html>