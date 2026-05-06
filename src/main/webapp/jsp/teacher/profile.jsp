<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.school.model.teacher.Teacher" %>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "profile");
    request.setAttribute("pageTitle", "My Profile");
    Teacher teacher  = (Teacher) request.getAttribute("teacher");
    String className = (String)  request.getAttribute("className");
    String _tName    = teacher != null ? teacher.getName()  : "";
    String _tPhoto   = teacher != null ? teacher.getPhoto() : null;
    java.text.SimpleDateFormat _sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String dobStr     = (teacher != null && teacher.getDob()          != null) ? _sdf.format(teacher.getDob())          : "";
    String joinStr    = (teacher != null && teacher.getJoining_date() != null) ? _sdf.format(teacher.getJoining_date()) : "";
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("1".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Profile updated successfully!</div><% } %>
            <% if ("1".equals(errorMsg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong.</div><% } %>

            <!-- PROFILE BANNER -->
            <div class="profile-banner">
                <div class="profile-banner-inner">
                    <div class="profile-photo-wrap">
                        <div class="photo-container" onclick="openPhotoMenu()">
                            <% if (_tPhoto != null && !_tPhoto.trim().isEmpty()) { %>
                                <img src="<%=request.getContextPath()%>/<%= _tPhoto %>" class="profile-big-photo" alt="Photo">
                            <% } else { %>
                                <div class="profile-big-placeholder"><%= (_tName.length() > 0 ? String.valueOf(_tName.charAt(0)).toUpperCase() : "T") %></div>
                            <% } %>
                            <div class="photo-overlay"><i class="fas fa-camera"></i></div>
                        </div>
                        <div class="photo-menu" id="photoMenu" style="display:none;">
                            <% if (_tPhoto != null && !_tPhoto.trim().isEmpty()) { %>
                            <div class="photo-menu-item" onclick="viewPhoto()"><i class="fas fa-eye"></i> View Photo</div>
                            <% } %>
                            <div class="photo-menu-item" onclick="openChangePhoto()"><i class="fas fa-camera"></i> Change Photo</div>
                        </div>
                    </div>
                    <div class="profile-banner-info">
                        <h2><%= _tName %></h2>
                        <p><i class="fas fa-id-badge"></i> <%= teacher != null ? teacher.getUsername() : "" %></p>
                        <p><i class="fas fa-chalkboard"></i> <%= className != null ? className : "Not Assigned" %></p>
                        <p><i class="fas fa-book"></i> <%= teacher != null && teacher.getSubject() != null ? teacher.getSubject() : "-" %></p>
                        <% if (teacher != null && "yes".equalsIgnoreCase(teacher.getClass_teacher())) { %><span class="badge-teacher">&#127775; Class Teacher</span><% } %>
                    </div>
                </div>
            </div>

            <form id="photoUploadForm" action="<%=request.getContextPath()%>/teacher/profile/update" method="post" enctype="multipart/form-data" style="display:none;">
                <input type="hidden" name="section" value="photo">
                <input type="file" name="photo" id="photoFileInput" accept="image/*" onchange="submitPhotoForm()">
            </form>

            <div class="profile-sections">

                <!-- PERSONAL -->
                <div class="profile-section-card">
                    <div class="section-head"><div><i class="fas fa-user"></i><h3>Personal Information</h3></div><button class="btn-edit-section" onclick="toggleEdit('personal')"><i class="fas fa-edit"></i> Edit</button></div>
                    <div class="section-view" id="personalView">
                        <div class="info-grid">
                            <div class="info-item"><span>Full Name</span><p><%= _tName %></p></div>
                            <div class="info-item"><span>Username</span><p><%= teacher != null ? teacher.getUsername() : "" %></p></div>
                            <div class="info-item"><span>Date of Birth</span><p><%= dobStr %></p></div>
                            <div class="info-item"><span>Age</span><p><%= teacher != null ? teacher.getAge() : "-" %></p></div>
                            <div class="info-item"><span>Gender</span><p><%= teacher != null && teacher.getGender() != null ? teacher.getGender() : "-" %></p></div>
                            <div class="info-item"><span>Mobile</span><p><%= teacher != null && teacher.getMobile() != null ? teacher.getMobile() : "-" %></p></div>
                            <div class="info-item"><span>Email</span><p><%= teacher != null && teacher.getEmail() != null ? teacher.getEmail() : "-" %></p></div>
                            <div class="info-item"><span>Qualification</span><p><%= teacher != null && teacher.getQualification() != null ? teacher.getQualification() : "-" %></p></div>
                            <div class="info-item"><span>Experience</span><p><%= teacher != null ? teacher.getExperience() + " years" : "-" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="personalEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/teacher/profile/update" method="post">
                            <input type="hidden" name="section" value="personal">
                            <div class="form-grid">
                                <div class="form-field"><label>Full Name</label><input type="text" name="name" value="<%= _tName %>" required></div>
                                <div class="form-field"><label>Username <small>(unique)</small></label><input type="text" name="username" id="usernameInput" value="<%= teacher != null ? teacher.getUsername() : "" %>" required><span id="usernameMsg" class="field-msg"></span></div>
                                <div class="form-field"><label>Date of Birth</label><input type="date" name="dob" id="dobInput" value="<%= dobStr %>" onchange="calcAge()"></div>
                                <div class="form-field"><label>Age (auto)</label><input type="number" name="age" id="ageInput" value="<%= teacher != null ? teacher.getAge() : "" %>" readonly></div>
                                <div class="form-field"><label>Gender</label>
                                    <select name="gender">
                                        <option value="Male"   <%= "Male".equals(teacher != null ? teacher.getGender() : "")   ? "selected" : "" %>>Male</option>
                                        <option value="Female" <%= "Female".equals(teacher != null ? teacher.getGender() : "") ? "selected" : "" %>>Female</option>
                                        <option value="Other"  <%= "Other".equals(teacher != null ? teacher.getGender() : "")  ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                                <div class="form-field"><label>Mobile</label><input type="text" name="mobile" value="<%= teacher != null && teacher.getMobile() != null ? teacher.getMobile() : "" %>"></div>
                                <div class="form-field"><label>Email</label><input type="email" name="email" value="<%= teacher != null && teacher.getEmail() != null ? teacher.getEmail() : "" %>"></div>
                                <div class="form-field"><label>Qualification</label><input type="text" name="qualification" value="<%= teacher != null && teacher.getQualification() != null ? teacher.getQualification() : "" %>"></div>
                                <div class="form-field"><label>Experience (years)</label><input type="number" name="experience" value="<%= teacher != null ? teacher.getExperience() : "" %>"></div>
                            </div>
                            <div class="form-actions">
                                <button type="button" onclick="toggleEdit('personal')" class="btn-cancel">Cancel</button>
                                <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ADDRESS -->
                <div class="profile-section-card">
                    <div class="section-head"><div><i class="fas fa-map-marker-alt"></i><h3>Address</h3></div><button class="btn-edit-section" onclick="toggleEdit('address')"><i class="fas fa-edit"></i> Edit</button></div>
                    <div class="section-view" id="addressView">
                        <div class="info-grid">
                            <div class="info-item full-span"><span>Current Address</span><p><%= teacher != null && teacher.getAddress() != null ? teacher.getAddress() : "-" %></p></div>
                            <div class="info-item full-span"><span>Permanent Address</span><p><%= teacher != null && teacher.getPermanent_address() != null ? teacher.getPermanent_address() : "-" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="addressEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/teacher/profile/update" method="post">
                            <input type="hidden" name="section" value="address">
                            <div class="form-grid">
                                <div class="form-field full-span"><label>Current Address</label><textarea name="address" rows="2"><%= teacher != null && teacher.getAddress() != null ? teacher.getAddress() : "" %></textarea></div>
                                <div class="form-field full-span"><label>Permanent Address</label><textarea name="permanent_address" rows="2"><%= teacher != null && teacher.getPermanent_address() != null ? teacher.getPermanent_address() : "" %></textarea></div>
                            </div>
                            <div class="form-actions">
                                <button type="button" onclick="toggleEdit('address')" class="btn-cancel">Cancel</button>
                                <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- BANK DETAILS -->
                <div class="profile-section-card">
                    <div class="section-head"><div><i class="fas fa-university"></i><h3>Bank Details</h3></div><button class="btn-edit-section" onclick="toggleEdit('bank')"><i class="fas fa-edit"></i> Edit</button></div>
                    <div class="section-view" id="bankView">
                        <div class="info-grid">
                            <div class="info-item"><span>Account Holder</span><p><%= teacher != null && teacher.getAccount_holder() != null ? teacher.getAccount_holder() : "-" %></p></div>
                            <div class="info-item"><span>Account Number</span><p><%= teacher != null && teacher.getAccount_number() != null ? teacher.getAccount_number() : "-" %></p></div>
                            <div class="info-item"><span>Bank Name</span><p><%= teacher != null && teacher.getBank_name() != null ? teacher.getBank_name() : "-" %></p></div>
                            <div class="info-item"><span>IFSC Code</span><p><%= teacher != null && teacher.getIfsc_code() != null ? teacher.getIfsc_code() : "-" %></p></div>
                            <div class="info-item"><span>Branch</span><p><%= teacher != null && teacher.getBranch() != null ? teacher.getBranch() : "-" %></p></div>
                            <div class="info-item"><span>PAN Number</span><p><%= teacher != null && teacher.getPan_number() != null ? teacher.getPan_number() : "-" %></p></div>
                            <div class="info-item"><span>UPI ID</span><p><%= teacher != null && teacher.getUpi_id() != null ? teacher.getUpi_id() : "-" %></p></div>
                        </div>
                    </div>
                    <div class="section-edit" id="bankEdit" style="display:none;">
                        <form action="<%=request.getContextPath()%>/teacher/profile/update" method="post">
                            <input type="hidden" name="section" value="bank">
                            <div class="form-grid">
                                <div class="form-field"><label>Account Holder</label><input type="text" name="account_holder" value="<%= teacher != null && teacher.getAccount_holder() != null ? teacher.getAccount_holder() : "" %>"></div>
                                <div class="form-field"><label>Account Number</label><input type="text" name="account_number" value="<%= teacher != null && teacher.getAccount_number() != null ? teacher.getAccount_number() : "" %>"></div>
                                <div class="form-field"><label>Bank Name</label><input type="text" name="bank_name" value="<%= teacher != null && teacher.getBank_name() != null ? teacher.getBank_name() : "" %>"></div>
                                <div class="form-field"><label>IFSC Code</label><input type="text" name="ifsc_code" value="<%= teacher != null && teacher.getIfsc_code() != null ? teacher.getIfsc_code() : "" %>"></div>
                                <div class="form-field"><label>Branch</label><input type="text" name="branch" value="<%= teacher != null && teacher.getBranch() != null ? teacher.getBranch() : "" %>"></div>
                                <div class="form-field"><label>PAN Number</label><input type="text" name="pan_number" value="<%= teacher != null && teacher.getPan_number() != null ? teacher.getPan_number() : "" %>"></div>
                                <div class="form-field"><label>UPI ID</label><input type="text" name="upi_id" value="<%= teacher != null && teacher.getUpi_id() != null ? teacher.getUpi_id() : "" %>"></div>
                            </div>
                            <div class="form-actions">
                                <button type="button" onclick="toggleEdit('bank')" class="btn-cancel">Cancel</button>
                                <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- READ ONLY -->
                <div class="profile-section-card">
                    <div class="section-head"><div><i class="fas fa-graduation-cap"></i><h3>Academic & Employment</h3></div><span class="read-only-badge">Read Only</span></div>
                    <div class="section-view">
                        <div class="info-grid">
                            <div class="info-item"><span>Teacher ID</span><p><%= teacher != null ? teacher.getTeacher_id() : "-" %></p></div>
                            <div class="info-item"><span>Class</span><p><%= className != null ? className : "Not Assigned" %></p></div>
                            <div class="info-item"><span>Subject</span><p><%= teacher != null && teacher.getSubject() != null ? teacher.getSubject() : "-" %></p></div>
                            <div class="info-item"><span>Class Teacher</span><p><%= teacher != null && teacher.getClass_teacher() != null ? teacher.getClass_teacher() : "-" %></p></div>
                            <div class="info-item"><span>Status</span><p><%= teacher != null && teacher.getStatus() != null ? teacher.getStatus() : "-" %></p></div>
                            <div class="info-item"><span>Salary</span><p>&#8377;<%= teacher != null ? teacher.getSalary() : "0" %></p></div>
                            <div class="info-item"><span>Joining Date</span><p><%= joinStr %></p></div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<!-- VIEW PHOTO MODAL -->
<div id="viewPhotoModal" class="photo-modal-overlay" style="display:none;" onclick="closeViewPhoto()">
    <div class="photo-modal-content" onclick="event.stopPropagation()">
        <button class="photo-modal-close" onclick="closeViewPhoto()"><i class="fas fa-times"></i></button>
        <% if (_tPhoto != null && !_tPhoto.trim().isEmpty()) { %>
        <img src="<%=request.getContextPath()%>/<%= _tPhoto %>" class="photo-modal-img" alt="Profile Photo">
        <% } %>
        <div class="photo-modal-name"><%= _tName %></div>
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
function viewPhoto() { document.getElementById("photoMenu").style.display = "none"; document.getElementById("viewPhotoModal").style.display = "flex"; document.body.style.overflow = "hidden"; }
function closeViewPhoto() { document.getElementById("viewPhotoModal").style.display = "none"; document.body.style.overflow = ""; }
function openChangePhoto() { document.getElementById("photoMenu").style.display = "none"; document.getElementById("photoFileInput").click(); }
function submitPhotoForm() { document.getElementById("photoUploadForm").submit(); }
function toggleEdit(section) {
    let view = document.getElementById(section + "View");
    let edit = document.getElementById(section + "Edit");
    if (edit.style.display === "none") { view.style.display = "none"; edit.style.display = "block"; }
    else { view.style.display = "block"; edit.style.display = "none"; }
}
function calcAge() {
    let dob = new Date(document.getElementById("dobInput").value);
    let today = new Date();
    let age = today.getFullYear() - dob.getFullYear();
    let m = today.getMonth() - dob.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) age--;
    document.getElementById("ageInput").value = age > 0 ? age : "";
}
let originalUsername = document.getElementById("usernameInput") ? document.getElementById("usernameInput").value : "";
if (document.getElementById("usernameInput")) {
    document.getElementById("usernameInput").addEventListener("blur", function() {
        let val = this.value.trim();
        let msg = document.getElementById("usernameMsg");
        if (val === originalUsername) { msg.innerText = ""; return; }
        fetch("<%=request.getContextPath()%>/teacher/profile/checkUsername?username=" + val)
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