<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("currentPage", "help");
    request.setAttribute("pageTitle", "Help & Support");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Help</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/help.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <div class="help-layout">
                <div class="help-card">
                    <div class="help-card-head"><i class="fas fa-question-circle"></i><h3>Frequently Asked Questions</h3></div>
                    <div class="faq-list">
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I add a new student?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Students section and click Add Student button. Fill in all required details and submit the form.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I pay teacher salary?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Payment section, switch to Teacher Salary tab. Find the teacher and click Pay Salary. The bank details will auto-fill from the database. You can edit them if needed before paying.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I change a teacher's class?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Teachers section. Find the teacher and click Edit. You can change Class ID, Class Teacher, Subject, Status and Salary from there.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I publish a notice?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Notices section. Select the target class (or All Classes), type your notice message and click Publish Notice.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I view class-wise attendance?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Attendance section. Select a class, then select a month to view attendance summary. Click View on any student to see day-wise details.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I manage timetable?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Timetable section. Select a class. You can add new periods by clicking Add Period, and delete existing ones with the delete button.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I change my password?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Settings → Profile Security → Change Password. Enter your current password and new password.</div></div>
                    </div>
                </div>

                <div class="help-card">
                    <div class="help-card-head"><i class="fas fa-headset"></i><h3>Contact Support</h3></div>
                    <div class="contact-info-grid">
                        <div class="contact-info-item"><i class="fas fa-envelope"></i><div><span>Email</span><p>rohittavar930@gmail.com</p></div></div>
                        <div class="contact-info-item"><i class="fas fa-phone"></i><div><span>Phone</span><p>+91 9302544352</p></div></div>
                        <div class="contact-info-item"><i class="fas fa-clock"></i><div><span>Support Hours</span><p>Mon - Sat, 9:00 AM - 6:00 PM</p></div></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function toggleFaq(el) {
    let answer = el.nextElementSibling;
    let icon   = el.querySelector("i");
    let isOpen = answer.style.display === "block";
    document.querySelectorAll(".faq-answer").forEach(a => a.style.display = "none");
    document.querySelectorAll(".faq-question i").forEach(i => i.style.transform = "rotate(0deg)");
    if (!isOpen) { answer.style.display = "block"; icon.style.transform = "rotate(180deg)"; }
}
</script>
</body>
</html>