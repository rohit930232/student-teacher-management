<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
    request.setAttribute("currentPage", "assignments");
    request.setAttribute("pageTitle", "Assignments");
    String _selClass    = request.getParameter("class_id");
    if (_selClass == null) _selClass = "";
    final String selectedClass = _selClass;
    String _classIdAttr = (String) request.getAttribute("classIdParam");
    if (_classIdAttr == null) _classIdAttr = selectedClass;
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
                        List<Map<String,String>> _classes = (List<Map<String,String>>) request.getAttribute("classes");
                        if (_classes != null) {
                            for (Map<String,String> _c : _classes) {
                                boolean _isActive = _c.get("class_id").equals(selectedClass);
                    %>
                    <a href="<%=request.getContextPath()%>/teacher/assignments?class_id=<%= _c.get("class_id") %>"
                       class="class-tab <%= _isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= _c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>
                <% if (!selectedClass.isEmpty()) { %>
                <button class="btn-upload" onclick="openUploadModal()">
                    <i class="fas fa-upload"></i> Upload Assignment
                </button>
                <% } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-tasks"></i> Assignments</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTable()">
                    </div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="assignTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Upload Date</th>
                                <th>Deadline</th>
                                <th>File</th>
                                <th>Submissions</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> _assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                                if (_assignments != null && !_assignments.isEmpty()) {
                                    int _i = 1;
                                    for (Map<String,String> _a : _assignments) {
                                        String _encTitle = URLEncoder.encode(_a.get("title") != null ? _a.get("title") : "", "UTF-8");
                            %>
                            <tr>
                                <td><%= _i++ %></td>
                                <td><strong><%= _a.get("title") %></strong></td>
                                <td><%= _a.get("description") != null && !_a.get("description").isEmpty() ? _a.get("description") : "-" %></td>
                                <td><%= _a.get("upload_date") != null && _a.get("upload_date").length() >= 10 ? _a.get("upload_date").substring(0,10) : "-" %></td>
                                <td>
                                    <% if (_a.get("deadline") != null && !_a.get("deadline").isEmpty()) { %>
                                    <span class="deadline-badge"><i class="fas fa-clock"></i> <%= _a.get("deadline").substring(0,10) %></span>
                                    <% } else { %><span class="text-muted">-</span><% } %>
                                </td>
                                <td>
                                    <% if (_a.get("file_path") != null && !_a.get("file_path").isEmpty()) { %>
                                    <a href="<%=request.getContextPath()%>/<%= _a.get("file_path") %>" target="_blank" class="btn-view-file">
                                        <i class="fas fa-file"></i> View
                                    </a>
                                    <% } else { %><span class="text-muted">No file</span><% } %>
                                </td>
                                <td>
                                    <a href="<%=request.getContextPath()%>/teacher/assignment/submissions?assignment_id=<%= _a.get("assignment_id") %>&class_id=<%= selectedClass %>&title=<%= _encTitle %>"
                                       class="btn-view-submissions">
                                        <i class="fas fa-users"></i>
                                        <span class="completed-badge"><%= _a.get("completed_count") %></span>
                                        /
                                        <span class="pending-badge"><%= _a.get("total_students") %></span>
                                        View
                                    </a>
                                </td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/teacher/assignments/delete" method="post"
                                          onsubmit="return confirm('Delete?')" style="display:inline">
                                        <input type="hidden" name="assignment_id" value="<%= _a.get("assignment_id") %>">
                                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                                        <button type="submit" class="btn-delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="8" class="empty-row">No assignments yet</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else { %>
            <div class="select-class-msg">
                <i class="fas fa-hand-point-up"></i>
                <p>Please select a class</p>
            </div>
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
                <div class="form-field"><label>Title <span style="color:red">*</span></label><input type="text" name="title" placeholder="Assignment title" required></div>
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
    document.querySelectorAll("#assignTable tbody tr").forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}
function openUploadModal()  { document.getElementById("uploadModal").style.display  = "flex"; }
function closeUploadModal() { document.getElementById("uploadModal").style.display  = "none"; }
</script>
</body>
</html>