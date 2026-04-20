<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <title>Class Students | Admin Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/dashboard.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/class-students.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Extra styles for side-by-side modal layout */
        .photo-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.9);
            z-index: 2000;
            cursor: pointer;
            align-items: center;
            justify-content: center;
        }
        .photo-modal img {
            max-width: 90%;
            max-height: 90%;
            border-radius: 10px;
        }
        .close-photo {
            position: absolute;
            top: 20px;
            right: 35px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
        }
        .student-photo {
            cursor: pointer;
        }
        .side-by-side-details {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        .photo-side {
            flex: 0 0 150px;
            text-align: center;
        }
        .photo-side img {
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #2563eb;
            cursor: pointer;
        }
        .info-side {
            flex: 1;
            min-width: 250px;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
        }
        .info-table td {
            padding: 8px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .info-table td:first-child {
            width: 40%;
            font-weight: 600;
            color: #475569;
        }
        .info-table td:last-child {
            color: #334155;
        }
        .detail-header-name {
            color: #1e293b;
            margin: 0 0 5px 0;
            font-size: 1.5rem;
        }
        .detail-header-id {
            color: #64748b;
            margin-bottom: 15px;
        }
        .more-details {
            margin-top: 20px;
            border-top: 1px solid #e2e8f0;
            padding-top: 15px;
        }
        .more-details summary {
            cursor: pointer;
            color: #2563eb;
            font-weight: 500;
            list-style: none;
        }
        .more-details summary::-webkit-details-marker {
            display: none;
        }
        .more-details summary::before {
            content: "📋 ";
        }
    </style>
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
            
            <div class="class-header-blue">
                <div class="class-icon">📖</div>
                <div class="class-info">
                    <span class="class-label">Class</span>
                    <h2 class="class-name-blue">${className}</h2>
                </div>
                <a href="<%=request.getContextPath()%>/jsp/student/register.jsp" class="add-btn-blue">+ Add New Student</a>
            </div>

            <div class="search-wrapper">
                <div class="search-box">
                    <span class="search-icon">🔍</span>
                    <input type="text" id="searchInput" placeholder="Search by name or roll number..." onkeyup="filterStudents()">
                </div>
            </div>

            <div class="students-table-container">
                <table class="students-table" id="studentsTable">
                    <thead>
                        <tr>
                            <th>Roll No.</th>
                            <th>Photo</th>
                            <th>Name</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:forEach var="s" items="${students}">
                            <tr class="student-row" data-username="${s.username}">
                                <td class="roll-number-cell">${s.roll_number}</td>
                                <td class="photo-cell">
                                    <c:choose>
                                        <c:when test="${not empty s.photo}">
                                            <img src="<%=request.getContextPath()%>/${s.photo}" class="student-photo" alt="Student Photo" onclick="viewFullImage('<%=request.getContextPath()%>/${s.photo}')">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="<%=request.getContextPath()%>/images/default-avatar.png" class="student-photo" alt="Default Avatar" onclick="viewFullImage('<%=request.getContextPath()%>/images/default-avatar.png')">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="name-cell">${s.name}</td>
                                <td class="action-cell">
                                    <button class="view-student-btn">View Details</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="pagination-container">
                <div class="showing-info">
                    Showing <span id="startCount">0</span> out of <span id="totalCount">0</span> students
                </div>
                <div class="pagination-buttons">
                    <button id="prevBtn" class="page-btn" onclick="prevPage()" disabled>◀ Previous</button>
                    <span id="pageInfo" class="page-info">Page 1</span>
                    <button id="nextBtn" class="page-btn" onclick="nextPage()">Next ▶</button>
                </div>
            </div>
            
        </div>
    </main>
</div>

<!-- SIDE-BY-SIDE STUDENT DETAILS MODAL -->
<div id="studentModal" class="modal">
    <div class="modal-content" style="max-width: 750px;">
        <div class="modal-header">
            <h2>👨‍🎓 Student Details</h2>
            <span class="close" onclick="closeModal()">&times;</span>
        </div>
        <div class="modal-body">
            
            <div class="side-by-side-details">
                <!-- LEFT: PHOTO -->
                <div class="photo-side">
                    <img id="modalStudentPhoto" src="" alt="Student Photo" onclick="viewFullImageFromModal()">
                    <p style="margin-top: 8px; font-size: 0.7rem; color: #2563eb; cursor: pointer;" onclick="viewFullImageFromModal()">🔍 Click to enlarge</p>
                </div>
                
                <!-- RIGHT: BASIC INFO -->
                <div class="info-side">
                    <h2 class="detail-header-name" id="modalStudentName">-</h2>
                    <p class="detail-header-id" id="modalStudentId">Student ID: -</p>
                    
                    <table class="info-table">
                        <tr><td>Full Name:</td><td id="fullName">-</td></tr>
                        <tr><td>Father's Name:</td><td id="fatherName">-</td></tr>
                        <tr><td>Mother's Name:</td><td id="motherName">-</td></tr>
                        <tr><td>Roll Number:</td><td id="rollNumber">-</td></tr>
                        <tr><td>Address:</td><td id="permanentAddress">-</td></tr>
                        <tr><td>Mobile Number:</td><td id="mobile">-</td></tr>
                        <tr><td>Father's Mobile:</td><td id="parentsMobile">-</td></tr>
                        <tr><td>Email:</td><td id="email">-</td></tr>
                    </table>
                </div>
            </div>
            
            <!-- MORE DETAILS (Collapsible) -->
            <details class="more-details">
                <summary>Show Complete Information</summary>
                <div style="margin-top: 15px;">
                    <div class="student-detail-grid">
                        <div class="detail-item"><label>Gender:</label><span id="gender">-</span></div>
                        <div class="detail-item"><label>Date of Birth:</label><span id="dob">-</span></div>
                        <div class="detail-item"><label>Blood Group:</label><span id="bloodGroup">-</span></div>
                        <div class="detail-item"><label>Mother's Occupation:</label><span id="motherOccupation">-</span></div>
                        <div class="detail-item"><label>Father's Occupation:</label><span id="fatherOccupation">-</span></div>
                        <div class="detail-item"><label>Annual Income:</label><span id="annualIncome">-</span></div>
                        <div class="detail-item full-width"><label>Temporary Address:</label><span id="temporaryAddress">-</span></div>
                        <div class="detail-item"><label>Fees Paid:</label><span id="feesPaid">-</span></div>
                        <div class="detail-item"><label>Fees Remaining:</label><span id="feesRemaining">-</span></div>
                        <div class="detail-item"><label>Total Fees:</label><span id="totalFees">-</span></div>
                    </div>
                </div>
            </details>
            
        </div>
        <div class="modal-footer">
            <button class="close-btn" onclick="closeModal()">Close</button>
        </div>
    </div>
</div>

<!-- PHOTO FULL VIEW MODAL (Lightbox) -->
<div id="photoModal" class="photo-modal" onclick="closePhotoModal()">
    <span class="close-photo" onclick="closePhotoModal()">&times;</span>
    <img id="fullImageView" src="" alt="Full Size Image">
</div>

<script>
// Store current student photo path
let currentStudentPhotoPath = '';

// Pagination variables
let currentPage = 1;
let rowsPerPage = 10;
let allRows = [];
let filteredRows = [];

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    var table = document.getElementById('studentsTable');
    if (table) {
        var rows = table.getElementsByTagName('tr');
        for (var i = 1; i < rows.length; i++) {
            allRows.push(rows[i]);
        }
        filteredRows = [...allRows];
        updateTotalCount();
        displayPage(1);
    }
});

