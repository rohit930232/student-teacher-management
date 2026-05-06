<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "attendance");
    request.setAttribute("pageTitle", "Attendance");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
    String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/attendance.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <div class="class-tabs">
                <%
                    List<Map<String,String>> classes = (List<Map<String,String>>) request.getAttribute("classes");
                    if (classes != null) {
                        for (Map<String,String> c : classes) {
                            boolean isActive = c.get("class_id").equals(selectedClass);
                %>
                <a href="<%=request.getContextPath()%>/teacher/attendance?class_id=<%= c.get("class_id") %>"
                   class="class-tab <%= isActive ? "active" : "" %>">
                    <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                </a>
                <% } } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="tabs">
                <button class="tab active" onclick="switchTab('mark')"><i class="fas fa-clipboard-check"></i> Mark Attendance</button>
                <button class="tab" onclick="switchTab('view')"><i class="fas fa-eye"></i> View Attendance</button>
            </div>

            <!-- MARK TAB -->
            <div id="markTab" class="tab-content">
                <div class="page-card">
                    <div class="page-card-head">
                        <h2><i class="fas fa-clipboard-check"></i> Mark Attendance</h2>
                        <input type="date" id="attendanceDate" value="<%= today %>" class="date-input">
                    </div>
                    <form action="<%=request.getContextPath()%>/teacher/attendance/save" method="post">
                        <input type="hidden" name="attendance_date" id="hiddenDate" value="<%= today %>">
                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                        <table class="data-table">
                            <thead><tr><th>#</th><th>Name</th><th>Roll No.</th><th>Present</th><th>Absent</th></tr></thead>
                            <tbody>
                                <%
                                    List<Map<String,String>> students = (List<Map<String,String>>) request.getAttribute("students");
                                    if (students != null && !students.isEmpty()) {
                                        int i = 1;
                                        for (Map<String,String> s : students) {
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td><%= s.get("name") %></td>
                                    <td><%= s.get("roll_number") %></td>
                                    <td><input type="radio" name="status_<%= s.get("student_id") %>" value="Present" checked></td>
                                    <td><input type="radio" name="status_<%= s.get("student_id") %>" value="Absent"></td>
                                    <input type="hidden" name="student_ids" value="<%= s.get("student_id") %>">
                                </tr>
                                <% } } else { %><tr><td colspan="5" class="empty-row">No students in this class</td></tr><% } %>
                            </tbody>
                        </table>
                        <% if (students != null && !students.isEmpty()) { %>
                        <div class="submit-wrap">
                            <button type="submit" class="btn-submit"><i class="fas fa-save"></i> Save Attendance</button>
                        </div>
                        <% } %>
                    </form>
                </div>
            </div>

            <!-- VIEW TAB -->
            <div id="viewTab" class="tab-content" style="display:none;">
                <div class="page-card">
                    <div class="page-card-head">
                        <h2><i class="fas fa-eye"></i> Attendance Report</h2>
                        <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search student..." onkeyup="searchTable()"></div>
                    </div>
                    <div class="table-wrap">
                        <table class="data-table" id="viewTable">
                            <thead><tr><th>#</th><th>Name</th><th>Roll No.</th><th>Total</th><th>Present</th><th>Absent</th><th>Percentage</th><th>Details</th></tr></thead>
                            <tbody>
                                <%
                                    List<Map<String,String>> attReport = (List<Map<String,String>>) request.getAttribute("attendanceReport");
                                    if (attReport != null && !attReport.isEmpty()) {
                                        int i = 1;
                                        for (Map<String,String> r : attReport) {
                                            double pct = 0;
                                            try { pct = Double.parseDouble(r.get("percentage")); } catch(Exception e2) {}
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td><%= r.get("name") %></td>
                                    <td><%= r.get("roll_number") %></td>
                                    <td><%= r.get("total") %></td>
                                    <td><span class="present-badge"><%= r.get("present") %></span></td>
                                    <td><span class="absent-badge"><%= r.get("absent") %></span></td>
                                    <td><span class="pct-badge <%= pct >= 75 ? "pct-good" : pct >= 50 ? "pct-avg" : "pct-low" %>"><%= String.format("%.1f", pct) %>%</span></td>
                                    <td><button class="btn-view" onclick="openAttDetail('<%= r.get("student_id") %>','<%= r.get("name") %>')"><i class="fas fa-eye"></i> Details</button></td>
                                </tr>
                                <% } } else { %><tr><td colspan="8" class="empty-row">No records found</td></tr><% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="select-class-msg"><i class="fas fa-hand-point-up"></i><p>Please select a class</p></div>
            <% } %>
        </div>
    </div>
</div>

<!-- DETAIL MODAL -->
<div id="detailModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-lg">
        <div class="modal-head">
            <h3>Attendance Details — <span id="d_name"></span></h3>
            <button onclick="closeDetailModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <div id="detailContent"></div>
            <div class="modal-actions"><button onclick="closeDetailModal()" class="btn-cancel">Close</button></div>
        </div>
    </div>
</div>

<script>
function switchTab(tab) {
    document.querySelectorAll(".tab").forEach(t => t.classList.remove("active"));
    document.querySelectorAll(".tab-content").forEach(c => c.style.display = "none");
    if (tab === "mark") { document.getElementById("markTab").style.display = "block"; document.querySelectorAll(".tab")[0].classList.add("active"); }
    else { document.getElementById("viewTab").style.display = "block"; document.querySelectorAll(".tab")[1].classList.add("active"); }
}
document.getElementById("attendanceDate") && document.getElementById("attendanceDate").addEventListener("change", function() { document.getElementById("hiddenDate").value = this.value; });
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#viewTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
function openAttDetail(studentId, name) {
    document.getElementById("d_name").innerText = name;
    document.getElementById("detailContent").innerHTML = "<p style='text-align:center;padding:20px;'>Loading...</p>";
    document.getElementById("detailModal").style.display = "flex";
    fetch("<%=request.getContextPath()%>/teacher/attendance/detail?student_id=" + studentId)
        .then(r => r.json())
        .then(data => {
            let html = "<table class='data-table'><thead><tr><th>Date</th><th>Status</th></tr></thead><tbody>";
            if (data.length === 0) html += "<tr><td colspan='2' class='empty-row'>No records</td></tr>";
            else data.forEach(d => { html += "<tr><td>" + d.date + "</td><td><span class='" + (d.status === "Present" ? "present-badge" : "absent-badge") + "'>" + d.status + "</span></td></tr>"; });
            html += "</tbody></table>";
            document.getElementById("detailContent").innerHTML = html;
        });
}
function closeDetailModal() { document.getElementById("detailModal").style.display = "none"; }
</script>
</body>
</html>