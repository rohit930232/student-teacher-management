<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "attendance");
    request.setAttribute("pageTitle", "Attendance");
    int attendancePct = request.getAttribute("attendancePercent") != null ? (Integer) request.getAttribute("attendancePercent") : 0;
    int totalDays     = request.getAttribute("totalDays")         != null ? (Integer) request.getAttribute("totalDays")         : 0;
    int presentDays   = request.getAttribute("presentDays")       != null ? (Integer) request.getAttribute("presentDays")       : 0;
    int absentDays    = request.getAttribute("absentDays")        != null ? (Integer) request.getAttribute("absentDays")        : 0;
    double circumference = 2 * Math.PI * 40;
    double dashOffset    = circumference - (attendancePct / 100.0) * circumference;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/attendance.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="att-summary">
                <div class="att-circle-card">
                    <div class="circle-wrap">
                        <svg width="100" height="100" viewBox="0 0 100 100">
                            <circle class="circle-bg" cx="50" cy="50" r="40"/>
                            <circle class="circle-fill <%= attendancePct >= 75 ? "good" : attendancePct >= 50 ? "avg" : "low" %>" cx="50" cy="50" r="40"
                                stroke-dasharray="<%= String.format("%.2f", circumference) %>"
                                stroke-dashoffset="<%= String.format("%.2f", dashOffset) %>"
                                transform="rotate(-90 50 50)"/>
                        </svg>
                        <div class="circle-text"><%= attendancePct %>%</div>
                    </div>
                    <div class="circle-info">
                        <h3>Overall Attendance</h3>
                        <p class="<%= attendancePct >= 75 ? "good-text" : "low-text" %>"><%= attendancePct >= 75 ? "Good Standing" : "Needs Improvement" %></p>
                    </div>
                </div>
                <div class="att-stat-card total"><i class="fas fa-calendar"></i><div><p>Total Days</p><h3><%= totalDays %></h3></div></div>
                <div class="att-stat-card present"><i class="fas fa-check-circle"></i><div><p>Present</p><h3><%= presentDays %></h3></div></div>
                <div class="att-stat-card absent"><i class="fas fa-times-circle"></i><div><p>Absent</p><h3><%= absentDays %></h3></div></div>
            </div>

            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-calendar-alt"></i> Day Wise Attendance</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search date..." onkeyup="searchTable()"></div>
                </div>
                <table class="data-table" id="attTable">
                    <thead><tr><th>#</th><th>Date</th><th>Day</th><th>Status</th></tr></thead>
                    <tbody>
                        <%
                            List<Map<String,String>> records = (List<Map<String,String>>) request.getAttribute("attendanceRecords");
                            if (records != null && !records.isEmpty()) {
                                int i = 1;
                                for (Map<String,String> r : records) {
                                    boolean isPresent = "Present".equals(r.get("status"));
                        %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><%= r.get("attendance_date") %></td>
                            <td><%= r.get("day_name") != null ? r.get("day_name") : "" %></td>
                            <td><span class="<%= isPresent ? "present-badge" : "absent-badge" %>"><i class="fas fa-<%= isPresent ? "check" : "times" %>"></i> <%= r.get("status") %></span></td>
                        </tr>
                        <% } } else { %><tr><td colspan="4" class="empty-row">No attendance records found</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#attTable tbody tr");
    rows.forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>