<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "attendance");
    request.setAttribute("pageTitle", "Attendance");
    List<Map<String,String>> classList   = (List<Map<String,String>>) request.getAttribute("classList");
    List<Map<String,String>> teacherList = (List<Map<String,String>>) request.getAttribute("teacherList");
    List<Map<String,String>> staffList   = (List<Map<String,String>>) request.getAttribute("staffList");
    String msg = request.getParameter("msg");
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

            <% if ("marked".equals(msg)) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Attendance marked!</div>
            <% } %>
            <% if ("error".equals(msg)) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div>
            <% } %>

            <div class="page-container">
                <h2 class="page-title"><i class="fas fa-clipboard-check"></i> Attendance Management</h2>

                <div class="att-tabs">
                    <button class="att-tab-btn active" id="tabBtn_students" onclick="switchAttTab('students')">
                        <i class="fas fa-user-graduate"></i> Students
                    </button>
                    <button class="att-tab-btn" id="tabBtn_teachers" onclick="switchAttTab('teachers')">
                        <i class="fas fa-chalkboard-teacher"></i> Teachers
                    </button>
                    <button class="att-tab-btn" id="tabBtn_staff" onclick="switchAttTab('staff')">
                        <i class="fas fa-users"></i> Staff
                    </button>
                </div>

                <%-- ===== STUDENTS TAB ===== --%>
                <div id="tab_students">
                    <p class="att-section-label"><i class="fas fa-chalkboard"></i> Select a class to view student attendance</p>
                    <div class="class-grid">
                        <%
                            if (classList != null && !classList.isEmpty()) {
                                for (Map<String,String> c : classList) {
                        %>
                        <a href="<%=request.getContextPath()%>/admin/attendance/class?classId=<%= c.get("class_id") %>&className=<%= java.net.URLEncoder.encode(c.get("class_name") != null ? c.get("class_name") : "", "UTF-8") %>" class="class-card">
                            <div class="class-card-icon"><i class="fas fa-chalkboard"></i></div>
                            <div class="class-card-info">
                                <h3><%= c.get("class_name") != null ? c.get("class_name") : "-" %></h3>
                                <p><i class="fas fa-users"></i> <%= c.get("total") != null ? c.get("total") : "0" %> Students</p>
                            </div>
                            <i class="fas fa-chevron-right arrow"></i>
                        </a>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-school"></i><p>No classes found</p></div>
                        <% } %>
                    </div>
                </div>

                <%-- ===== TEACHERS TAB ===== --%>
                <div id="tab_teachers" style="display:none;">

                    <div class="att-card">
                        <div class="att-card-head">
                            <h3><i class="fas fa-calendar-check"></i> Mark Teacher Attendance</h3>
                            <div class="att-head-right">
                                <div class="att-date-group">
                                    <label>Date:</label>
                                    <input type="date" id="teacherAttDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                </div>
                                <button class="btn-save" onclick="markTeacherAtt()">
                                    <i class="fas fa-save"></i> Save Attendance
                                </button>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="data-table" id="teacherAttTable">
                                <thead>
                                    <tr>
                                        <th style="width:50px">#</th>
                                        <th style="width:60px">Photo</th>
                                        <th>Name</th>
                                        <th>Subject</th>
                                        <th style="width:120px">Present</th>
                                        <th style="width:120px">Absent</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    if (teacherList != null && !teacherList.isEmpty()) {
                                        int ti = 1;
                                        for (Map<String,String> t : teacherList) {
                                            String tid    = t.get("teacher_id") != null ? t.get("teacher_id") : "0";
                                            String tname  = t.get("name")       != null ? t.get("name")       : "-";
                                            String tsubj  = t.get("subject")    != null ? t.get("subject")    : "-";
                                            String tphoto = t.get("photo")      != null ? t.get("photo")      : "";
                                            String tinit  = tname.length() > 0 ? String.valueOf(tname.charAt(0)).toUpperCase() : "T";
                                %>
                                <tr>
                                    <td><%= ti++ %></td>
                                    <td>
                                        <% if (!tphoto.isEmpty()) { %>
                                        <img src="<%=request.getContextPath()%>/<%= tphoto %>"
                                             class="att-photo"
                                             alt="<%= tname %>"
                                             onerror="this.outerHTML='<div class=\'photo-placeholder att-photo-ph\'><%= tinit %></div>'">
                                        <% } else { %>
                                        <div class="photo-placeholder att-photo-ph"><%= tinit %></div>
                                        <% } %>
                                    </td>
                                    <td><strong><%= tname %></strong><br><small style="color:#94a3b8"><%= t.get("username") != null ? t.get("username") : "" %></small></td>
                                    <td><span class="subject-badge"><%= tsubj %></span></td>
                                    <td>
                                        <label class="att-radio-label present-label">
                                            <input type="radio" name="tatt_<%= tid %>" value="Present" checked>
                                            <span class="att-radio-text"><i class="fas fa-check"></i> Present</span>
                                        </label>
                                    </td>
                                    <td>
                                        <label class="att-radio-label absent-label">
                                            <input type="radio" name="tatt_<%= tid %>" value="Absent">
                                            <span class="att-radio-text"><i class="fas fa-times"></i> Absent</span>
                                        </label>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="6" class="empty-row"><i class="fas fa-user-slash"></i> No teachers found</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="att-card" style="margin-top:20px;">
                        <div class="att-card-head">
                            <h3><i class="fas fa-chart-bar"></i> View Teacher Attendance</h3>
                        </div>
                        <div class="att-filter-row">
                            <div class="att-filter-item">
                                <label>Select Teacher</label>
                                <select id="selTeacher">
                                    <option value="">-- Select Teacher --</option>
                                    <% if (teacherList != null) { for (Map<String,String> t : teacherList) { %>
                                    <option value="<%= t.get("teacher_id") %>"><%= t.get("name") %></option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="att-filter-item">
                                <label>Month</label>
                                <input type="month" id="selTeacherMonth" value="<%= new java.text.SimpleDateFormat("yyyy-MM").format(new java.util.Date()) %>">
                            </div>
                            <div class="att-filter-item" style="justify-content:flex-end;">
                                <label>&nbsp;</label>
                                <button class="btn-save" onclick="viewTeacherAtt()"><i class="fas fa-search"></i> View</button>
                            </div>
                        </div>
                        <div id="teacherAttResult"></div>
                    </div>
                </div>

                <%-- ===== STAFF TAB ===== --%>
                <div id="tab_staff" style="display:none;">

                    <div class="att-card">
                        <div class="att-card-head">
                            <h3><i class="fas fa-calendar-check"></i> Mark Staff Attendance</h3>
                            <div class="att-head-right">
                                <div class="att-date-group">
                                    <label>Date:</label>
                                    <input type="date" id="staffAttDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                                </div>
                                <button class="btn-save" onclick="markStaffAtt()">
                                    <i class="fas fa-save"></i> Save Attendance
                                </button>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="data-table" id="staffAttTable">
                                <thead>
                                    <tr>
                                        <th style="width:50px">#</th>
                                        <th style="width:60px">Photo</th>
                                        <th>Name</th>
                                        <th>Role</th>
                                        <th style="width:120px">Present</th>
                                        <th style="width:120px">Absent</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    if (staffList != null && !staffList.isEmpty()) {
                                        int si = 1;
                                        for (Map<String,String> s : staffList) {
                                            String sid    = s.get("staff_id") != null ? s.get("staff_id") : "0";
                                            String sname  = s.get("name")     != null ? s.get("name")     : "-";
                                            String srole  = s.get("role")     != null ? s.get("role")     : "-";
                                            String sphoto = s.get("photo")    != null ? s.get("photo")    : "";
                                            String sinit  = sname.length() > 0 ? String.valueOf(sname.charAt(0)).toUpperCase() : "S";
                                %>
                                <tr>
                                    <td><%= si++ %></td>
                                    <td>
                                        <% if (!sphoto.isEmpty()) { %>
                                        <img src="<%=request.getContextPath()%>/<%= sphoto %>"
                                             class="att-photo"
                                             alt="<%= sname %>"
                                             onerror="this.outerHTML='<div class=\'photo-placeholder att-photo-ph\'><%= sinit %></div>'">
                                        <% } else { %>
                                        <div class="photo-placeholder att-photo-ph"><%= sinit %></div>
                                        <% } %>
                                    </td>
                                    <td><strong><%= sname %></strong></td>
                                    <td><span class="role-badge"><%= srole %></span></td>
                                    <td>
                                        <label class="att-radio-label present-label">
                                            <input type="radio" name="satt_<%= sid %>" value="Present" checked>
                                            <span class="att-radio-text"><i class="fas fa-check"></i> Present</span>
                                        </label>
                                    </td>
                                    <td>
                                        <label class="att-radio-label absent-label">
                                            <input type="radio" name="satt_<%= sid %>" value="Absent">
                                            <span class="att-radio-text"><i class="fas fa-times"></i> Absent</span>
                                        </label>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="6" class="empty-row"><i class="fas fa-users-slash"></i> No staff found</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="att-card" style="margin-top:20px;">
                        <div class="att-card-head">
                            <h3><i class="fas fa-chart-bar"></i> View Staff Attendance</h3>
                        </div>
                        <div class="att-filter-row">
                            <div class="att-filter-item">
                                <label>Select Staff</label>
                                <select id="selStaff">
                                    <option value="">-- Select Staff --</option>
                                    <% if (staffList != null) { for (Map<String,String> s : staffList) { %>
                                    <option value="<%= s.get("staff_id") %>"><%= s.get("name") %></option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="att-filter-item">
                                <label>Month</label>
                                <input type="month" id="selStaffMonth" value="<%= new java.text.SimpleDateFormat("yyyy-MM").format(new java.util.Date()) %>">
                            </div>
                            <div class="att-filter-item" style="justify-content:flex-end;">
                                <label>&nbsp;</label>
                                <button class="btn-save" onclick="viewStaffAtt()"><i class="fas fa-search"></i> View</button>
                            </div>
                        </div>
                        <div id="staffAttResult"></div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<div id="toastContainer" style="position:fixed;top:20px;right:20px;z-index:9999;display:flex;flex-direction:column;gap:10px;"></div>

<script>
var ctxPath = '<%=request.getContextPath()%>';

function switchAttTab(tab) {
    ['students','teachers','staff'].forEach(function(t) {
        document.getElementById('tab_' + t).style.display = (t === tab) ? 'block' : 'none';
        document.getElementById('tabBtn_' + t).classList.toggle('active', t === tab);
    });
}

function markTeacherAtt() {
    var date = document.getElementById("teacherAttDate").value;
    if (!date) { showToast("Please select a date!", "error"); return; }

    var attData = [];
    document.querySelectorAll("#teacherAttTable tbody tr").forEach(function(row) {
        var radios = row.querySelectorAll("input[type='radio']");
        if (radios.length > 0) {
            var tid = radios[0].name.replace("tatt_", "");
            var status = "Present";
            radios.forEach(function(r) { if (r.checked) status = r.value; });
            attData.push({ id: tid, status: status });
        }
    });

    if (attData.length === 0) { showToast("No teachers to mark!", "error"); return; }

    fetch(ctxPath + '/admin/attendance/teacher/mark', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ date: date, records: attData })
    })
    .then(function(r) { return r.text(); })
    .then(function(res) {
        showToast(res === "ok" ? "Teacher attendance saved successfully!" : "Something went wrong!", res === "ok" ? "success" : "error");
    })
    .catch(function() { showToast("Network error!", "error"); });
}

function markStaffAtt() {
    var date = document.getElementById("staffAttDate").value;
    if (!date) { showToast("Please select a date!", "error"); return; }

    var attData = [];
    document.querySelectorAll("#staffAttTable tbody tr").forEach(function(row) {
        var radios = row.querySelectorAll("input[type='radio']");
        if (radios.length > 0) {
            var sid = radios[0].name.replace("satt_", "");
            var status = "Present";
            radios.forEach(function(r) { if (r.checked) status = r.value; });
            attData.push({ id: sid, status: status });
        }
    });

    if (attData.length === 0) { showToast("No staff to mark!", "error"); return; }

    fetch(ctxPath + '/admin/attendance/staff/mark', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ date: date, records: attData })
    })
    .then(function(r) { return r.text(); })
    .then(function(res) {
        showToast(res === "ok" ? "Staff attendance saved successfully!" : "Something went wrong!", res === "ok" ? "success" : "error");
    })
    .catch(function() { showToast("Network error!", "error"); });
}

function viewTeacherAtt() {
    var tid   = document.getElementById("selTeacher").value;
    var month = document.getElementById("selTeacherMonth").value;
    if (!tid)   { showToast("Please select a teacher!", "error"); return; }
    if (!month) { showToast("Please select a month!",   "error"); return; }

    document.getElementById("teacherAttResult").innerHTML =
        '<div class="loading" style="padding:30px;text-align:center;"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

    fetch(ctxPath + '/admin/attendance/teacher/view?id=' + tid + '&month=' + month)
        .then(function(r) { return r.json(); })
        .then(function(data) { renderAttResult(data, "teacherAttResult", month); })
        .catch(function() {
            document.getElementById("teacherAttResult").innerHTML =
                '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>Error loading data</p></div>';
        });
}

function viewStaffAtt() {
    var sid   = document.getElementById("selStaff").value;
    var month = document.getElementById("selStaffMonth").value;
    if (!sid)   { showToast("Please select a staff member!", "error"); return; }
    if (!month) { showToast("Please select a month!",        "error"); return; }

    document.getElementById("staffAttResult").innerHTML =
        '<div class="loading" style="padding:30px;text-align:center;"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

    fetch(ctxPath + '/admin/attendance/staff/view?id=' + sid + '&month=' + month)
        .then(function(r) { return r.json(); })
        .then(function(data) { renderAttResult(data, "staffAttResult", month); })
        .catch(function() {
            document.getElementById("staffAttResult").innerHTML =
                '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>Error loading data</p></div>';
        });
}

function renderAttResult(data, containerId, month) {
    if (!data || !data.records || data.records.length === 0) {
        document.getElementById(containerId).innerHTML =
            '<div class="empty-state" style="padding:30px;"><i class="fas fa-calendar-times"></i><p>No records found for ' + month + '</p></div>';
        return;
    }

    var s   = data.summary || { present:0, absent:0, total:0 };
    var pct = s.total > 0 ? Math.round((s.present / s.total) * 100) : 0;
    var pctCls = pct >= 75 ? "good" : pct >= 50 ? "avg" : "low";

    var html =
        '<div class="att-summary-row">' +
            '<div class="att-sum-box present-box"><div class="att-sum-icon"><i class="fas fa-check-circle"></i></div><div><p>Present</p><h3>' + s.present + '</h3></div></div>' +
            '<div class="att-sum-box absent-box"><div class="att-sum-icon"><i class="fas fa-times-circle"></i></div><div><p>Absent</p><h3>' + s.absent + '</h3></div></div>' +
            '<div class="att-sum-box total-box"><div class="att-sum-icon"><i class="fas fa-calendar"></i></div><div><p>Total Days</p><h3>' + s.total + '</h3></div></div>' +
            '<div class="att-sum-box pct-box"><div class="att-sum-icon"><i class="fas fa-percent"></i></div><div><p>Percentage</p><h3 class="' + pctCls + '-text">' + pct + '%</h3></div></div>' +
        '</div>' +
        '<div class="table-wrap" style="margin-top:18px;">' +
        '<table class="data-table"><thead><tr><th>#</th><th>Date</th><th>Day</th><th>Status</th></tr></thead><tbody>';

    data.records.forEach(function(r, i) {
        var bc = r.status === 'Present' ? 'present-badge' : 'absent-badge';
        html += '<tr><td>' + (i+1) + '</td><td>' + r.date + '</td><td>' + r.day + '</td>' +
                '<td><span class="' + bc + '">' + r.status + '</span></td></tr>';
    });

    html += '</tbody></table></div>';
    document.getElementById(containerId).innerHTML = html;
}

function showToast(msg, type) {
    var div = document.createElement('div');
    div.className = 'alert ' + (type === 'success' ? 'alert-success' : 'alert-error');
    div.style.cssText = 'min-width:260px;box-shadow:0 4px 14px rgba(0,0,0,0.15);animation:slideInRight 0.3s ease;';
    div.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check' : 'exclamation') + '-circle"></i> ' + msg;
    document.getElementById('toastContainer').appendChild(div);
    setTimeout(function() { div.remove(); }, 3500);
}
</script>
</body>
</html>