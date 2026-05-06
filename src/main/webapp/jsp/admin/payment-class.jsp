<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "payment");
    request.setAttribute("pageTitle", "Payment");
    String className = (String) request.getAttribute("className");
    int totalStudents   = request.getAttribute("totalStudents")   != null ? (Integer) request.getAttribute("totalStudents")   : 0;
    int paidStudents    = request.getAttribute("paidStudents")    != null ? (Integer) request.getAttribute("paidStudents")    : 0;
    int pendingStudents = request.getAttribute("pendingStudents") != null ? (Integer) request.getAttribute("pendingStudents") : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/payment.css">
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
                    <a href="<%=request.getContextPath()%>/admin/payment" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-rupee-sign"></i> <%= className %> — Fees</h2>
                </div>
                <div class="fees-summary-grid">
                    <div class="fees-summary-card total"><div class="fees-summary-icon"><i class="fas fa-users"></i></div><div><p>Total Students</p><h3><%= totalStudents %></h3></div></div>
                    <div class="fees-summary-card paid"><div class="fees-summary-icon"><i class="fas fa-check-circle"></i></div><div><p>Fees Paid</p><h3><%= paidStudents %></h3></div></div>
                    <div class="fees-summary-card pending"><div class="fees-summary-icon"><i class="fas fa-exclamation-circle"></i></div><div><p>Fees Pending</p><h3><%= pendingStudents %></h3></div></div>
                </div>
                <div class="search-row">
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search student..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="feesTable">
                        <thead>
                            <tr><th>#</th><th>Name</th><th>Roll No</th><th>Fees Paid</th><th>Fees Remaining</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> students = (List<Map<String,String>>) request.getAttribute("students");
                                if (students != null && !students.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> s : students) {
                                        double rem = Double.parseDouble(s.get("fees_remaining") != null ? s.get("fees_remaining") : "0");
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><strong><%= s.get("name") %></strong></td>
                                <td><%= s.get("roll_number") %></td>
                                <td class="paid-text">&#8377;<%= s.get("fees_paid") %></td>
                                <td class="<%= rem > 0 ? "due-text" : "paid-text" %>">&#8377;<%= s.get("fees_remaining") %></td>
                                <td>
                                    <% if (rem <= 0) { %>
                                    <span class="status-paid-badge">Cleared</span>
                                    <% } else { %>
                                    <button class="btn-view-fees" onclick="viewFees('<%= s.get("name") %>','<%= s.get("fees_paid") %>','<%= s.get("fees_remaining") %>')"><i class="fas fa-eye"></i> Details</button>
                                    <% } %>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="6" class="empty-row">No students found</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="feesModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head"><h3><i class="fas fa-rupee-sign"></i> Fees Details</h3><button onclick="closeFeesModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <div class="fees-detail-info">
                <div class="fees-detail-row"><span>Student:</span><strong id="fd_name"></strong></div>
                <div class="fees-detail-row"><span>Fees Paid:</span><strong id="fd_paid" class="paid-text"></strong></div>
                <div class="fees-detail-row"><span>Fees Remaining:</span><strong id="fd_remaining" class="due-text"></strong></div>
            </div>
        </div>
    </div>
</div>

<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#feesTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
function viewFees(name, paid, remaining) {
    document.getElementById("fd_name").innerText = name;
    document.getElementById("fd_paid").innerText = "₹" + paid;
    document.getElementById("fd_remaining").innerText = "₹" + remaining;
    document.getElementById("feesModal").style.display = "flex";
}
function closeFeesModal() { document.getElementById("feesModal").style.display = "none"; }
document.addEventListener("keydown", e => { if (e.key === "Escape") closeFeesModal(); });
</script>
</body>
</html>