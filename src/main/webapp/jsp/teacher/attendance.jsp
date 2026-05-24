<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "attendance");
    request.setAttribute("pageTitle", "Attendance");
    String _selClass     = request.getParameter("class_id");
    if (_selClass == null) _selClass = "";
    final String selectedClass = _selClass;
    String _selMonth     = (String) request.getAttribute("selectedMonth");
    int    _myPresent    = request.getAttribute("myPresent")  != null ? (Integer) request.getAttribute("myPresent")  : 0;
    int    _myAbsent     = request.getAttribute("myAbsent")   != null ? (Integer) request.getAttribute("myAbsent")   : 0;
    int    _myTotal      = request.getAttribute("myTotal")    != null ? (Integer) request.getAttribute("myTotal")    : 0;
    int    _myPct        = request.getAttribute("myPct")      != null ? (Integer) request.getAttribute("myPct")      : 0;
    int    _yearPresent  = request.getAttribute("yearPresent") != null ? (Integer) request.getAttribute("yearPresent") : 0;
    int    _yearAbsent   = request.getAttribute("yearAbsent")  != null ? (Integer) request.getAttribute("yearAbsent")  : 0;
    int    _yearTotal    = request.getAttribute("yearTotal")   != null ? (Integer) request.getAttribute("yearTotal")   : 0;
    int    _yearPct      = request.getAttribute("yearPct")     != null ? (Integer) request.getAttribute("yearPct")     : 0;
    int    _currentYear  = request.getAttribute("currentYear") != null ? (Integer) request.getAttribute("currentYear") : java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
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

            <!-- MAIN TABS -->
            <div class="main-tabs">
                <button class="main-tab-btn active" id="btnMyAtt" onclick="switchMainTab('my')">
                    <i class="fas fa-user"></i> My Attendance
                </button>
                <button class="main-tab-btn" id="btnStudentAtt" onclick="switchMainTab('student')">
                    <i class="fas fa-user-graduate"></i> Student Attendance
                </button>
            </div>

            <!-- ===== MY ATTENDANCE TAB ===== -->
            <div id="myAttTab">

                <!-- Year Summary -->
                <div class="year-summary-card">
                    <div class="year-summary-head">
                        <h3><i class="fas fa-calendar-alt"></i> Year <%= _currentYear %> — Overall Summary</h3>
                        <span class="year-badge">Current Year</span>
                    </div>
                    <div class="year-stats">
                        <div class="year-stat present-stat">
                            <i class="fas fa-check-circle"></i>
                            <div><p>Present</p><h3><%= _yearPresent %></h3></div>
                        </div>
                        <div class="year-stat absent-stat">
                            <i class="fas fa-times-circle"></i>
                            <div><p>Absent</p><h3><%= _yearAbsent %></h3></div>
                        </div>
                        <div class="year-stat total-stat">
                            <i class="fas fa-calendar"></i>
                            <div><p>Total Days</p><h3><%= _yearTotal %></h3></div>
                        </div>
                        <div class="year-stat pct-stat">
                            <i class="fas fa-percent"></i>
                            <div>
                                <p>Attendance %</p>
                                <h3 class="<%= _yearPct >= 75 ? "good-text" : _yearPct >= 50 ? "avg-text" : "low-text" %>">
                                    <%= _yearPct %>%
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Month Filter -->
                <div class="month-filter-card">
                    <form action="<%=request.getContextPath()%>/teacher/attendance" method="get"
                          class="month-form">
                        <% if (!selectedClass.isEmpty()) { %>
                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                        <% } %>
                        <label><i class="fas fa-calendar-week"></i> Select Month:</label>
                        <input type="month" name="month" value="<%= _selMonth %>"
                               max="<%= new java.text.SimpleDateFormat("yyyy-MM").format(new java.util.Date()) %>">
                        <button type="submit" class="btn-filter">
                            <i class="fas fa-search"></i> View
                        </button>
                    </form>
                </div>

                <!-- Month Summary -->
                <div class="month-summary">
                    <div class="month-stat-card green">
                        <div class="month-stat-icon"><i class="fas fa-check-circle"></i></div>
                        <div><p>Present (<%= _selMonth %>)</p><h3><%= _myPresent %></h3></div>
                    </div>
                    <div class="month-stat-card red">
                        <div class="month-stat-icon"><i class="fas fa-times-circle"></i></div>
                        <div><p>Absent (<%= _selMonth %>)</p><h3><%= _myAbsent %></h3></div>
                    </div>
                    <div class="month-stat-card blue">
                        <div class="month-stat-icon"><i class="fas fa-calendar"></i></div>
                        <div><p>Total Days</p><h3><%= _myTotal %></h3></div>
                    </div>
                    <div class="month-stat-card <%= _myPct >= 75 ? "green" : _myPct >= 50 ? "orange" : "red" %>">
                        <div class="month-stat-icon"><i class="fas fa-percent"></i></div>
                        <div><p>Percentage</p><h3><%= _myPct %>%</h3></div>
                    </div>
                </div>

                <!-- Day-wise Table -->
                <div class="page-card">
                    <div class="page-card-head">
                        <h2><i class="fas fa-calendar-check"></i> Day-wise Attendance — <%= _selMonth %></h2>
                    </div>
                    <div class="table-wrap">
                        <table class="data-table">
                            <thead>
                                <tr><th>#</th><th>Date</th><th>Day</th><th>Status</th></tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Map<String,String>> _myRecords = (List<Map<String,String>>) request.getAttribute("myAttRecords");
                                    if (_myRecords != null && !_myRecords.isEmpty()) {
                                        int _i = 1;
                                        for (Map<String,String> _r : _myRecords) {
                                            boolean _isPresent = "Present".equals(_r.get("status"));
                                %>
                                <tr>
                                    <td><%= _i++ %></td>
                                    <td><%= _r.get("date") %></td>
                                    <td><%= _r.get("day") %></td>
                                    <td>
                                        <span class="<%= _isPresent ? "present-badge" : "absent-badge" %>">
                                            <i class="fas fa-<%= _isPresent ? "check" : "times" %>"></i>
                                            <%= _r.get("status") %>
                                        </span>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="4" class="empty-row">
                                        <i class="fas fa-calendar-times"></i>
                                        No attendance records for <%= _selMonth %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- ===== STUDENT ATTENDANCE TAB ===== -->
            <div id="studentAttTab" style="display:none;">

                <div class="class-tabs">
                    <%
                        List<Map<String,String>> _classes = (List<Map<String,String>>) request.getAttribute("classes");
                        if (_classes != null) {
                            for (Map<String,String> _c : _classes) {
                                boolean _isActive = _c.get("class_id").equals(selectedClass);
                    %>
                    <a href="<%=request.getContextPath()%>/teacher/attendance?class_id=<%= _c.get("class_id") %>&month=<%= _selMonth %>"
                       class="class-tab <%= _isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= _c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>

                <% if (!selectedClass.isEmpty()) { %>

                <div class="tabs">
                    <button class="tab active" onclick="switchTab('mark')">
                        <i class="fas fa-clipboard-check"></i> Mark Attendance
                    </button>
                    <button class="tab" onclick="switchTab('view')">
                        <i class="fas fa-eye"></i> View Attendance
                    </button>
                </div>

                <!-- MARK TAB -->
                <div id="markTab" class="tab-content">
                    <div class="page-card">
                        <div class="page-card-head">
                            <h2><i class="fas fa-clipboard-check"></i> Mark Attendance</h2>
                            <input type="date" id="attendanceDate" value="<%= today %>"
                                   class="date-input">
                        </div>
                        <form action="<%=request.getContextPath()%>/teacher/attendance/save" method="post">
                            <input type="hidden" name="attendance_date" id="hiddenDate" value="<%= today %>">
                            <input type="hidden" name="class_id" value="<%= selectedClass %>">
                            <table class="data-table">
                                <thead>
                                    <tr><th>#</th><th>Name</th><th>Roll No.</th><th>Present</th><th>Absent</th></tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Map<String,String>> _students = (List<Map<String,String>>) request.getAttribute("students");
                                        if (_students != null && !_students.isEmpty()) {
                                            int _i = 1;
                                            for (Map<String,String> _s : _students) {
                                    %>
                                    <tr>
                                        <td><%= _i++ %></td>
                                        <td><%= _s.get("name") %></td>
                                        <td><%= _s.get("roll_number") %></td>
                                        <td><input type="radio" name="status_<%= _s.get("student_id") %>" value="Present" checked></td>
                                        <td><input type="radio" name="status_<%= _s.get("student_id") %>" value="Absent"></td>
                                        <input type="hidden" name="student_ids" value="<%= _s.get("student_id") %>">
                                    </tr>
                                    <% } } else { %>
                                    <tr><td colspan="5" class="empty-row">No students in this class</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <% if (_students != null && !_students.isEmpty()) { %>
                            <div class="submit-wrap">
                                <button type="submit" class="btn-submit">
                                    <i class="fas fa-save"></i> Save Attendance
                                </button>
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
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="searchInput" placeholder="Search student..." onkeyup="searchTable()">
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="data-table" id="viewTable">
                                <thead>
                                    <tr><th>#</th><th>Name</th><th>Roll No.</th><th>Total</th><th>Present</th><th>Absent</th><th>Percentage</th><th>Details</th></tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<Map<String,String>> _report = (List<Map<String,String>>) request.getAttribute("attendanceReport");
                                        if (_report != null && !_report.isEmpty()) {
                                            int _i = 1;
                                            for (Map<String,String> _r : _report) {
                                                double _pct = 0;
                                                try { _pct = Double.parseDouble(_r.get("percentage")); } catch(Exception _e2) {}
                                    %>
                                    <tr>
                                        <td><%= _i++ %></td>
                                        <td><%= _r.get("name") %></td>
                                        <td><%= _r.get("roll_number") %></td>
                                        <td><%= _r.get("total") %></td>
                                        <td><span class="present-badge"><%= _r.get("present") %></span></td>
                                        <td><span class="absent-badge"><%= _r.get("absent") %></span></td>
                                        <td>
                                            <span class="pct-badge <%= _pct >= 75 ? "pct-good" : _pct >= 50 ? "pct-avg" : "pct-low" %>">
                                                <%= String.format("%.1f", _pct) %>%
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn-view" onclick="openAttDetail('<%= _r.get("student_id") %>','<%= _r.get("name") %>')">
                                                <i class="fas fa-eye"></i> Details
                                            </button>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                    <tr><td colspan="8" class="empty-row">No records found</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
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
            <div class="modal-actions">
                <button onclick="closeDetailModal()" class="btn-cancel">Close</button>
            </div>
        </div>
    </div>
</div>

<script>
function switchMainTab(tab) {
    document.getElementById("myAttTab").style.display      = tab === "my"      ? "block" : "none";
    document.getElementById("studentAttTab").style.display = tab === "student"  ? "block" : "none";
    document.getElementById("btnMyAtt").classList.toggle("active",     tab === "my");
    document.getElementById("btnStudentAtt").classList.toggle("active", tab === "student");
}

function switchTab(tab) {
    var mark = document.getElementById("markTab");
    var view = document.getElementById("viewTab");
    if (!mark || !view) return;
    mark.style.display = tab === "mark" ? "block" : "none";
    view.style.display = tab === "view" ? "block" : "none";
    document.querySelectorAll(".tab").forEach(function(t, i) {
        t.classList.toggle("active", (i === 0 && tab === "mark") || (i === 1 && tab === "view"));
    });
}

document.getElementById("attendanceDate") &&
    document.getElementById("attendanceDate").addEventListener("change", function() {
        document.getElementById("hiddenDate").value = this.value;
    });

function searchTable() {
    var input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#viewTable tbody tr").forEach(function(row) {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}

function openAttDetail(studentId, name) {
    document.getElementById("d_name").innerText     = name;
    document.getElementById("detailContent").innerHTML =
        '<p style="text-align:center;padding:20px;">Loading...</p>';
    document.getElementById("detailModal").style.display = "flex";
    fetch("<%=request.getContextPath()%>/teacher/attendance/detail?student_id=" + studentId)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            var html = "<table class='data-table'><thead><tr><th>Date</th><th>Status</th></tr></thead><tbody>";
            if (data.length === 0)
                html += "<tr><td colspan='2' class='empty-row'>No records</td></tr>";
            else
                data.forEach(function(d) {
                    html += "<tr><td>" + d.date + "</td><td><span class='" +
                        (d.status === "Present" ? "present-badge" : "absent-badge") +
                        "'>" + d.status + "</span></td></tr>";
                });
            html += "</tbody></table>";
            document.getElementById("detailContent").innerHTML = html;
        });
}

function closeDetailModal() {
    document.getElementById("detailModal").style.display = "none";
}

// URL pe class_id hai toh student tab show karo
var urlParams = new URLSearchParams(window.location.search);
if (urlParams.get("class_id")) {
    switchMainTab("student");
}
</script>
</body>
</html>