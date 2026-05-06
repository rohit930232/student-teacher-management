<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "result");
    request.setAttribute("pageTitle", "Result");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Result</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/result.css">
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
                    <a href="<%=request.getContextPath()%>/teacher/result?class_id=<%= c.get("class_id") %>"
                       class="class-tab <%= isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>
                <% if (!selectedClass.isEmpty()) { %>
                <button class="btn-upload" onclick="openAddModal()"><i class="fas fa-plus"></i> Add Result</button>
                <% } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-chart-bar"></i> Results</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="resultTable">
                        <thead><tr><th>#</th><th>Student</th><th>Subject</th><th>Marks</th><th>Max Marks</th><th>Grade</th><th>Status</th><th>Exam Date</th></tr></thead>
                        <tbody>
                            <%
                                List<Map<String,String>> results = (List<Map<String,String>>) request.getAttribute("results");
                                if (results != null && !results.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> r : results) {
                                        String grade = r.get("grade");
                                        boolean pass = !"F".equals(grade);
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><%= r.get("student_name") %></td>
                                <td><%= r.get("subject") %></td>
                                <td><%= r.get("marks") %></td>
                                <td><%= r.get("max_marks") %></td>
                                <td><span class="grade-badge grade-<%= grade %>"><%= grade %></span></td>
                                <td><span class="<%= pass ? "pass-badge" : "fail-badge" %>"><%= pass ? "Pass" : "Fail" %></span></td>
                                <td><%= r.get("exam_date") != null ? r.get("exam_date").substring(0,10) : "-" %></td>
                            </tr>
                            <% } } else { %><tr><td colspan="8" class="empty-row">No results found</td></tr><% } %>
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

<!-- ADD RESULT MODAL -->
<div id="addModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-plus"></i> Add Result</h3>
            <button onclick="closeAddModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/teacher/result/save" method="post">
                <input type="hidden" name="class_id" value="<%= selectedClass %>">
                <div class="modal-grid">
                    <div class="form-field"><label>Student</label>
                        <select name="student_id" required>
                            <option value="">-- Select Student --</option>
                            <%
                                List<Map<String,String>> students = (List<Map<String,String>>) request.getAttribute("students");
                                if (students != null) { for (Map<String,String> s : students) { %>
                            <option value="<%= s.get("student_id") %>"><%= s.get("name") %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-field"><label>Exam</label>
                        <select name="exam_id" required>
                            <option value="">-- Select Exam --</option>
                            <%
                                List<Map<String,String>> exams = (List<Map<String,String>>) request.getAttribute("exams");
                                if (exams != null) { for (Map<String,String> ex : exams) { %>
                            <option value="<%= ex.get("exam_id") %>"><%= ex.get("subject") %> (<%= ex.get("exam_date") != null ? ex.get("exam_date").substring(0,10) : "" %>)</option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-field"><label>Marks Obtained</label><input type="number" name="marks" id="marksInput" placeholder="e.g. 75" min="0" required onchange="calcGrade()"></div>
                    <div class="form-field"><label>Grade (auto)</label><input type="text" name="grade" id="gradeInput" readonly placeholder="Auto calculated"></div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeAddModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#resultTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
function openAddModal()  { document.getElementById("addModal").style.display = "flex"; }
function closeAddModal() { document.getElementById("addModal").style.display = "none"; }
function calcGrade() {
    let marks = parseInt(document.getElementById("marksInput").value);
    let grade = "";
    if      (isNaN(marks)) grade = "";
    else if (marks < 33)   grade = "F";
    else if (marks < 40)   grade = "D";
    else if (marks < 50)   grade = "C";
    else if (marks < 60)   grade = "B";
    else if (marks < 75)   grade = "A";
    else                   grade = "A+";
    document.getElementById("gradeInput").value = grade;
}
</script>
</body>
</html>