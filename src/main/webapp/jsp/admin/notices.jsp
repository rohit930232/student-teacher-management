<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "notices");
    request.setAttribute("pageTitle", "Notices");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notices</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/notices.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("added".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Notice published!</div><% } %>
            <% if ("deleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Notice deleted!</div><% } %>
            <% if ("error".equals(msg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div><% } %>
            <div class="notices-layout">
                <div class="add-notice-card">
                    <div class="card-head"><h3><i class="fas fa-plus-circle"></i> Add New Notice</h3></div>
                    <form action="<%=request.getContextPath()%>/admin/notices/add" method="post">
                        <div class="form-field">
                            <label>Target Class</label>
                            <select name="class_id">
                                <option value="0">All Classes</option>
                                <%
                                    List<Map<String,String>> classList = (List<Map<String,String>>) request.getAttribute("classList");
                                    if (classList != null) {
                                        for (Map<String,String> c : classList) {
                                %>
                                <option value="<%= c.get("class_id") %>"><%= c.get("class_name") %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="form-field">
                            <label>Notice Message</label>
                            <textarea name="message" rows="5" placeholder="Write notice here..." required></textarea>
                        </div>
                        <button type="submit" class="btn-publish"><i class="fas fa-bullhorn"></i> Publish Notice</button>
                    </form>
                </div>
                <div class="notices-list-card">
                    <div class="card-head">
                        <h3><i class="fas fa-list"></i> All Notices</h3>
                        <span class="notice-count-badge">
                            <%
                                List<Map<String,String>> notices = (List<Map<String,String>>) request.getAttribute("notices");
                                out.print(notices != null ? notices.size() : 0);
                            %>
                        </span>
                    </div>
                    <div class="notice-items">
                        <%
                            if (notices != null && !notices.isEmpty()) {
                                for (Map<String,String> n : notices) {
                        %>
                        <div class="notice-item">
                            <div class="notice-item-icon"><i class="fas fa-bullhorn"></i></div>
                            <div class="notice-item-body">
                                <p class="notice-msg"><%= n.get("message") %></p>
                                <div class="notice-meta">
                                    <span class="notice-class-tag"><i class="fas fa-chalkboard"></i> <%= n.get("class_name") != null ? n.get("class_name") : "All Classes" %></span>
                                    <span class="notice-date"><i class="fas fa-calendar"></i> <%= n.get("created_date") != null ? n.get("created_date").toString().substring(0,10) : "" %></span>
                                </div>
                            </div>
                            <button class="btn-delete-notice" onclick="deleteNotice('<%= n.get("notice_id") %>')"><i class="fas fa-trash"></i></button>
                        </div>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-bullhorn"></i><p>No notices yet</p></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head"><h3><i class="fas fa-trash"></i> Delete Notice</h3><button onclick="closeDeleteModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <p class="delete-msg">Are you sure you want to delete this notice?</p>
            <div class="modal-actions">
                <button onclick="closeDeleteModal()" class="btn-cancel">Cancel</button>
                <a id="deleteConfirmBtn" href="#" class="btn-delete"><i class="fas fa-trash"></i> Delete</a>
            </div>
        </div>
    </div>
</div>

<script>
function deleteNotice(id) {
    document.getElementById("deleteConfirmBtn").href = "<%=request.getContextPath()%>/admin/notices/delete?id=" + id;
    document.getElementById("deleteModal").style.display = "flex";
}
function closeDeleteModal() { document.getElementById("deleteModal").style.display = "none"; }
document.addEventListener("keydown", e => { if (e.key === "Escape") closeDeleteModal(); });
</script>
</body>
</html>