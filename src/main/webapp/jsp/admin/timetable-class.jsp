<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "timetable");
    request.setAttribute("pageTitle", "Timetable");
    String className = (String) request.getAttribute("className");
    String classId   = (String) request.getAttribute("classId");
    String msg       = request.getParameter("msg");
    Map<String,List<Map<String,String>>> timetableByDay = (Map<String,List<Map<String,String>>>) request.getAttribute("timetableByDay");
    List<Map<String,String>> teachers = (List<Map<String,String>>) request.getAttribute("teachers");
    String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/timetable.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("added".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Period added successfully!</div><% } %>
            <% if ("deleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Period deleted!</div><% } %>
            <% if ("error".equals(msg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div><% } %>

            <div class="page-container">
                <div class="class-header">
                    <a href="<%=request.getContextPath()%>/admin/timetable" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-calendar-alt"></i> <%= className != null ? className : "" %> &mdash; Timetable</h2>
                    <button class="add-btn" onclick="openAddModal()"><i class="fas fa-plus"></i> Add Period</button>
                </div>

                <% if (timetableByDay != null && !timetableByDay.isEmpty()) { %>
                <div class="timetable-grid">
                    <% for (String day : days) {
                        List<Map<String,String>> slots = timetableByDay.get(day);
                        if (slots != null && !slots.isEmpty()) { %>
                    <div class="day-card">
                        <div class="day-head"><%= day %></div>
                        <div class="day-body">
                            <% for (Map<String,String> slot : slots) {
                                String slotId = slot.get("timetable_id") != null ? slot.get("timetable_id") : "0";
                            %>
                            <div class="slot">
                                <div class="slot-subject"><i class="fas fa-book"></i> <%= slot.get("subject") != null ? slot.get("subject") : "-" %></div>
                                <div class="slot-teacher"><i class="fas fa-chalkboard-teacher"></i> <%= slot.get("teacher_name") != null ? slot.get("teacher_name") : "No Teacher" %></div>
                                <div class="slot-time"><i class="fas fa-clock"></i> <%= slot.get("start_time") != null ? slot.get("start_time") : "" %> - <%= slot.get("end_time") != null ? slot.get("end_time") : "" %></div>
                                <button class="btn-delete-slot" onclick="deleteSlot('<%= slotId %>')"><i class="fas fa-trash"></i></button>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } } %>
                </div>
                <% } else { %>
                <div class="empty-state"><i class="fas fa-calendar-times"></i><p>No timetable added yet. Click Add Period to start.</p></div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<div id="addModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-plus"></i> Add Period</h3>
            <button onclick="closeAddModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/timetable/add" method="post">
                <input type="hidden" name="class_id" value="<%= classId %>">
                <input type="hidden" name="className" value="<%= className != null ? className : "" %>">
                <div class="form-grid">
                    <div class="form-field">
                        <label>Day <span style="color:red">*</span></label>
                        <select name="day" required>
                            <option value="">-- Select Day --</option>
                            <% for (String d : days) { %>
                            <option value="<%= d %>"><%= d %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Subject <span style="color:red">*</span></label>
                        <input type="text" name="subject" placeholder="e.g. Mathematics" required>
                    </div>
                    <div class="form-field">
                        <label>Teacher</label>
                        <select name="teacher_id">
                            <option value="">-- Select Teacher --</option>
                            <% if (teachers != null) {
                                for (Map<String,String> t : teachers) { %>
                            <option value="<%= t.get("teacher_id") %>"><%= t.get("name") %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Start Time <span style="color:red">*</span></label>
                        <input type="time" name="start_time" required>
                    </div>
                    <div class="form-field">
                        <label>End Time <span style="color:red">*</span></label>
                        <input type="time" name="end_time" required>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeAddModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Add Period</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head">
            <h3><i class="fas fa-trash"></i> Delete Period</h3>
            <button onclick="closeDeleteModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p class="delete-msg">Are you sure you want to delete this period?</p>
            <div class="modal-actions">
                <button onclick="closeDeleteModal()" class="btn-cancel">Cancel</button>
                <a id="deleteSlotBtn" href="#" class="btn-delete"><i class="fas fa-trash"></i> Delete</a>
            </div>
        </div>
    </div>
</div>

<script>
var ctxPath  = '<%=request.getContextPath()%>';
var classId  = '<%=classId%>';
var className = '<%=className != null ? className.replace("'", "\\'") : ""%>';

function openAddModal()    { document.getElementById("addModal").style.display    = "flex"; }
function closeAddModal()   { document.getElementById("addModal").style.display    = "none"; }
function closeDeleteModal(){ document.getElementById("deleteModal").style.display = "none"; }

function deleteSlot(id) {
    document.getElementById("deleteSlotBtn").href =
        ctxPath + '/admin/timetable/delete?id=' + id +
        '&classId=' + classId +
        '&className=' + encodeURIComponent(className);
    document.getElementById("deleteModal").style.display = "flex";
}

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") { closeAddModal(); closeDeleteModal(); }
});
</script>
</body>
</html>