<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "exam");
    request.setAttribute("pageTitle", "Exam");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Exam</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/exam.css">
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
                    <a href="<%=request.getContextPath()%>/teacher/exam?class_id=<%= c.get("class_id") %>"
                       class="class-tab <%= isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>
                <% if (!selectedClass.isEmpty()) { %>
                <button class="btn-upload" onclick="openCreateModal()"><i class="fas fa-plus"></i> Create Exam</button>
                <% } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-file-alt"></i> Exam Schedule</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="examTable">
                        <thead><tr><th>#</th><th>Subject</th><th>Date</th><th>Start Time</th><th>End Time</th><th>Total Marks</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                            <%
                                List<Map<String,String>> exams = (List<Map<String,String>>) request.getAttribute("exams");
                                if (exams != null && !exams.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> e : exams) {
                                        boolean upcoming = false;
                                        try { java.sql.Date ed = java.sql.Date.valueOf(e.get("exam_date")); upcoming = !ed.before(new java.util.Date()); } catch(Exception ex2) {}
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><strong><%= e.get("subject") %></strong></td>
                                <td><%= e.get("exam_date") != null ? e.get("exam_date").substring(0,10) : "-" %></td>
                                <td><span class="time-badge"><i class="fas fa-clock"></i> <%= e.get("start_time") %></span></td>
                                <td><span class="time-badge"><i class="fas fa-clock"></i> <%= e.get("end_time") %></span></td>
                                <td><span class="marks-badge"><%= e.get("total_marks") %></span></td>
                                <td><span class="<%= upcoming ? "status-upcoming" : "status-done" %>"><%= upcoming ? "Upcoming" : "Completed" %></span></td>
                                <td>
                                    <form action="<%=request.getContextPath()%>/teacher/exam/delete" method="post" onsubmit="return confirm('Delete?')" style="display:inline">
                                        <input type="hidden" name="exam_id" value="<%= e.get("exam_id") %>">
                                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                                        <button type="submit" class="btn-delete"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                            <% } } else { %><tr><td colspan="8" class="empty-row">No exams scheduled</td></tr><% } %>
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

<!-- CREATE MODAL -->
<div id="createModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-plus-circle"></i> Create Exam</h3>
            <button onclick="closeCreateModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/teacher/exam/create" method="post">
                <input type="hidden" name="class_id" value="<%= selectedClass %>">
                <div class="modal-grid">
                    <div class="form-field full-span"><label>Subject</label><input type="text" name="subject" placeholder="Subject name" required></div>
                    <div class="form-field"><label>Exam Date</label><input type="date" name="exam_date" required></div>
                    <div class="form-field"><label>Total Marks</label><input type="number" name="total_marks" placeholder="e.g. 100" required></div>
                    <div class="form-field"><label>Start Time</label><input type="time" name="start_time" required></div>
                    <div class="form-field"><label>End Time</label><input type="time" name="end_time" required></div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeCreateModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Create</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#examTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
function openCreateModal()  { document.getElementById("createModal").style.display = "flex"; }
function closeCreateModal() { document.getElementById("createModal").style.display = "none"; }
</script>
</body>
</html>