// Filter students by search
function filterStudents() {
    var input = document.getElementById('searchInput');
    var filter = input.value.toLowerCase();
    filteredRows = allRows.filter(function(row) {
        var rollCell = row.getElementsByTagName('td')[0];
        var nameCell = row.getElementsByTagName('td')[2];
        var rollText = rollCell ? (rollCell.textContent || rollCell.innerText) : '';
        var nameText = nameCell ? (nameCell.textContent || nameCell.innerText) : '';
        return rollText.toLowerCase().indexOf(filter) > -1 || nameText.toLowerCase().indexOf(filter) > -1;
    });
    updateTotalCount();
    currentPage = 1;
    displayPage(currentPage);
}

function updateTotalCount() {
    var totalCountSpan = document.getElementById('totalCount');
    if (totalCountSpan) {
        totalCountSpan.innerText = filteredRows.length;
    }
}

function displayPage(page) {
    var tbody = document.getElementById('tableBody');
    if (!tbody) return;
    
    var start = (page - 1) * rowsPerPage;
    var end = start + rowsPerPage;
    var rowsToShow = filteredRows.slice(start, end);
    
    tbody.innerHTML = '';
    for (var i = 0; i < rowsToShow.length; i++) {
        tbody.appendChild(rowsToShow[i].cloneNode(true));
    }
    
    var startCount = filteredRows.length === 0 ? 0 : start + 1;
    var endCount = Math.min(end, filteredRows.length);
    var startCountSpan = document.getElementById('startCount');
    if (startCountSpan) {
        startCountSpan.innerText = filteredRows.length === 0 ? '0' : startCount + ' - ' + endCount;
    }
    
    var totalPages = Math.ceil(filteredRows.length / rowsPerPage);
    var pageInfoSpan = document.getElementById('pageInfo');
    if (pageInfoSpan) {
        pageInfoSpan.innerText = 'Page ' + page + ' of ' + (totalPages || 1);
    }
    
    var prevBtn = document.getElementById('prevBtn');
    var nextBtn = document.getElementById('nextBtn');
    if (prevBtn) prevBtn.disabled = (page <= 1);
    if (nextBtn) nextBtn.disabled = (page >= totalPages || totalPages === 0);
    
    // Re-attach view button events
    var viewBtns = document.querySelectorAll('.view-student-btn');
    for (var j = 0; j < viewBtns.length; j++) {
        var btn = viewBtns[j];
        var newBtn = btn.cloneNode(true);
        btn.parentNode.replaceChild(newBtn, btn);
        newBtn.addEventListener('click', function(e) {
            var row = this.closest('.student-row');
            var username = row.getAttribute('data-username');
            if (username) {
                viewStudent(username);
            }
        });
    }
}

