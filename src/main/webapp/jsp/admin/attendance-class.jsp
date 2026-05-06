<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "attendance");
    request.setAttribute("pageTitle", "Attendance");
    String className = (String) request.getAttribute("className");
    String classId   = (String) request.getAttribute("classId");
    String selMonth  = request.getParameter("month");
    if (selMonth == null || selMonth.isEmpty()) {
        selMonth = new java.text.SimpleDateFormat("yyyy-MM").format(new java.util.Date());
    }
    List<Map<String,String>> attList = (List<Map<String,String>>) request.getAttribute("attendanceSummary");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/attendance.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="page-container">
                <div class="class-header">
                    <a href="<%=request.getContextPath()%>/admin/attendance" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-clipboard-check"></i> <%= className != null ? className : "" %> &mdash; Attendance</h2>
                </div>
                <div class="filter-row">
                    <form method="get" action="">
                        <input type="hidden" name="classId" value="<%= classId != null ? classId : "" %>">
                        <input type="hidden" name="className" value="<%= className != null ? className : "" %>">
                        <div class="month-filter">
                            <label><i class="fas fa-calendar"></i> Month:</label>
                            <input type="month" name="month" value="<%= selMonth %>" onchange="this.form.submit()">
                        </div>
                    </form>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="attTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student Name</th>
                                <th>Roll No</th>
                                <th>Present</th>
                                <th>Absent</th>
                                <th>Total Days</th>
                                <th>Percentage</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (attList != null && !attList.isEmpty()) {
                                int idx = 1;
                                for (Map<String,String> a : attList) {
                                    int present = 0;
                                    int total   = 0;
                                    try { present = Integer.parseInt(a.get("present") != null ? a.get("present") : "0"); } catch(Exception ex) { present = 0; }
                                    try { total   = Integer.parseInt(a.get("total")   != null ? a.get("total")   : "0"); } catch(Exception ex) { total = 0; }
                                    int absent = total - present;
                                    int pct    = (total > 0) ? (present * 100 / total) : 0;
                                    String barCls = (pct >= 75) ? "good" : (pct >= 50) ? "avg" : "low";
                                    String sid  = a.get("student_id") != null ? a.get("student_id") : "0";
                                    String sname = a.get("name") != null ? a.get("name").replace("'", "\\'") : "";
                                    String roll  = a.get("roll_number") != null ? a.get("roll_number") : "-";
                        %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= a.get("name") != null ? a.get("name") : "-" %></strong></td>
                                <td><%= roll %></td>
                                <td><span class="present-badge"><%= present %></span></td>
                                <td><span class="absent-badge"><%= absent %></span></td>
                                <td><%= total %></td>
                                <td>
                                    <div class="pct-bar-wrap">
                                        <div class="pct-bar <%= barCls %>" style="width:<%= pct %>%"></div>
                                        <span><%= pct %>%</span>
                                    </div>
                                </td>
                                <td>
                                    <button class="btn-view" onclick="viewDetail('<%= sid %>','<%= sname %>','<%= selMonth %>')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="8" class="empty-row"><i class="fas fa-calendar-times"></i> No attendance records found</td></tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="detailModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-large">
        <div class="modal-head">
            <h3 id="detailModalTitle"><i class="fas fa-calendar-check"></i> Attendance Detail</h3>
            <button onclick="closeDetail()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="detailModalBody">
            <div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
        </div>
    </div>
</div>

<script>
var ctxPath = '<%=request.getContextPath()%>';

function viewDetail(studentId, name, month) {
    document.getElementById("detailModal").style.display = "flex";
    document.getElementById("detailModalTitle").innerHTML = '<i class="fas fa-calendar-check"></i> ' + name + ' &mdash; ' + month;
    document.getElementById("detailModalBody").innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

    fetch(ctxPath + '/admin/attendance/detail?studentId=' + studentId + '&month=' + month)
        .then(function(r) { return r.json(); })
        .then(function(records) {
            if (!records || records.length === 0) {
                document.getElementById("detailModalBody").innerHTML = '<div class="empty-state"><i class="fas fa-calendar-times"></i><p>No records found</p></div>';
                return;
            }
            var rows = '';
            for (var i = 0; i < records.length; i++) {
                var r = records[i];
                var badgeClass = (r.status === 'Present') ? 'present-badge' : 'absent-badge';
                rows += '<tr><td>' + (i+1) + '</td><td>' + r.date + '</td><td>' + r.day + '</td><td><span class="' + badgeClass + '">' + r.status + '</span></td></tr>';
            }
            document.getElementById("detailModalBody").innerHTML =
                '<table class="data-table"><thead><tr><th>#</th><th>Date</th><th>Day</th><th>Status</th></tr></thead><tbody>' + rows + '</tbody></table>';
        })
        .catch(function() {
            document.getElementById("detailModalBody").innerHTML = '<div class="empty-state"><p>Error loading data. Please try again.</p></div>';
        });
}

function closeDetail() {
    document.getElementById("detailModal").style.display = "none";
}

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") closeDetail();
});
</script>
</body>
</html>