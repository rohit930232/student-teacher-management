<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Students | Admin Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/dashboard.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/manage-students.css">
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
            <a href="<%=request.getContextPath()%>/Admin/Students" class="nav-item active">👨‍🎓 Students</a>
            <a href="<%=request.getContextPath()%>/Admin/Teachers" class="nav-item">👩‍🏫 Teachers</a>
            <a href="<%=request.getContextPath()%>/Admin/NonTeachingStaff" class="nav-item">👔 Staff</a>
            <a href="<%=request.getContextPath()%>/Admin/Notices" class="nav-item">📢 Notices</a>
            <a href="<%=request.getContextPath()%>/Admin/Fees" class="nav-item">💰 Fees</a>
            <a href="<%=request.getContextPath()%>/Admin/Notifications" class="nav-item">🔔 Notifications</a>
            
            <a href="<%=request.getContextPath()%>/Admin/Profile" class="nav-item profile-item">👤 My Profile</a>
            
            <a href="<%=request.getContextPath()%>/Logout" class="nav-item logout-btn">🚪 Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <div class="welcome-header">
            <h1>
                Welcome,
                <c:choose>
                    <c:when test="${not empty sessionScope.fullname}">
                        ${fn:split(sessionScope.fullname, ' ')[0]}
                    </c:when>
                    <c:otherwise>
                        ${sessionScope.username}
                    </c:otherwise>
                </c:choose>
                !
            </h1>
        </div>

        <div class="page-container">
            <h2 class="page-title">📚 Manage Students</h2>

            <div class="class-table-container">
                <table class="class-table">
                    <thead>
                        <tr>
                            <th>Class</th>
                            <th>Total Students</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${classList}">
                            <tr>
                                <td class="class-name">${c[1]}</td>
                                <td class="total-students">${c[2]}</td>
                                <td>
                                    <a class="view-btn" href="<%=request.getContextPath()%>/Admin/ClassStudents?classId=${c[0]}&className=${c[1]}">👁️ View</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

</body>
</html>