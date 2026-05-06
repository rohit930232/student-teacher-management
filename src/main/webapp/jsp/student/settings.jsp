<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("currentPage", "settings");
    request.setAttribute("pageTitle", "Settings");
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/settings.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("1".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Settings saved!</div><% } %>
            <% if ("1".equals(errorMsg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong.</div><% } %>

            <div class="settings-layout">
                <div class="settings-card">
                    <div class="settings-card-head"><i class="fas fa-language"></i><h3>Language</h3></div>
                    <div class="settings-card-body">
                        <select class="settings-select" onchange="saveLanguage(this.value)">
                            <option value="en">English</option>
                            <option value="hi">Hindi</option>
                            <option value="mr">Marathi</option>
                        </select>
                    </div>
                </div>

                <div class="settings-card">
                    <div class="settings-card-head"><i class="fas fa-moon"></i><h3>Dark Mode</h3></div>
                    <div class="settings-card-body">
                        <div class="toggle-row">
                            <span>Enable Dark Mode</span>
                            <label class="toggle-switch"><input type="checkbox" id="darkModeToggle" onchange="toggleDarkMode(this)"><span class="toggle-slider"></span></label>
                        </div>
                    </div>
                </div>

                <div class="settings-card">
                    <div class="settings-card-head"><i class="fas fa-bell"></i><h3>Notifications</h3></div>
                    <div class="settings-card-body">
                        <div class="toggle-row"><span>Assignment Notifications</span><label class="toggle-switch"><input type="checkbox" checked><span class="toggle-slider"></span></label></div>
                        <div class="toggle-row"><span>Exam Notifications</span><label class="toggle-switch"><input type="checkbox" checked><span class="toggle-slider"></span></label></div>
                        <div class="toggle-row"><span>Result Notifications</span><label class="toggle-switch"><input type="checkbox" checked><span class="toggle-slider"></span></label></div>
                        <div class="toggle-row"><span>Event Notifications</span><label class="toggle-switch"><input type="checkbox"><span class="toggle-slider"></span></label></div>
                    </div>
                </div>

                <div class="settings-card">
                    <div class="settings-card-head"><i class="fas fa-shield-alt"></i><h3>Privacy Settings</h3></div>
                    <div class="settings-card-body">
                        <div class="privacy-item" onclick="togglePrivacy(this)"><div class="privacy-info"><h4>Make my profile visible</h4><p>Allow others to find your profile</p></div><i class="fas fa-chevron-right"></i></div>
                        <div class="privacy-item" onclick="togglePrivacy(this)"><div class="privacy-info"><h4>Location</h4><p>Manage your location preferences</p></div><i class="fas fa-chevron-right"></i></div>
                        <div class="privacy-item" onclick="togglePrivacy(this)"><div class="privacy-info"><h4>Content Preferences</h4><p>Manage what you see</p></div><i class="fas fa-chevron-right"></i></div>
                        <div class="privacy-item" onclick="togglePrivacy(this)"><div class="privacy-info"><h4>Blocked Contacts</h4><p>Manage blocked contacts</p></div><i class="fas fa-chevron-right"></i></div>
                        <div class="privacy-item" onclick="togglePrivacy(this)"><div class="privacy-info"><h4>Direct Messages</h4><p>Manage who can message you</p></div><i class="fas fa-chevron-right"></i></div>
                    </div>
                </div>

                <div class="settings-card full-width">
                    <div class="settings-card-head"><i class="fas fa-lock"></i><h3>Profile Security</h3></div>
                    <div class="settings-card-body">
                        <div class="security-section">
                            <h4><i class="fas fa-key"></i> Change Password</h4>
                            <form action="<%=request.getContextPath()%>/student/password/change" method="post">
                                <div class="form-grid-3">
                                    <div class="form-field"><label>Current Password</label><input type="password" name="old_password" placeholder="Current password" required></div>
                                    <div class="form-field"><label>New Password</label><input type="password" name="new_password" id="newPass" placeholder="New password" required></div>
                                    <div class="form-field"><label>Confirm Password</label><input type="password" name="confirm_password" id="confirmPass" placeholder="Confirm password" required><span id="passMsg" class="field-msg"></span></div>
                                </div>
                                <button type="submit" class="btn-save-settings"><i class="fas fa-save"></i> Change Password</button>
                            </form>
                        </div>
                        <div class="security-section" style="margin-top:24px;">
                            <h4><i class="fas fa-shield-alt"></i> Two-Step Verification</h4>
                            <p class="security-desc">Add an extra layer of security to your account.</p>
                            <div class="toggle-row"><span>Enable 2-Step Verification</span><label class="toggle-switch"><input type="checkbox" id="twoStepToggle"><span class="toggle-slider"></span></label></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function toggleDarkMode(el) { document.body.classList.toggle("dark-mode", el.checked); localStorage.setItem("darkMode", el.checked); }
window.onload = function() { if (localStorage.getItem("darkMode") === "true") { document.body.classList.add("dark-mode"); document.getElementById("darkModeToggle").checked = true; } };
document.getElementById("confirmPass").addEventListener("input", function() {
    let pass = document.getElementById("newPass").value;
    let msg  = document.getElementById("passMsg");
    if (this.value && this.value !== pass) { msg.innerText = "Passwords do not match!"; msg.className = "field-msg error"; }
    else { msg.innerText = ""; }
});
function togglePrivacy(el) { el.classList.toggle("active"); }
function saveLanguage(val) { localStorage.setItem("language", val); }
</script>
</body>
</html>