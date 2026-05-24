<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "timetable");
    request.setAttribute("pageTitle", "Timetable");
    String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/timetable.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <!-- MODE TABS -->
            <div class="mode-tabs">
                <button class="mode-btn active" id="btnPeriod" onclick="switchMode('period')">
                    <i class="fas fa-clock"></i> Period View
                </button>
                <button class="mode-btn" id="btnGrid" onclick="switchMode('grid')">
                    <i class="fas fa-table"></i> Grid View
                </button>
            </div>

            <!-- PERIOD MODE -->
            <div id="periodMode">
                <div class="page-card">
                    <div class="page-card-head">
                        <h2><i class="fas fa-calendar-alt"></i> Weekly Timetable</h2>
                    </div>
                    <%
                        Map<String,List<Map<String,String>>> timetableByDay = (Map<String,List<Map<String,String>>>) request.getAttribute("timetableByDay");
                    %>
                    <% if (timetableByDay != null && !timetableByDay.isEmpty()) { %>
                    <div class="timetable-grid">
                        <% for (String day : days) {
                            List<Map<String,String>> slots = timetableByDay.get(day);
                            if (slots != null && !slots.isEmpty()) { %>
                        <div class="day-card">
                            <div class="day-head"><%= day %></div>
                            <div class="day-body">
                                <% for (Map<String,String> slot : slots) { %>
                                <div class="slot">
                                    <div class="slot-subject"><i class="fas fa-book"></i> <%= slot.get("subject") %></div>
                                    <div class="slot-time"><i class="fas fa-clock"></i> <%= slot.get("start_time") %> - <%= slot.get("end_time") %></div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                    <% } else { %>
                    <div class="empty-state"><i class="fas fa-calendar-times"></i><p>No timetable found</p></div>
                    <% } %>
                </div>
            </div>

            <!-- GRID MODE -->
            <div id="gridMode" style="display:none;">
                <%
                    List<Map<String,String>> gridList = (List<Map<String,String>>) request.getAttribute("gridList");
                    if (gridList != null && !gridList.isEmpty()) {
                        for (Map<String,String> g : gridList) {
                %>
                <div class="grid-card">
                    <div class="grid-card-head">
                        <h3><i class="fas fa-table"></i> <%= g.get("grid_name") != null ? g.get("grid_name") : "Timetable" %></h3>
                        <span class="grid-date"><i class="fas fa-calendar"></i> <%= g.get("created_date") != null ? g.get("created_date") : "" %></span>
                        <button class="btn-view-grid" onclick="viewGrid('<%= g.get("grid_id") %>')">
                            <i class="fas fa-eye"></i> View
                        </button>
                    </div>
                    <div class="grid-body" id="gridBody_<%= g.get("grid_id") %>" style="display:none; overflow-x:auto; margin-top:14px;"></div>
                </div>
                <% } } else { %>
                <div class="empty-state-full">
                    <i class="fas fa-table"></i>
                    <p>No grid timetables available</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
var ctxPath = '<%=request.getContextPath()%>';

function switchMode(mode) {
    document.getElementById("periodMode").style.display = mode === "period" ? "block" : "none";
    document.getElementById("gridMode").style.display   = mode === "grid"   ? "block" : "none";
    document.getElementById("btnPeriod").classList.toggle("active", mode === "period");
    document.getElementById("btnGrid").classList.toggle("active",   mode === "grid");
}

function viewGrid(gridId) {
    var body = document.getElementById("gridBody_" + gridId);
    if (body.style.display === "none") {
        body.innerHTML = '<p style="color:var(--muted);padding:10px;">Loading...</p>';
        body.style.display = "block";
        fetch(ctxPath + '/student/timetable/grid/get?gridId=' + gridId)
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (!data || !data.length) {
                    body.innerHTML = '<div class="empty-state"><p>No data</p></div>';
                    return;
                }
                var html = '<table class="grid-tt-table">';
                for (var r = 0; r < data.length; r++) {
                    html += '<tr>';
                    for (var c = 0; c < data[r].length; c++) {
                        var cell = data[r][c];
                        var tag  = cell.isHeader ? 'th' : 'td';
                        html += '<' + tag + ' class="grid-cell ' + (cell.isHeader ? 'header-cell' : '') + '">'
                              + (cell.value || '') + '</' + tag + '>';
                    }
                    html += '</tr>';
                }
                html += '</table>';
                body.innerHTML = html;
            })
            .catch(function() { body.innerHTML = '<p style="color:red;padding:10px;">Error loading</p>'; });
    } else {
        body.style.display = "none";
    }
}
</script>
</body>
</html>