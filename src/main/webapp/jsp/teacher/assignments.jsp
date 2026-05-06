<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "assignments");
    request.setAttribute("pageTitle", "Assignments");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignments</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/assignments.css">
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
                    <%
                        List<Map<String,String>> classes = (List<Map<String,String>>) request.getAttribute("classes");
                        if (classes != null) {
                            for (Map<String,String> c : classes) {
                                boolean isActive = c.get("class_id").equals(selectedClass);
                    %>
                    <a href="<%=request.getContextPath()%>/teacher/assignments?class_id=<%= c.get("class_id") %>"
                       class="class-tab <%= isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>
                <% if (!selectedClass.isEmpty()) { %>
                <button class="btn-upload" onclick="openUploadModal()"><i class="fas fa-upload"></i> Upload Assignment</button>
                <% } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-tasks"></i> Assignments</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="assignTable">
                        <thead>
                            <tr><th>#</th><th>Title</th><th>Description</th><th>Upload Date</th><th>Deadline</th><th>File</th><th>Completed</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                                if (assignments != null && !assignments.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> a : assignments) {
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><strong><%= a.get("title") %></strong></td>
                                <td><%= a.get("description") != null ? a.get("description") : "-" %></td>
                                <td><%= a.get("upload_date") != null ? a.get("upload_date").substring(0,10) : "-" %></td>
                                <td>
                                    <% if (a.get("deadline") != null && !a.get("deadline").isEmpty()) { %>
                                    <span class="deadline-badge"><i class="fas fa-clock"></i> <%= a.get("deadline").substring(0,10) %></span>
                                    <% } else { %><span class="text-muted">-</span><% } %>
                                </td>
                                <td>
                                    <% if (a.get("file_path") != null && !a.get("file_path").isEmpty()) { %>
                                    <a href="<%=request.getContextPath()%>/<%= a.get("file_path") %>" target="_blank" class="btn-file"><i class="fas fa-file"></i> View</a>
                                    <% } else { %><span class="text-muted">No file</span><% } %>
                                </td>
                                <td><span class="completed-badge"><%= a.get("completed_count") != null ? a.get("completed_count") : "0" %> students</span></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/teacher/assignments/delete" method="post" onsubmit="return confirm('Delete?')" style="display:inline">
                                        <input type="hidden" name="assignment_id" value="<%= a.get("assignment_id") %>">
                                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                                        <button type="submit" class="btn-delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                            <% } } else { %><tr><td colspan="8" class="empty-row">No assignments yet</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else { %>
            <div class="select-class-msg"><i class="fas fa-hand-point-up"></i><p>Please select a class</p></div>
            <% } %>
        </div>
    </div>
</div>

<!-- UPLOAD MODAL -->
<div id="uploadModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-upload"></i> Upload Assignment</h3>
            <button onclick="closeUploadModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/teacher/assignments/upload" method="post" enctype="multipart/form-data">
                <input type="hidden" name="class_id" value="<%= selectedClass %>">
                <div class="form-field"><label>Title</label><input type="text" name="title" placeholder="Assignment title" required></div>
                <div class="form-field"><label>Description</label><textarea name="description" rows="3" placeholder="Assignment description"></textarea></div>
                <div class="form-field"><label>Deadline</label><input type="date" name="deadline"></div>
                <div class="form-field"><label>File (optional)</label><input type="file" name="file"></div>
                <div class="modal-actions">
                    <button type="button" onclick="closeUploadModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-upload"></i> Upload</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#assignTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
function openUploadModal()  { document.getElementById("uploadModal").style.display  = "flex"; }
function closeUploadModal() { document.getElementById("uploadModal").style.display  = "none"; }
</script>
</body>
</html>