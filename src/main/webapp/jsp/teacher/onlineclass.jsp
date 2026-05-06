<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "onlineclass");
    request.setAttribute("pageTitle", "Online Class");
    String selectedClass = request.getParameter("class_id");
    if (selectedClass == null) selectedClass = "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online Class</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/onlineclass.css">
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
                    <a href="<%=request.getContextPath()%>/teacher/onlineclass?class_id=<%= c.get("class_id") %>"
                       class="class-tab <%= isActive ? "active" : "" %>">
                        <i class="fas fa-chalkboard"></i> <%= c.get("class_name") %>
                    </a>
                    <% } } %>
                </div>
                <% if (!selectedClass.isEmpty()) { %>
                <button class="btn-upload" onclick="openCreateModal()"><i class="fas fa-plus"></i> Create Class</button>
                <% } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>

            <div class="section-title"><i class="fas fa-circle live-dot"></i> Live Now</div>
            <div class="class-grid">
                <%
                    List<Map<String,String>> liveClasses = (List<Map<String,String>>) request.getAttribute("liveClasses");
                    if (liveClasses != null && !liveClasses.isEmpty()) {
                        for (Map<String,String> c : liveClasses) {
                %>
                <div class="class-card live">
                    <div class="class-card-head">
                        <span class="live-badge"><i class="fas fa-circle"></i> LIVE</span>
                        <span class="class-subject"><%= c.get("subject") %></span>
                    </div>
                    <div class="class-info">
                        <p><i class="fas fa-chalkboard-teacher"></i> <%= c.get("teacher_name") %></p>
                        <p><i class="fas fa-clock"></i> Ends at: <%= c.get("end_time") %></p>
                        <p><i class="fas fa-link"></i> <a href="<%= c.get("class_link") %>" target="_blank" class="class-link-a">Join Link</a></p>
                    </div>
                    <form action="<%=request.getContextPath()%>/teacher/onlineclass/delete" method="post" style="display:inline">
                        <input type="hidden" name="class_id_oc" value="<%= c.get("online_class_id") %>">
                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                        <button type="submit" class="btn-delete"><i class="fas fa-trash"></i> End Class</button>
                    </form>
                </div>
                <% } } else { %><div class="empty-card"><i class="fas fa-video-slash"></i><p>No live classes right now</p></div><% } %>
            </div>

            <div class="section-title" style="margin-top:24px;"><i class="fas fa-calendar-alt"></i> Upcoming Classes</div>
            <div class="class-grid">
                <%
                    List<Map<String,String>> upcomingClasses = (List<Map<String,String>>) request.getAttribute("upcomingClasses");
                    if (upcomingClasses != null && !upcomingClasses.isEmpty()) {
                        for (Map<String,String> c : upcomingClasses) {
                %>
                <div class="class-card upcoming">
                    <div class="class-card-head">
                        <span class="upcoming-badge"><i class="fas fa-clock"></i> Upcoming</span>
                        <span class="class-subject"><%= c.get("subject") %></span>
                    </div>
                    <div class="class-info">
                        <p><i class="fas fa-calendar"></i> <%= c.get("start_time") != null && c.get("start_time").length() >= 10 ? c.get("start_time").substring(0,10) : "" %></p>
                        <p><i class="fas fa-clock"></i> Time: <%= c.get("start_time") != null && c.get("start_time").length() > 10 ? c.get("start_time").substring(11,16) : "" %></p>
                        <p><i class="fas fa-link"></i> <%= c.get("class_link") != null ? c.get("class_link") : "-" %></p>
                    </div>
                    <form action="<%=request.getContextPath()%>/teacher/onlineclass/delete" method="post" style="display:inline">
                        <input type="hidden" name="class_id_oc" value="<%= c.get("online_class_id") %>">
                        <input type="hidden" name="class_id" value="<%= selectedClass %>">
                        <button type="submit" class="btn-delete"><i class="fas fa-trash"></i> Delete</button>
                    </form>
                </div>
                <% } } else { %><div class="empty-card"><i class="fas fa-calendar-times"></i><p>No upcoming classes</p></div><% } %>
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
            <h3><i class="fas fa-video"></i> Create Online Class</h3>
            <button onclick="closeCreateModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/teacher/onlineclass/create" method="post">
                <input type="hidden" name="class_id" value="<%= selectedClass %>">
                <div class="form-field"><label>Subject</label><input type="text" name="subject" placeholder="Subject name" required></div>
                <div class="form-field"><label>Class Link (Zoom/Meet)</label><input type="url" name="class_link" placeholder="https://..." required></div>
                <div class="form-field"><label>Start Time</label><input type="datetime-local" name="start_time" required></div>
                <div class="form-field"><label>End Time</label><input type="datetime-local" name="end_time" required></div>
                <div class="form-field"><label>Status</label>
                    <select name="status">
                        <option value="Upcoming">Upcoming</option>
                        <option value="Live">Live Now</option>
                    </select>
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
function openCreateModal()  { document.getElementById("createModal").style.display  = "flex"; }
function closeCreateModal() { document.getElementById("createModal").style.display  = "none"; }
</script>
</body>
</html>