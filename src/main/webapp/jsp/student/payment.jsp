<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "payment");
    request.setAttribute("pageTitle", "Payment");
    double feesPaid      = request.getAttribute("feesPaid")      != null ? (Double) request.getAttribute("feesPaid")      : 0;
    double feesRemaining = request.getAttribute("feesRemaining")  != null ? (Double) request.getAttribute("feesRemaining")  : 0;
    String successMsg = request.getParameter("success");
    String errorMsg   = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/student/payment.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <% if ("1".equals(successMsg)) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Payment successful!</div>
            <% } %>
            <% if ("1".equals(errorMsg)) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Payment failed. Try again.</div>
            <% } %>

            <!-- FEES SUMMARY -->
            <div class="fees-summary">
                <div class="fees-card paid">
                    <div class="fees-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="fees-info">
                        <p>Fees Paid</p>
                        <h3>&#8377;<%= String.format("%.0f", feesPaid) %></h3>
                    </div>
                </div>
                <div class="fees-card remaining">
                    <div class="fees-icon"><i class="fas fa-exclamation-circle"></i></div>
                    <div class="fees-info">
                        <p>Fees Remaining</p>
                        <h3>&#8377;<%= String.format("%.0f", feesRemaining) %></h3>
                    </div>
                </div>
                <% if (feesRemaining > 0) { %>
                <div class="fees-card pay-now">
                    <div class="fees-icon"><i class="fas fa-rupee-sign"></i></div>
                    <div class="fees-info">
                        <p>Pay Now</p>
                        <button class="btn-pay" onclick="openPayModal()">
                            <i class="fas fa-credit-card"></i> Make Payment
                        </button>
                    </div>
                </div>
                <% } else { %>
                <div class="fees-card cleared">
                    <div class="fees-icon"><i class="fas fa-trophy"></i></div>
                    <div class="fees-info">
                        <p>Status</p>
                        <h3 style="font-size:16px;">All Fees Cleared!</h3>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- PAYMENT HISTORY -->
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-history"></i> Payment History</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search..." onkeyup="searchTable()">
                    </div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="payTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Amount</th>
                                <th>Payment Type</th>
                                <th>Payment Mode</th>
                                <th>Transaction ID</th>
                                <th>Receipt No.</th>
                                <th>Remarks</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
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
                                <td><%= p.get("payment_type") != null && !p.get("payment_type").equals("-") ? p.get("payment_type") : "-" %></td>
                                <td>
                                    <span class="mode-badge">
                                        <i class="fas fa-<%= "UPI".equals(p.get("payment_mode")) ? "mobile-alt" : "Credit Card".equals(p.get("payment_mode")) ? "credit-card" : "university" %>"></i>
                                        <%= p.get("payment_mode") %>
                                    </span>
                                </td>
                                <td><code><%= p.get("transaction_id") != null && !p.get("transaction_id").equals("-") ? p.get("transaction_id") : "-" %></code></td>
                                <td><%= p.get("receipt_number") != null && !p.get("receipt_number").equals("-") ? p.get("receipt_number") : "-" %></td>
                                <td><%= p.get("remarks") != null && !p.get("remarks").equals("-") ? p.get("remarks") : "-" %></td>
                                <td><i class="fas fa-calendar"></i> <%= p.get("payment_date") != null ? p.get("payment_date").substring(0,10) : "-" %></td>
                                <td><span class="status-badge <%= "Paid".equalsIgnoreCase(status) ? "status-paid" : "status-pending" %>"><%= status %></span></td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="9" class="empty-row"><i class="fas fa-inbox"></i> No payment history found</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- PAY MODAL -->
<div id="payModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-credit-card"></i> Make Payment</h3>
            <button onclick="closePayModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/student/payment/save" method="post">
                <div class="form-field">
                    <label>Amount (&#8377;)</label>
                    <input type="number" name="amount" id="amountInput" placeholder="Enter amount" min="1" max="<%= (int)feesRemaining %>" required>
                    <small>Remaining: &#8377;<%= String.format("%.0f", feesRemaining) %></small>
                </div>
                <div class="form-field">
                    <label>Payment Mode</label>
                    <select name="payment_mode" required>
                        <option value="">-- Select --</option>
                        <option value="UPI">UPI</option>
                        <option value="Net Banking">Net Banking</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="Cash">Cash</option>
                    </select>
                </div>
                <div class="form-field">
                    <label>Transaction ID <small>(optional)</small></label>
                    <input type="text" name="transaction_id" placeholder="Enter transaction ID">
                </div>
                <div class="form-field">
                    <label>Remarks <small>(optional)</small></label>
                    <input type="text" name="remarks" placeholder="e.g. Term 1 fees">
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closePayModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-check"></i> Pay Now</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openPayModal()  { document.getElementById("payModal").style.display = "flex"; }
function closePayModal() { document.getElementById("payModal").style.display = "none"; }
function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows  = document.querySelectorAll("#payTable tbody tr");
    rows.forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
</script>
</body>
</html>