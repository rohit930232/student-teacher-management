<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Teachers | Admin Dashboard</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/manage-teachers.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="dashboard">
    <aside class="sidebar">
        <div class="profile-section">
            <c:choose>
                <c:when test="${not empty sessionScope.photo}">
                    <img src="${pageContext.request.contextPath}/${sessionScope.photo}" class="profile-img">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/images/default.png" class="profile-img">
                </c:otherwise>
            </c:choose>
            <h3 class="profile-name">${sessionScope.username}</h3>
            <p class="profile-role">Administrator</p>
        </div>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/Admin/Dashboard" class="nav-item">📊 Dashboard</a>
            <a href="${pageContext.request.contextPath}/Admin/Students" class="nav-item">👨‍🎓 Students</a>
            <a href="${pageContext.request.contextPath}/Admin/Teachers" class="nav-item active">👩‍🏫 Teachers</a>
            <a href="${pageContext.request.contextPath}/Admin/NonTeachingStaff" class="nav-item">👔 Staff</a>
            <a href="${pageContext.request.contextPath}/Admin/Notices" class="nav-item">📢 Notices</a>
            <a href="${pageContext.request.contextPath}/Admin/Fees" class="nav-item">💰 Fees</a>
            <a href="${pageContext.request.contextPath}/Admin/Notifications" class="nav-item">🔔 Notifications</a>
            <a href="${pageContext.request.contextPath}/Admin/Profile" class="nav-item profile-item">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/Logout" class="nav-item logout-btn">🚪 Logout</a>
        </nav>
    </aside>
    <main class="main-content">
        <div class="page-container">
            <h2 class="page-title">👩‍🏫 Manage Teachers</h2>

            <div class="search-bar">
                <input type="text" id="searchInput" placeholder="🔍 Search by name, email or ID...">
                <a href="${pageContext.request.contextPath}/jsp/teacher/register.jsp" class="add-btn">+ Add New Teacher</a>
            </div>

            <div class="table-wrapper">
                <table class="teacher-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Photo</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Mobile</th>
                            <th>Subject</th>
                            <th>Class Teacher</th>
                            <th>Salary</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="teacherTableBody">
                        <c:forEach var="t" items="${teachers}">
                            <tr>
                                <td>${t.username}</td>
                                <td class="photo-cell">
                                    <c:choose>
                                        <c:when test="${not empty t.photo}">
                                            <img src="${pageContext.request.contextPath}/${t.photo}" class="teacher-photo">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/images/default-avatar.png" class="teacher-photo">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><strong>${t.name}</strong></td>
                                <td>${t.email}</td>
                                <td>${t.mobile}</td>
                                <td><span class="subject-badge">${t.subject}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.class_teacher eq 'Yes'}">
                                            <span class="class-teacher-badge yes">Class ${t.class_id}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="class-teacher-badge no">No</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>₹ ${t.salary}</td>
                                <td class="action-btns">
                                    <a href="${pageContext.request.contextPath}/Admin/ViewTeacher?username=${t.username}" class="action-btn view">👁️ View</a>
                                    <a href="${pageContext.request.contextPath}/Admin/UpdateTeacher?username=${t.username}" class="action-btn edit">✏️ Edit</a>
                                    <a href="${pageContext.request.contextPath}/Admin/DeleteTeacher?username=${t.username}" class="action-btn delete" onclick="return confirm('Are you sure?')">🗑️ Delete</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script>
document.getElementById("searchInput").addEventListener("keyup", function() {
    let filter = this.value.toLowerCase();
    let rows = document.querySelectorAll("#teacherTableBody tr");
    
    rows.forEach(row => {
        let name = row.cells[2]?.innerText.toLowerCase() || "";
        let email = row.cells[3]?.innerText.toLowerCase() || "";
        let id = row.cells[0]?.innerText.toLowerCase() || "";
        
        if(name.includes(filter) || email.includes(filter) || id.includes(filter)) {
            row.style.display = "";
        } else {
            row.style.display = "none";
        }
    });
});
</script>

</body>
</html>