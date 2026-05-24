<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "assignments");
    request.setAttribute("pageTitle", "Assignments");
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assignments</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/assignments.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <% if ("submitted".equals(successMsg)) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Assignment submitted successfully!</div>
            <% } %>
            <% if ("nofile".equals(errorMsg)) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Please select a file to submit.</div>
            <% } %>
            <% if ("failed".equals(errorMsg)) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Submission failed. Try again.</div>
            <% } %>

            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-tasks"></i> All Assignments</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search..." onkeyup="searchCards()">
                    </div>
                </div>
                <div class="assign-list" id="assignList">
                    <%
                        List<Map<String,String>> assignments = (List<Map<String,String>>) request.getAttribute("assignments");
                        if (assignments != null && !assignments.isEmpty()) {
                            for (Map<String,String> a : assignments) {
                                boolean submitted = "true".equals(a.get("submitted"));
                                String uploadDate = a.get("upload_date") != null && a.get("upload_date").length() >= 10 ? a.get("upload_date").substring(0,10) : "-";
                                String deadline   = a.get("deadline")    != null && !a.get("deadline").isEmpty()        ? a.get("deadline").substring(0,10)    : "-";
                                String subDate    = a.get("submitted_date") != null && !a.get("submitted_date").isEmpty() ? a.get("submitted_date").substring(0,10) : "";
                    %>
                    <div class="assign-card <%= submitted ? "submitted" : "" %>">
                        <div class="assign-card-left">
                            <div class="assign-icon-big <%= submitted ? "submitted-icon" : "" %>">
                                <i class="fas <%= submitted ? "fa-check-circle" : "fa-file-alt" %>"></i>
                            </div>
                        </div>
                        <div class="assign-card-body">
                            <div class="assign-card-top">
                                <h3><%= a.get("title") %></h3>
                                <% if (submitted) { %>
                                <span class="badge-submitted"><i class="fas fa-check"></i> Submitted</span>
                                <% } else { %>
                                <span class="badge-pending"><i class="fas fa-clock"></i> Pending</span>
                                <% } %>
                            </div>
                            <p class="assign-desc"><%= a.get("description") != null && !a.get("description").isEmpty() ? a.get("description") : "No description" %></p>
                            <div class="assign-meta">
                                <span><i class="fas fa-calendar"></i> Uploaded: <%= uploadDate %></span>
                                <% if (!"-".equals(deadline)) { %>
                                <span class="deadline-info"><i class="fas fa-clock"></i> Deadline: <%= deadline %></span>
                                <% } %>
                                <span><i class="fas fa-chalkboard-teacher"></i> <%= a.get("teacher_name") %></span>
                            </div>
                            <% if (submitted && !subDate.isEmpty()) { %>
                            <div class="submitted-info">
                                <i class="fas fa-check-circle"></i>
                                Submitted on: <%= subDate %>
                                <% if (a.get("sub_remarks") != null && !a.get("sub_remarks").isEmpty()) { %>
                                &nbsp;| Remarks: <%= a.get("sub_remarks") %>
                                <% } %>
                                <% if (a.get("submitted_file") != null && !a.get("submitted_file").isEmpty()) { %>
                                &nbsp;|
                                <a href="<%=request.getContextPath()%>/<%= a.get("submitted_file") %>" target="_blank" class="view-submission-link">
                                    <i class="fas fa-eye"></i> View Submission
                                </a>
                                <% } %>
                            </div>
                            <% } %>
                        </div>
                        <div class="assign-card-right">
                            <% if (a.get("file_path") != null && !a.get("file_path").isEmpty()) { %>
                            <a href="<%=request.getContextPath()%>/<%= a.get("file_path") %>" download class="btn-download">
                                <i class="fas fa-download"></i> Download
                            </a>
                            <% } %>
                            <button class="btn-submit-assign" onclick="openSubmitModal('<%= a.get("assignment_id") %>','<%= a.get("title").replace("'","&#39;") %>')">
                                <i class="fas fa-upload"></i> <%= submitted ? "Resubmit" : "Submit" %>
                            </button>
                        </div>
                    </div>
                    <% } } else { %>
                    <div class="empty-state"><i class="fas fa-tasks"></i><p>No assignments yet</p></div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- SUBMIT MODAL -->
<div id="submitModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-upload"></i> Submit Assignment</h3>
            <button onclick="closeSubmitModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p class="submit-assignment-title" id="submitAssignTitle"></p>
            <form action="<%=request.getContextPath()%>/student/assignment/submit" method="post" enctype="multipart/form-data">
                <input type="hidden" name="assignment_id" id="submitAssignId">
                <div class="form-field">
                    <label>Upload File <span style="color:var(--red)">*</span></label>
                    <input type="file" name="submission_file" accept=".pdf,.doc,.docx,.jpg,.jpeg,.png,.zip" required>
                    <small>Accepted: PDF, DOC, DOCX, Images, ZIP</small>
                </div>
                <div class="form-field">
                    <label>Remarks <small>(optional)</small></label>
                    <input type="text" name="remarks" placeholder="Any remarks for teacher...">
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeSubmitModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-upload"></i> Submit</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function searchCards() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll(".assign-card").forEach(card => {
        card.style.display = card.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}
function openSubmitModal(id, title) {
    document.getElementById("submitAssignId").value    = id;
    document.getElementById("submitAssignTitle").innerText = title;
    document.getElementById("submitModal").style.display   = "flex";
}
function closeSubmitModal() {
    document.getElementById("submitModal").style.display = "none";
}
</script>
</body>
</html>