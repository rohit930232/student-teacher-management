<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>Teacher Details | Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/view-teacher.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="details-container">
    <div class="details-card">
        
        <div class="card-header">
            <h1>👨‍🏫 Teacher Details</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/Admin/Teachers" class="back-btn">← Back to List</a>
                <a href="${pageContext.request.contextPath}/Admin/EditTeacher?username=${teacher.username}" class="edit-main-btn">✏️ Edit Teacher</a>
            </div>
        </div>

        <div class="profile-section">
            <div class="profile-image">
                <c:choose>
                    <c:when test="${not empty teacher.photo}">
                        <img src="${pageContext.request.contextPath}/${teacher.photo}" alt="Profile Photo" id="profileImg" class="clickable-img">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/images/default-avatar.png" alt="Default Photo" id="profileImg" class="clickable-img">
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="profile-info">
                <h2>${teacher.name}</h2>
                <p class="emp-id">Employee ID: ${teacher.username}</p>
                <div class="role-badge">
                    <c:choose>
                        <c:when test="${teacher.class_teacher eq 'Yes'}">
                            🏫 Class Teacher - Class ${teacher.class_id}
                        </c:when>
                        <c:otherwise>
                            📚 Subject Teacher
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <div id="imageModal" class="image-modal">
            <span class="image-modal-close" onclick="closeImageModal()">&times;</span>
            <img class="image-modal-content" id="modalImage">
        </div>

        <div class="info-grid">
            <div class="info-section">
                <h3>📋 Personal Information</h3>
                <div class="info-row">
                    <span class="info-label">Full Name:</span>
                    <span class="info-value">${teacher.name}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Employee ID:</span>
                    <span class="info-value">${teacher.username}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Age:</span>
                    <span class="info-value">${teacher.age} years</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Gender:</span>
                    <span class="info-value">${teacher.gender}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Date of Birth:</span>
                    <span class="info-value">
                        <fmt:formatDate value="${teacher.dob}" pattern="dd MMM yyyy"/>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Joining Date:</span>
                    <span class="info-value">
                        <fmt:formatDate value="${teacher.joining_date}" pattern="dd MMM yyyy"/>
                    </span>
                </div>
            </div>
            <div class="info-section">
                <h3>📞 Contact Information</h3>
                <div class="info-row">
                    <span class="info-label">Mobile Number:</span>
                    <span class="info-value">${teacher.mobile}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email Address:</span>
                    <span class="info-value">${teacher.email}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Current Address:</span>
                    <span class="info-value">${teacher.address}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Permanent Address:</span>
                    <span class="info-value">${teacher.permanent_address}</span>
                </div>
            </div>
            <div class="info-section">
                <h3>🎓 Professional Information</h3>
                <div class="info-row">
                    <span class="info-label">Qualification:</span>
                    <span class="info-value">${teacher.qualification}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Experience:</span>
                    <span class="info-value">${teacher.experience} years</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Subjects Taught:</span>
                    <span class="info-value subject-tag">${teacher.subject}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Class Teacher:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${teacher.class_teacher eq 'Yes'}">
                                <span class="yes-badge">Yes - Class ${teacher.class_id}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="no-badge">No</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            <div class="info-section">
                <h3>💰 Salary Information</h3>
                <div class="info-row">
                    <span class="info-label">Monthly Salary:</span>
                    <span class="info-value salary">₹ ${teacher.salary}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Paid Salary:</span>
                    <span class="info-value paid">₹ ${teacher.salary - teacher.remaining_salary}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Unpaid / Remaining:</span>
                    <span class="info-value unpaid">₹ ${teacher.remaining_salary}</span>
                </div>
            </div>
            <div class="info-section">
                <h3>🏦 Bank Details</h3>
                <div class="info-row">
                    <span class="info-label">Account Holder:</span>
                    <span class="info-value">${teacher.account_holder}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Account Number:</span>
                    <span class="info-value">${teacher.account_number}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Bank Name:</span>
                    <span class="info-value">${teacher.bank_name}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">IFSC Code:</span>
                    <span class="info-value">${teacher.ifsc_code}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Branch:</span>
                    <span class="info-value">${teacher.branch}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">PAN Number:</span>
                    <span class="info-value">${teacher.pan_number}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">UPI ID:</span>
                    <span class="info-value">${teacher.upi_id}</span>
                </div>
            </div>
            <div class="info-section">
                <h3>⚙️ Status</h3>
                <div class="info-row">
                    <span class="info-label">Current Status:</span>
                    <span class="info-value">
                        <c:choose>
                            <c:when test="${teacher.status eq 'Active'}">
                                <span class="status-active">✅ Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-inactive">❌ Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Image zoom functionality
var modal = document.getElementById("imageModal");
var modalImg = document.getElementById("modalImage");
var profileImg = document.getElementById("profileImg");

if (profileImg) {
    profileImg.onclick = function() {
        modal.style.display = "flex";
        modalImg.src = this.src;
    }
}

function closeImageModal() {
    modal.style.display = "none";
}

// Close modal when clicking outside
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

</body>
</html>