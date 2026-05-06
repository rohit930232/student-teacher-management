<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "notifications");
    request.setAttribute("pageTitle", "Notifications");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/notifications.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("sent".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Notification sent!</div><% } %>
            <% if ("deleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Notification deleted!</div><% } %>
            <% if ("error".equals(msg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div><% } %>
            <div class="notif-layout">
                <div class="send-notif-card">
                    <div class="card-head"><h3><i class="fas fa-paper-plane"></i> Send Notification</h3></div>
                    <form action="<%=request.getContextPath()%>/admin/notifications/send" method="post">
                        <div class="form-field">
                            <label>Message</label>
                            <textarea name="message" rows="5" placeholder="Enter notification message..." required></textarea>
                        </div>
                        <button type="submit" class="btn-send"><i class="fas fa-paper-plane"></i> Send Notification</button>
                    </form>
                </div>
                <div class="notif-list-card">
                    <div class="card-head">
                        <h3><i class="fas fa-bell"></i> All Notifications</h3>
                        <span class="notif-count-badge">
                            <%
                                List<Map<String,String>> notifs = (List<Map<String,String>>) request.getAttribute("notifications");
                                out.print(notifs != null ? notifs.size() : 0);
                            %>
                        </span>
                    </div>
                    <div class="notif-items">
                        <%
                            if (notifs != null && !notifs.isEmpty()) {
                                for (Map<String,String> n : notifs) {
                        %>
                        <div class="notif-item">
                            <div class="notif-dot"></div>
                            <div class="notif-item-body">
                                <p class="notif-msg"><%= n.get("message") %></p>
                                <span class="notif-date"><i class="fas fa-clock"></i> <%= n.get("created_date") != null ? n.get("created_date").toString().substring(0,10) : "" %></span>
                            </div>
                            <button class="btn-delete-notif" onclick="deleteNotif('<%= n.get("notification_id") %>')"><i class="fas fa-trash"></i></button>
                        </div>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-bell-slash"></i><p>No notifications</p></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head"><h3><i class="fas fa-trash"></i> Delete Notification</h3><button onclick="closeDeleteModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <p class="delete-msg">Delete this notification?</p>
            <div class="modal-actions">
                <button onclick="closeDeleteModal()" class="btn-cancel">Cancel</button>
                <a id="deleteConfirmBtn" href="#" class="btn-delete"><i class="fas fa-trash"></i> Delete</a>
            </div>
        </div>
    </div>
</div>

<script>
function deleteNotif(id) {
    document.getElementById("deleteConfirmBtn").href = "<%=request.getContextPath()%>/admin/notifications/delete?id=" + id;
    document.getElementById("deleteModal").style.display = "flex";
}
function closeDeleteModal() { document.getElementById("deleteModal").style.display = "none"; }
document.addEventListener("keydown", e => { if (e.key === "Escape") closeDeleteModal(); });
</script>
</body>
</html>