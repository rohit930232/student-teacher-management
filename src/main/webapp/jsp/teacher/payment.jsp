<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "payment");
    request.setAttribute("pageTitle", "Payment");
    double salary          = request.getAttribute("salary")          != null ? (Double) request.getAttribute("salary")          : 0;
    double remainingSalary = request.getAttribute("remainingSalary") != null ? (Double) request.getAttribute("remainingSalary") : 0;
    double totalReceived   = request.getAttribute("totalReceived")   != null ? (Double) request.getAttribute("totalReceived")   : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/payment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <div class="salary-summary">
                <div class="salary-card blue">
                    <div class="salary-icon"><i class="fas fa-rupee-sign"></i></div>
                    <div class="salary-info"><p>Monthly Salary</p><h3>&#8377;<%= String.format("%.0f", salary) %></h3></div>
                </div>
                <div class="salary-card green">
                    <div class="salary-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="salary-info"><p>Total Received</p><h3>&#8377;<%= String.format("%.0f", totalReceived) %></h3></div>
                </div>
                <div class="salary-card orange">
                    <div class="salary-icon"><i class="fas fa-clock"></i></div>
                    <div class="salary-info"><p>Remaining</p><h3>&#8377;<%= String.format("%.0f", remainingSalary) %></h3></div>
                </div>
            </div>

            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-history"></i> Salary History</h2>
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="payTable">
                        <thead>
                            <tr><th>#</th><th>Amount</th><th>Payment Mode</th><th>Transaction ID</th><th>Date</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> payments = (List<Map<String,String>>) request.getAttribute("payments");
                                if (payments != null && !payments.isEmpty()) {
                                    int i = 1;
                                    for (Map<String,String> p : payments) {
                                        String status = p.get("status") != null ? p.get("status") : "-";
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><strong class="amt-text">&#8377;<%= p.get("amount") %></strong></td>
                                <td><span class="mode-badge"><i class="fas fa-university"></i> <%= p.get("payment_mode") %></span></td>
                                <td><code><%= p.get("transaction_id") != null ? p.get("transaction_id") : "-" %></code></td>
                                <td><i class="fas fa-calendar"></i> <%= p.get("payment_date") != null ? p.get("payment_date").substring(0,10) : "-" %></td>
                                <td><span class="status-badge <%= "Paid".equalsIgnoreCase(status) ? "status-paid" : "status-pending" %>"><%= status %></span></td>
                            </tr>
                            <% } } else { %><tr><td colspan="6" class="empty-row">No payment history found</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#payTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>