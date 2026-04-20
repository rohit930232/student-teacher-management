<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Profile | Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/dashboard.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/profile.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="dashboard">

    <aside class="sidebar">
        <div class="profile-section">
            <c:choose>
                <c:when test="${not empty sessionScope.photo}">
                    <img src="<%=request.getContextPath()%>/${sessionScope.photo}" class="profile-img">
                </c:when>
                <c:otherwise>
                    <img src="<%=request.getContextPath()%>/images/default.png" class="profile-img">
                </c:otherwise>
            </c:choose>
            <h3 class="profile-name">${sessionScope.username}</h3>
            <p class="profile-role">Administrator</p>
        </div>

        <nav class="sidebar-nav">
            <a href="<%=request.getContextPath()%>/Admin/Dashboard" class="nav-item">📊 Dashboard</a>
            <a href="<%=request.getContextPath()%>/Admin/Students" class="nav-item">👨‍🎓 Students</a>
            <a href="<%=request.getContextPath()%>/Admin/Teachers" class="nav-item">👩‍🏫 Teachers</a>
            <a href="<%=request.getContextPath()%>/Admin/NonTeachingStaff" class="nav-item">👔 Staff</a>
            <a href="<%=request.getContextPath()%>/Admin/Notices" class="nav-item">📢 Notices</a>
            <a href="<%=request.getContextPath()%>/Admin/Fees" class="nav-item">💰 Fees</a>
            <a href="<%=request.getContextPath()%>/Admin/Notifications" class="nav-item">🔔 Notifications</a>
            <a href="<%=request.getContextPath()%>/Admin/Profile" class="nav-item active profile-item">👤 My Profile</a>
            <a href="<%=request.getContextPath()%>/Logout" class="nav-item logout-btn">🚪 Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="welcome-header">
            <h1>My Profile</h1>
        </div>

        <div class="profile-container">
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty admin.photo}">
                                <img src="<%=request.getContextPath()%>/${admin.photo}" class="avatar-img">
                            </c:when>
                            <c:otherwise>
                                <img src="<%=request.getContextPath()%>/images/default.png" class="avatar-img">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-title">
                        <h2>${admin.fullname}</h2>
                        <p>@${admin.username}</p>
                        <span class="role-badge">Administrator</span>
                    </div>
                </div>
                <form action="<%=request.getContextPath()%>/Admin/Profile" method="post" class="profile-form">
                    
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert success">${sessionScope.message}</div>
                        <% session.removeAttribute("message"); %>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert error">${sessionScope.error}</div>
                        <% session.removeAttribute("error"); %>
                    </c:if>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="fullname" value="${admin.fullname}" required>
                        </div>

                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" value="${admin.username}" disabled>
                            <small>Username cannot be changed</small>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" value="${admin.email}" required>
                        </div>

                        <div class="form-group">
                            <label>Mobile Number</label>
                            <input type="tel" name="mobile" value="${admin.mobile}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Gender</label>
                            <select name="gender">
                                <option value="Male" ${admin.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${admin.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${admin.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Date of Birth</label>
                            <input type="text" value="${admin.dob}" disabled>
                            <small>Contact admin to change DOB</small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Address</label>
                        <textarea name="address" rows="3">${admin.address}</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="save-btn">💾 Save Changes</button>
                        <a href="<%=request.getContextPath()%>/Admin/Dashboard" class="cancel-btn">Cancel</a>
                    </div>
                </form>

            </div>
        </div>
    </main>
</div>

</body>
</html>