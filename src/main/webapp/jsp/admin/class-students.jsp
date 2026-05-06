<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "students");
    request.setAttribute("pageTitle", "Students");
    String className    = (String) request.getAttribute("className");
    String classTeacher = (String) request.getAttribute("classTeacher");
    int totalStudents   = request.getAttribute("totalStudents") != null ? (Integer) request.getAttribute("totalStudents") : 0;
    List<Map<String,String>> students = (List<Map<String,String>>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Class Students</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/students.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="page-container">
                <div class="class-header">
                    <a href="<%=request.getContextPath()%>/admin/students" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <div>
                        <h2><i class="fas fa-chalkboard"></i> <%= className != null ? className : "" %></h2>
                        <div class="class-meta">
                            <span><i class="fas fa-users"></i> Total Students: <strong><%= totalStudents %></strong></span>
                            <span><i class="fas fa-chalkboard-teacher"></i> Class Teacher: <strong><%= classTeacher != null && !classTeacher.isEmpty() ? classTeacher : "Not Assigned" %></strong></span>
                        </div>
                    </div>
                </div>
                <div class="search-row">
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search student..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="studentTable">
                        <thead>
                            <tr><th>#</th><th>Photo</th><th>Name</th><th>Username</th><th>Email</th><th>Mobile</th><th>Gender</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                        <%
                            if (students != null && !students.isEmpty()) {
                                int i = 1;
                                for (Map<String,String> s : students) {
                                    String sName  = s.get("name")     != null ? s.get("name")     : "-";
                                    String sUser  = s.get("username") != null ? s.get("username") : "";
                                    String sEmail = s.get("email")    != null ? s.get("email")    : "-";
                                    String sMob   = s.get("mobile")   != null ? s.get("mobile")   : "-";
                                    String sGen   = s.get("gender")   != null ? s.get("gender")   : "-";
                                    String sPhoto = s.get("photo")    != null ? s.get("photo")    : "";
                                    String sInit  = sName.length() > 0 ? String.valueOf(sName.charAt(0)).toUpperCase() : "S";
                        %>
                            <tr>
                                <td><%= i++ %></td>
                                <td>
                                    <% if (!sPhoto.isEmpty()) { %>
                                    <img src="<%=request.getContextPath()%>/<%= sPhoto %>" class="student-photo"
                                         onclick="viewPhoto('<%=request.getContextPath()%>/<%= sPhoto %>')"
                                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" alt="Photo">
                                    <div class="photo-placeholder" style="display:none;"><%= sInit %></div>
                                    <% } else { %>
                                    <div class="photo-placeholder"><%= sInit %></div>
                                    <% } %>
                                </td>
                                <td><strong><%= sName %></strong></td>
                                <td><%= sUser %></td>
                                <td><%= sEmail %></td>
                                <td><%= sMob %></td>
                                <td><%= sGen %></td>
                                <td>
                                    <button class="btn-view" onclick="viewStudent('<%= sUser %>')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="8" class="empty-row"><i class="fas fa-user-slash"></i> No students found</td></tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="studentModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-large">
        <div class="modal-head">
            <h3><i class="fas fa-user"></i> Student Details</h3>
            <button onclick="closeModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="modalBody">
            <div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
        </div>
    </div>
</div>

<div id="photoModal" class="photo-modal-overlay" style="display:none;" onclick="closePhotoModal()">
    <div class="photo-modal-content" onclick="event.stopPropagation()">
        <button class="photo-modal-close" onclick="closePhotoModal()"><i class="fas fa-times"></i></button>
        <img id="photoModalImg" src="" class="photo-modal-img" alt="Photo">
    </div>
</div>

<script>
var ctxPath = '<%=request.getContextPath()%>';

function searchTable() {
    var input = document.getElementById("searchInput").value.toLowerCase();
    var rows  = document.querySelectorAll("#studentTable tbody tr");
    rows.forEach(function(row) {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}

function viewPhoto(src) {
    document.getElementById("photoModalImg").src = src;
    document.getElementById("photoModal").style.display = "flex";
}

function closePhotoModal() {
    document.getElementById("photoModal").style.display = "none";
}

function viewStudent(username) {
    document.getElementById("studentModal").style.display = "flex";
    document.getElementById("modalBody").innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

    fetch(ctxPath + '/admin/students/detail?username=' + encodeURIComponent(username))
        .then(function(r) { return r.json(); })
        .then(function(s) {
            var photoHtml = '';
            if (s.photo && s.photo.trim() !== '') {
                photoHtml = '<img src="' + ctxPath + '/' + s.photo + '" class="detail-photo" onclick="viewPhoto(\'' + ctxPath + '/' + s.photo + '\')" onerror="this.style.display=\'none\'">';
            } else {
                photoHtml = '<div class="detail-photo-placeholder">' + (s.name ? s.name.charAt(0).toUpperCase() : 'S') + '</div>';
            }

            document.getElementById("modalBody").innerHTML =
                '<div class="detail-top">'
                    + photoHtml
                    + '<div class="detail-top-info">'
                        + '<h2>' + (s.name || '-') + '</h2>'
                        + '<p>ID: ' + (s.student_id || '-') + ' &nbsp;|&nbsp; Roll: ' + (s.roll_number || '-') + '</p>'
                    + '</div>'
                + '</div>'
                + '<div class="detail-sections">'
                    + '<div class="detail-section">'
                        + '<h4><i class="fas fa-user"></i> Personal Info</h4>'
                        + '<div class="detail-grid">'
                            + '<div class="detail-item"><span>Email</span><p>' + (s.email || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Mobile</span><p>' + (s.mobile || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Gender</span><p>' + (s.gender || '-') + '</p></div>'
                            + '<div class="detail-item"><span>DOB</span><p>' + (s.dob || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Blood Group</span><p>' + (s.blood_group || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Fees Paid</span><p>&#8377;' + (s.fees_paid || '0') + '</p></div>'
                            + '<div class="detail-item"><span>Fees Remaining</span><p>&#8377;' + (s.fees_remaining || '0') + '</p></div>'
                        + '</div>'
                    + '</div>'
                    + '<div class="detail-section">'
                        + '<h4><i class="fas fa-users"></i> Family Info</h4>'
                        + '<div class="detail-grid">'
                            + '<div class="detail-item"><span>Father</span><p>' + (s.father_name || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Mother</span><p>' + (s.mother_name || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Parents Mobile</span><p>' + (s.parents_mobile || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Father Occupation</span><p>' + (s.father_occupation || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Mother Occupation</span><p>' + (s.mother_occupation || '-') + '</p></div>'
                            + '<div class="detail-item"><span>Annual Income</span><p>&#8377;' + (s.annual_income || '0') + '</p></div>'
                        + '</div>'
                    + '</div>'
                    + '<div class="detail-section">'
                        + '<h4><i class="fas fa-map-marker-alt"></i> Address</h4>'
                        + '<div class="detail-grid">'
                            + '<div class="detail-item full"><span>Temporary Address</span><p>' + (s.temporary_address || '-') + '</p></div>'
                            + '<div class="detail-item full"><span>Permanent Address</span><p>' + (s.permanent_address || '-') + '</p></div>'
                        + '</div>'
                    + '</div>'
                + '</div>';
        })
        .catch(function(err) {
            document.getElementById("modalBody").innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>Error loading student data. Please try again.</p></div>';
            console.error('Error:', err);
        });
}

function closeModal() {
    document.getElementById("studentModal").style.display = "none";
}

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        closeModal();
        closePhotoModal();
    }
});
</script>
</body>
</html>