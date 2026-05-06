<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.school.model.admin.Admin" %>
<%
    request.setAttribute("currentPage", "profile");
    request.setAttribute("pageTitle", "My Profile");
    Admin admin     = (Admin) request.getAttribute("admin");
    String _aName   = admin != null ? admin.getFullname()  : "";
    String _aPhoto  = admin != null ? admin.getPhoto()     : null;
    java.text.SimpleDateFormat _sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String dobStr   = (admin != null && admin.getDob() != null) ? _sdf.format(admin.getDob()) : "";
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("1".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Profile updated successfully!</div><% } %>
            <% if ("1".equals(errorMsg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong. Try again.</div><% } %>

            <div class="profile-banner">
                <div class="profile-banner-inner">
                    <div class="profile-photo-wrap">
                        <div class="photo-container" onclick="openPhotoMenu()">
                            <% if (_aPhoto != null && !_aPhoto.trim().isEmpty()) { %>
                                <img src="<%=request.getContextPath()%>/<%= _aPhoto %>" class="profile-big-photo" alt="Profile Photo">
                            <% } else { %>
                                <div class="profile-big-placeholder"><%= (_aName.length() > 0 ? String.valueOf(_aName.charAt(0)).toUpperCase() : "A") %></div>
                            <% } %>
                            <div class="photo-overlay"><i class="fas fa-camera"></i></div>
                        </div>
                        <div class="photo-menu" id="photoMenu" style="display:none;">
                            <% if (_aPhoto != null && !_aPhoto.trim().isEmpty()) { %>
                            <div class="photo-menu-item" onclick="viewPhoto()"><i class="fas fa-eye"></i> View Photo</div>
                            <% } %>
                            <div class="photo-menu-item" onclick="openChangePhoto()"><i class="fas fa-camera"></i> Change Photo</div>
                        </div>
                    </div>
                    <div class="profile-banner-info">
                        <h2><%= _aName %></h2>
                        <p><i class="fas fa-id-badge"></i> <%= admin != null ? admin.getUsername() : "" %></p>
                        <p><i class="fas fa-shield-alt"></i> System Administrator</p>
                    </div>
                </div>
            </div>

            <form id="photoUploadForm" action="<%=request.getContextPath()%>/Admin/Profile" method="post" enctype="multipart/form-data" style="display:none;">
                <input type="hidden" name="action" value="changePhoto">
                <input type="file" name="photo" id="photoFileInput" accept="image/*" onchange="submitPhotoForm()">
            </form>

            <div class="profile-sections">
                <div class="profile-section-card">
                    <div class="section-head">
                        <div><i class="fas fa-user"></i><h3>Personal Information</h3></div>
                        <button class="btn-edit-section" onclick="toggleEdit('personal')"><i class="fas fa-edit"></i> Edit</button>
                    </div>
                    <div class="section-view" id="personalView">
                        <div class="info-grid">
                            <div class="info-item"><span>Full Name</span><p><%= _aName %></p></div>
                            <div class="info-item"><span>Username</span><p><%= admin != null ? admin.getUsername() : "" %></p></div>
                            <div class="info-item"><span>Email</span><p><%= admin != null && admin.getEmail() != null ? admin.getEmail() : "-" %></p></div>
                            <div class="info-item"><span>Mobile</span><p><%= admin != null && admin.getMobile() != null ? admin.getMobile() : "-" %></p></div>
                            <div class="info-item"><span>Gender</span><p><%= admin != null && admin.getGender() != null ? admin.getGender() : "-" %></p></div>
                            <div class="info-item"><span>Date of Birth</span><p><%= dobStr %></p></div>
                            <div class="info-item full-span"><span>Address</span><p><%= admin != null && admin.getAddress() != null ? admin.getAddress() : "-" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="personalEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/Admin/Profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="form-grid">
                                <div class="form-field"><label>Full Name</label><input type="text" name="fullname" value="<%= _aName %>" required></div>
                                <div class="form-field"><label>Email</label><input type="email" name="email" value="<%= admin != null && admin.getEmail() != null ? admin.getEmail() : "" %>"></div>
                                <div class="form-field"><label>Mobile</label><input type="text" name="mobile" value="<%= admin != null && admin.getMobile() != null ? admin.getMobile() : "" %>"></div>
                                <div class="form-field"><label>Gender</label>
                                    <select name="gender">
                                        <option value="Male"   <%= "Male".equals(admin != null ? admin.getGender() : "")   ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= "Female".equals(admin != null ? admin.getGender() : "") ? "selected" : "" %>>Female</option>
                                        <option value="Other"  <%= "Other".equals(admin != null ? admin.getGender() : "")  ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                                <div class="form-field full-span"><label>Address</label><textarea name="address" rows="2"><%= admin != null && admin.getAddress() != null ? admin.getAddress() : "" %></textarea></div>
                            </div>
                            <div class="form-actions">
                                <button type="button" onclick="toggleEdit('personal')" class="btn-cancel">Cancel</button>
                                <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="profile-section-card">
                    <div class="section-head">
                        <div><i class="fas fa-shield-alt"></i><h3>Account Info</h3></div>
                        <span class="read-only-badge">Read Only</span>
                    </div>
                    <div class="section-view">
                        <div class="info-grid">
                            <div class="info-item"><span>Role</span><p>System Administrator</p></div>
                            <div class="info-item"><span>Status</span><p><span class="active-badge">Active</span></p></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="viewPhotoModal" class="photo-modal-overlay" style="display:none;" onclick="closeViewPhoto()">
    <div class="photo-modal-content" onclick="event.stopPropagation()">
        <button class="photo-modal-close" onclick="closeViewPhoto()"><i class="fas fa-times"></i></button>
        <% if (_aPhoto != null && !_aPhoto.trim().isEmpty()) { %>
        <img src="<%=request.getContextPath()%>/<%= _aPhoto %>" class="photo-modal-img" alt="Profile Photo">
        <% } %>
        <div class="photo-modal-name"><%= _aName %></div>
    </div>
</div>

<script>
function openPhotoMenu() {
    let menu = document.getElementById("photoMenu");
    menu.style.display = menu.style.display === "none" ? "block" : "none";
}
document.addEventListener("click", function(e) {
    let menu = document.getElementById("photoMenu");
    let container = document.querySelector(".photo-container");
    if (menu && container && !container.contains(e.target)) menu.style.display = "none";
});
function viewPhoto() {
    document.getElementById("photoMenu").style.display = "none";
    document.getElementById("viewPhotoModal").style.display = "flex";
    document.body.style.overflow = "hidden";
}
function closeViewPhoto() {
    document.getElementById("viewPhotoModal").style.display = "none";
    document.body.style.overflow = "";
}
function openChangePhoto() {
    document.getElementById("photoMenu").style.display = "none";
    document.getElementById("photoFileInput").click();
}
function submitPhotoForm() { document.getElementById("photoUploadForm").submit(); }
function toggleEdit(section) {
    let view = document.getElementById(section + "View");
    let edit = document.getElementById(section + "Edit");
    if (edit.style.display === "none") { view.style.display = "none"; edit.style.display = "block"; }
    else { view.style.display = "block"; edit.style.display = "none"; }
}
document.addEventListener("keydown", function(e) { if (e.key === "Escape") closeViewPhoto(); });
</script>
</body>
</html>