function prevPage() {
    if (currentPage > 1) {
        currentPage--;
        displayPage(currentPage);
    }
}

function nextPage() {
    var totalPages = Math.ceil(filteredRows.length / rowsPerPage);
    if (currentPage < totalPages) {
        currentPage++;
        displayPage(currentPage);
    }
}

// View full image in lightbox
function viewFullImage(imagePath) {
    var fullImageView = document.getElementById('fullImageView');
    if (fullImageView) {
        fullImageView.src = imagePath;
        document.getElementById('photoModal').style.display = 'flex';
    }
}

function viewFullImageFromModal() {
    if (currentStudentPhotoPath) {
        viewFullImage(currentStudentPhotoPath);
    }
}

function closePhotoModal() {
    document.getElementById('photoModal').style.display = 'none';
}

// Fetch and display student details
function viewStudent(username) {
    var contextPath = '<%=request.getContextPath()%>';
    fetch(contextPath + '/Admin/StudentDetails?username=' + encodeURIComponent(username))
        .then(function(res) {
            if (!res.ok) {
                throw new Error('Network response was not ok');
            }
            return res.json();
        })
        .then(function(data) {
            // Set photo path
            if (data.photo && data.photo !== '') {
                currentStudentPhotoPath = contextPath + '/' + data.photo;
            } else {
                currentStudentPhotoPath = contextPath + '/images/default-avatar.png';
            }
            document.getElementById("modalStudentPhoto").src = currentStudentPhotoPath;
            document.getElementById("modalStudentName").innerText = data.name || "-";
            document.getElementById("modalStudentId").innerText = "Student ID: " + (data.student_id || "-");
            document.getElementById("fullName").innerText = data.name || "-";
            document.getElementById("fatherName").innerText = data.father_name || "-";
            document.getElementById("motherName").innerText = data.mother_name || "-";
            document.getElementById("rollNumber").innerText = data.roll_number || "-";
            document.getElementById("permanentAddress").innerText = data.permanent_address || "-";
            document.getElementById("mobile").innerText = data.mobile || "-";
            document.getElementById("parentsMobile").innerText = data.parents_mobile || "-";
            document.getElementById("email").innerText = data.email || "-";
            document.getElementById("gender").innerText = data.gender || "-";
            document.getElementById("dob").innerText = data.dob || "-";
            document.getElementById("bloodGroup").innerText = data.blood_group || "-";
            document.getElementById("motherOccupation").innerText = data.mother_occupation || "-";
            document.getElementById("fatherOccupation").innerText = data.father_occupation || "-";
            document.getElementById("temporaryAddress").innerText = data.temporary_address || "-";
            
            var annualIncome = data.annual_income;
            document.getElementById("annualIncome").innerText = (annualIncome && annualIncome !== '0') ? "₹ " + annualIncome : "-";
            
            var feesPaid = parseFloat(data.fees_paid) || 0;
            var feesRemaining = parseFloat(data.fees_remaining) || 0;
            document.getElementById("feesPaid").innerText = feesPaid ? "₹ " + feesPaid : "₹ 0";
            document.getElementById("feesRemaining").innerText = feesRemaining ? "₹ " + feesRemaining : "₹ 0";
            document.getElementById("totalFees").innerText = (feesPaid + feesRemaining) ? "₹ " + (feesPaid + feesRemaining) : "₹ 0";
            
            document.getElementById("studentModal").style.display = "flex";
        })
        .catch(function(error) { 
            console.error("Error:", error); 
            alert("Failed to load student details. Please check console.");
        });
}

function closeModal() { 
    document.getElementById("studentModal").style.display = "none"; 
}

window.onclick = function(event) { 
    var modal = document.getElementById("studentModal"); 
    if (event.target == modal) {
        modal.style.display = "none"; 
    }
    var photoModal = document.getElementById("photoModal");
    if (event.target == photoModal) {
        photoModal.style.display = "none";
    }
}
</script>

</body>
</html>