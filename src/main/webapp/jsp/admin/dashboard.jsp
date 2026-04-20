<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard | Student Management</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/dashboard.css">
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
            <a href="<%=request.getContextPath()%>/Admin/Dashboard" class="nav-item active">📊 Dashboard</a>
            <a href="<%=request.getContextPath()%>/Admin/Students" class="nav-item">👨‍🎓 Students</a>
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
        <div class="stats-cards">
            <div class="stat-card blue">
                <div class="stat-icon">👨‍🎓</div>
                <div class="stat-info">
                    <h3>Total Students</h3>
                    <p>${totalStudents}</p>
                </div>
            </div>
            <div class="stat-card green">
                <div class="stat-icon">👩‍🏫</div>
                <div class="stat-info">
                    <h3>Total Teachers</h3>
                    <p>${totalTeachers}</p>
                </div>
            </div>
            <div class="stat-card orange">
                <div class="stat-icon">📚</div>
                <div class="stat-info">
                    <h3>Total Classes</h3>
                    <p>${totalClasses}</p>
                </div>
            </div>
            <div class="stat-card purple">
                <div class="stat-icon">💰</div>
                <div class="stat-info">
                    <h3>Total Fees Collected</h3>
                    <p>${totalFees}</p>
                </div>
            </div>
        </div>
        <div class="two-columns">
            <div class="left-column">
                <div class="card notice-board">
                    <div class="card-header">
                        <h3>📢 Notice Board</h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty noticeBoardList}">
                                <ul class="notice-list">
                                    <c:forEach var="notice" items="${noticeBoardList}">
                                        <li>📌 ${notice}</li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <p>No notices available</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card quick-actions">
                    <div class="card-header">
                        <h3>⚡ Quick Actions</h3>
                    </div>
                    <div class="card-body">
                        <div class="action-buttons">
                            <a href="<%=request.getContextPath()%>/jsp/student/register.jsp" class="action-btn">➕ Add Student</a>
                            <a href="<%=request.getContextPath()%>/jsp/teacher/register.jsp" class="action-btn">👨‍🏫 Add Teacher</a>
                            <a href="<%=request.getContextPath()%>/Admin/Notices" class="action-btn">📢 Send Notice</a>
                            <a href="<%=request.getContextPath()%>/Admin/Fees" class="action-btn">💰 Manage Fees</a>
                            <a href="<%=request.getContextPath()%>/Admin/Notifications" class="action-btn">🔔 Send Notification</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="right-column">
                <div class="card notifications">
                    <div class="card-header">
                        <h3>🔔 Notifications</h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty notificationsList}">
                                <div class="timeline">
                                    <c:forEach var="n" items="${notificationsList}">
                                        <div class="timeline-item">
                                            <div class="timeline-content">${n.message}</div>
                                            <div class="timeline-time">${n.time}</div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p>No notifications available</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card exam-card">
                    <div class="card-header">
                        <h3>📝 Incoming Exam</h3>
                    </div>
                    <div class="card-body">
                        <div class="exam-info">
                            <span class="exam-subject">${examSubject}</span>
                            <span class="exam-date">📅 ${examDate}</span>
                        </div>
                        <a href="<%=request.getContextPath()%>/Admin/ExamSchedule" class="view-schedule-btn">View Schedule →</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>