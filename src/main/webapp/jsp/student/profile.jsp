<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.school.model.student.Student" %>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "profile");
    request.setAttribute("pageTitle", "My Profile");
    Student student  = (Student) request.getAttribute("student");
    String className = (String)  request.getAttribute("className");
    String _stName   = student != null ? student.getName()  : "";
    String _stPhoto  = student != null ? student.getPhoto() : null;
    java.text.SimpleDateFormat _sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String dobStr    = (student != null && student.getDob() != null) ? _sdf.format(student.getDob()) : "";
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/profile.css">
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
                            <% if (_stPhoto != null && !_stPhoto.trim().isEmpty()) { %>
                                <img src="<%=request.getContextPath()%>/<%= _stPhoto %>" class="profile-big-photo" alt="Profile Photo">
                            <% } else { %>
                                <div class="profile-big-placeholder"><%= (_stName.length() > 0 ? String.valueOf(_stName.charAt(0)).toUpperCase() : "S") %></div>
                            <% } %>
                            <div class="photo-overlay"><i class="fas fa-camera"></i></div>
                        </div>
                        <div class="photo-menu" id="photoMenu" style="display:none;">
                            <% if (_stPhoto != null && !_stPhoto.trim().isEmpty()) { %>
                            <div class="photo-menu-item" onclick="viewPhoto()"><i class="fas fa-eye"></i> View Photo</div>
                            <% } %>
                            <div class="photo-menu-item" onclick="openChangePhoto()"><i class="fas fa-camera"></i> Change Photo</div>
                        </div>
                    </div>
                    <div class="profile-banner-info">
                        <h2><%= _stName %></h2>
                        <p><i class="fas fa-id-badge"></i> <%= student != null ? student.getUsername() : "" %></p>
                        <p><i class="fas fa-chalkboard"></i> <%= className != null ? className : "Not Assigned" %></p>
                        <p><i class="fas fa-list-ol"></i> Roll No: <%= student != null ? student.getRoll_number() : "" %></p>
                    </div>
                </div>
            </div>

            <form id="photoUploadForm" action="<%=request.getContextPath()%>/student/profile/update" method="post" enctype="multipart/form-data" style="display:none;">
                <input type="hidden" name="section" value="photo">
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
                            <div class="info-item"><span>Full Name</span><p><%= _stName %></p></div>
                            <div class="info-item"><span>Username</span><p><%= student != null ? student.getUsername() : "" %></p></div>
                            <div class="info-item"><span>Date of Birth</span><p><%= dobStr %></p></div>
                            <div class="info-item"><span>Gender</span><p><%= student != null && student.getGender() != null ? student.getGender() : "-" %></p></div>
                            <div class="info-item"><span>Blood Group</span><p><%= student != null && student.getBlood_group() != null ? student.getBlood_group() : "-" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="personalEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/student/profile/update" method="post">
                            <input type="hidden" name="section" value="personal">
                            <div class="form-grid">
                                <div class="form-field"><label>Full Name</label><input type="text" name="name" value="<%= _stName %>" required></div>
                                <div class="form-field"><label>Username <small>(unique)</small></label><input type="text" name="username" id="usernameInput" value="<%= student != null ? student.getUsername() : "" %>" required><span id="usernameMsg" class="field-msg"></span></div>
                                <div class="form-field"><label>Date of Birth</label><input type="date" name="dob" value="<%= dobStr %>"></div>
                                <div class="form-field"><label>Gender</label>
                                    <select name="gender">
                                        <option value="Male"   <%= "Male".equals(student != null ? student.getGender() : "")   ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= "Female".equals(student != null ? student.getGender() : "") ? "selected" : "" %>>Female</option>
                                        <option value="Other"  <%= "Other".equals(student != null ? student.getGender() : "")  ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                                <div class="form-field"><label>Blood Group</label>
                                    <select name="blood_group">
                                        <option value="">-- Select --</option>
                                        <% String[] bgs = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                                           String curBg = student != null && student.getBlood_group() != null ? student.getBlood_group() : "";
                                           for (String bg : bgs) { %>
                                        <option value="<%= bg %>" <%= bg.equals(curBg) ? "selected" : "" %>><%= bg %></option>
                                        <% } %>
                                    </select>
                                </div>
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
                        <div><i class="fas fa-envelope"></i><h3>Contact Information</h3></div>
                        <button class="btn-edit-section" onclick="toggleEdit('contact')"><i class="fas fa-edit"></i> Edit</button>
                    </div>
                    <div class="section-view" id="contactView">
                        <div class="info-grid">
                            <div class="info-item"><span>Email</span><p><%= student != null && student.getEmail() != null ? student.getEmail() : "-" %></p></div>
                            <div class="info-item"><span>Mobile</span><p><%= student != null && student.getStudent_mobile() != null ? student.getStudent_mobile() : "-" %></p></div>
                            <div class="info-item full-span"><span>Temporary Address</span><p><%= student != null && student.getTemporary_address() != null ? student.getTemporary_address() : "-" %></p></div>
                            <div class="info-item full-span"><span>Permanent Address</span><p><%= student != null && student.getPermanent_address() != null ? student.getPermanent_address() : "-" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="contactEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/student/profile/update" method="post">
                            <input type="hidden" name="section" value="contact">
                            <div class="form-grid">
                                <div class="form-field"><label>Email</label><input type="email" name="email" value="<%= student != null && student.getEmail() != null ? student.getEmail() : "" %>"></div>
                                <div class="form-field"><label>Mobile</label><input type="text" name="student_mobile" value="<%= student != null && student.getStudent_mobile() != null ? student.getStudent_mobile() : "" %>"></div>
                                <div class="form-field full-span"><label>Temporary Address</label><textarea name="temporary_address" rows="2"><%= student != null && student.getTemporary_address() != null ? student.getTemporary_address() : "" %></textarea></div>
                                <div class="form-field full-span"><label>Permanent Address</label><textarea name="permanent_address" rows="2"><%= student != null && student.getPermanent_address() != null ? student.getPermanent_address() : "" %></textarea></div>
                            </div>
                            <div class="form-actions">
                                <button type="button" onclick="toggleEdit('contact')" class="btn-cancel">Cancel</button>
                                <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="profile-section-card">
                    <div class="section-head">
                        <div><i class="fas fa-users"></i><h3>Family Information</h3></div>
                        <button class="btn-edit-section" onclick="toggleEdit('family')"><i class="fas fa-edit"></i> Edit</button>
                    </div>
                    <div class="section-view" id="familyView">
                        <div class="info-grid">
                            <div class="info-item"><span>Father Name</span><p><%= student != null && student.getFather_name() != null ? student.getFather_name() : "-" %></p></div>
                            <div class="info-item"><span>Mother Name</span><p><%= student != null && student.getMother_name() != null ? student.getMother_name() : "-" %></p></div>
                            <div class="info-item"><span>Parents Mobile</span><p><%= student != null && student.getParents_mobile() != null ? student.getParents_mobile() : "-" %></p></div>
                            <div class="info-item"><span>Father Occupation</span><p><%= student != null && student.getFather_occupation() != null ? student.getFather_occupation() : "-" %></p></div>
                            <div class="info-item"><span>Mother Occupation</span><p><%= student != null && student.getMother_occupation() != null ? student.getMother_occupation() : "-" %></p></div>
                            <div class="info-item"><span>Annual Income</span><p>&#8377;<%= student != null ? student.getAnnual_income() : "0" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="familyEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/student/profile/update" method="post">
                            <input type="hidden" name="section" value="family">
                            <div class="form-grid">
                                <div class="form-field"><label>Father Name</label><input type="text" name="father_name" value="<%= student != null && student.getFather_name() != null ? student.getFather_name() : "" %>"></div>
                                <div class="form-field"><label>Mother Name</label><input type="text" name="mother_name" value="<%= student != null && student.getMother_name() != null ? student.getMother_name() : "" %>"></div>
                                <div class="form-field"><label>Parents Mobile</label><input type="text" name="parents_mobile" value="<%= student != null && student.getParents_mobile() != null ? student.getParents_mobile() : "" %>"></div>
                                <div class="form-field"><label>Father Occupation</label><input type="text" name="father_occupation" value="<%= student != null && student.getFather_occupation() != null ? student.getFather_occupation() : "" %>"></div>
                                <div class="form-field"><label>Mother Occupation</label><input type="text" name="mother_occupation" value="<%= student != null && student.getMother_occupation() != null ? student.getMother_occupation() : "" %>"></div>
                                <div class="form-field"><label>Annual Income</label><input type="number" name="annual_income" value="<%= student != null ? student.getAnnual_income() : "" %>"></div>
                            </div>
                            <div class="form-actions">
                                <button type="button" onclick="toggleEdit('family')" class="btn-cancel">Cancel</button>
                                <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="profile-section-card">
                    <div class="section-head">
                        <div><i class="fas fa-graduation-cap"></i><h3>Academic Information</h3></div>
                        <span class="read-only-badge">Read Only</span>
                    </div>
                    <div class="section-view">
                        <div class="info-grid">
                            <div class="info-item"><span>Student ID</span><p><%= student != null ? student.getStudent_id() : "-" %></p></div>
                            <div class="info-item"><span>Roll Number</span><p><%= student != null ? student.getRoll_number() : "-" %></p></div>
                            <div class="info-item"><span>Class</span><p><%= className != null ? className : "Not Assigned" %></p></div>
                            <div class="info-item"><span>Fees Paid</span><p class="fees-paid">&#8377;<%= student != null ? student.getFees_paid() : "0" %></p></div>
                            <div class="info-item"><span>Fees Remaining</span><p class="fees-due">&#8377;<%= student != null ? student.getFees_remaining() : "0" %></p></div>
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
        <% if (_stPhoto != null && !_stPhoto.trim().isEmpty()) { %>
        <img src="<%=request.getContextPath()%>/<%= _stPhoto %>" class="photo-modal-img" alt="Profile Photo">
        <% } %>
        <div class="photo-modal-name"><%= _stName %></div>
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
let originalUsername = document.getElementById("usernameInput") ? document.getElementById("usernameInput").value : "";
if (document.getElementById("usernameInput")) {
    document.getElementById("usernameInput").addEventListener("blur", function() {
        let val = this.value.trim();
        let msg = document.getElementById("usernameMsg");
        if (val === originalUsername) { msg.innerText = ""; return; }
        fetch("<%=request.getContextPath()%>/student/profile/checkUsername?username=" + val)
            .then(r => r.text())
            .then(data => {
                if (data.trim() === "taken") { msg.innerText = "Username already taken!"; msg.className = "field-msg error"; }
                else { msg.innerText = "Username available!"; msg.className = "field-msg success"; }
            });
    });
}
document.addEventListener("keydown", function(e) { if (e.key === "Escape") closeViewPhoto(); });
</script>
</body>
</html>