<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("currentPage", "help");
    request.setAttribute("pageTitle", "Help & Support");
    String successMsg = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Help</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/help.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">
            <% if ("1".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Message sent!</div><% } %>
            <div class="help-layout">
                <div class="help-card">
                    <div class="help-card-head"><i class="fas fa-question-circle"></i><h3>Frequently Asked Questions</h3></div>
                    <div class="faq-list">
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I mark attendance?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Attendance section, select the class, then mark Present/Absent for each student and save.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I upload notes?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Notes section, select the class, click Upload Notes and fill in the details.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I create an exam?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Exam section, select the class, click Create Exam and fill in subject, date, time and marks.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I add results?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Result section, select the class, click Add Result, select student and exam, enter marks.</div></div>
                        <div class="faq-item"><div class="faq-question" onclick="toggleFaq(this)"><span>How do I change my password?</span><i class="fas fa-chevron-down"></i></div><div class="faq-answer">Go to Settings → Profile Security → Change Password section.</div></div>
                    </div>
                </div>
                <div class="help-card">
                    <div class="help-card-head"><i class="fas fa-headset"></i><h3>Contact Support</h3></div>
                    <div class="contact-info-grid">
                        <div class="contact-info-item"><i class="fas fa-envelope"></i><div><span>Email</span><p>rohittavar930@gmail.com</p></div></div>
                        <div class="contact-info-item"><i class="fas fa-phone"></i><div><span>Phone</span><p>+91 9302544352</p></div></div>
                        <div class="contact-info-item"><i class="fas fa-clock"></i><div><span>Support Hours</span><p>Mon - Sat, 9:00 AM - 6:00 PM</p></div></div>
                    </div>
                    <form action="<%=request.getContextPath()%>/teacher/help/send" method="post" style="margin-top:20px;">
                        <div class="form-field"><label>Subject</label><input type="text" name="subject" placeholder="Enter subject" required></div>
                        <div class="form-field"><label>Message</label><textarea name="message" rows="4" placeholder="Describe your issue..." required></textarea></div>
                        <button type="submit" class="btn-send"><i class="fas fa-paper-plane"></i> Send Message</button>
                    </form>
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