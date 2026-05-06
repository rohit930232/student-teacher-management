<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "payment");
    request.setAttribute("pageTitle", "Payment");
    String msg = request.getParameter("msg");
    double totalFeesPaid      = request.getAttribute("totalFeesPaid")      != null ? (Double) request.getAttribute("totalFeesPaid")      : 0;
    double totalFeesRemaining = request.getAttribute("totalFeesRemaining")  != null ? (Double) request.getAttribute("totalFeesRemaining")  : 0;
    double totalSalaryPaid    = request.getAttribute("totalSalaryPaid")    != null ? (Double) request.getAttribute("totalSalaryPaid")    : 0;
    double totalSalaryDue     = request.getAttribute("totalSalaryDue")     != null ? (Double) request.getAttribute("totalSalaryDue")     : 0;
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
            <% if ("paid".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Salary paid successfully!</div><% } %>
            <% if ("error".equals(msg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Payment failed!</div><% } %>

            <div class="stats-grid">
                <div class="stat-card green"><div class="stat-icon"><i class="fas fa-rupee-sign"></i></div><div class="stat-body"><p>Fees Collected</p><h3>&#8377;<%= String.format("%.0f", totalFeesPaid) %></h3></div></div>
                <div class="stat-card red"><div class="stat-icon"><i class="fas fa-exclamation-circle"></i></div><div class="stat-body"><p>Fees Pending</p><h3>&#8377;<%= String.format("%.0f", totalFeesRemaining) %></h3></div></div>
                <div class="stat-card blue"><div class="stat-icon"><i class="fas fa-wallet"></i></div><div class="stat-body"><p>Salary Paid</p><h3>&#8377;<%= String.format("%.0f", totalSalaryPaid) %></h3></div></div>
                <div class="stat-card orange"><div class="stat-icon"><i class="fas fa-clock"></i></div><div class="stat-body"><p>Salary Due</p><h3>&#8377;<%= String.format("%.0f", totalSalaryDue) %></h3></div></div>
            </div>

            <div class="payment-tabs">
                <button class="tab-btn active" onclick="switchTab('student')"><i class="fas fa-user-graduate"></i> Student Fees</button>
                <button class="tab-btn" onclick="switchTab('teacher')"><i class="fas fa-chalkboard-teacher"></i> Teacher Salary</button>
            </div>

            <div id="studentTab" class="tab-content">
                <div class="page-container">
                    <h3 class="section-title"><i class="fas fa-user-graduate"></i> Student Fees — Select Class</h3>
                    <div class="class-grid">
                        <%
                            List<Map<String,String>> classList = (List<Map<String,String>>) request.getAttribute("classList");
                            if (classList != null && !classList.isEmpty()) {
                                for (Map<String,String> c : classList) {
                        %>
                        <a href="<%=request.getContextPath()%>/admin/payment/class?classId=<%= c.get("class_id") %>&className=<%= c.get("class_name") %>" class="class-card">
                            <div class="class-card-icon"><i class="fas fa-chalkboard"></i></div>
                            <div class="class-card-info">
                                <h3><%= c.get("class_name") %></h3>
                                <p><i class="fas fa-check-circle" style="color:#10b981"></i> Paid: <%= c.get("paid_count") != null ? c.get("paid_count") : "0" %></p>
                                <p><i class="fas fa-times-circle" style="color:#ef4444"></i> Pending: <%= c.get("pending_count") != null ? c.get("pending_count") : "0" %></p>
                            </div>
                            <i class="fas fa-chevron-right arrow"></i>
                        </a>
                        <% } } else { %>
                        <div class="empty-state"><i class="fas fa-school"></i><p>No classes found</p></div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div id="teacherTab" class="tab-content" style="display:none;">
                <div class="page-container">
                    <h3 class="section-title"><i class="fas fa-chalkboard-teacher"></i> Teacher Salary</h3>
                    <div class="search-row">
                        <div class="search-box"><i class="fas fa-search"></i><input type="text" id="teacherSearch" placeholder="Search teacher..." onkeyup="searchTeacher()"></div>
                    </div>
                    <div class="table-wrap">
                        <table class="data-table" id="teacherPayTable">
                            <thead>
                                <tr><th>#</th><th>Photo</th><th>Name</th><th>Monthly Salary</th><th>Total Paid</th><th>Remaining</th><th>Action</th></tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Map<String,String>> teachers = (List<Map<String,String>>) request.getAttribute("teachers");
                                    if (teachers != null && !teachers.isEmpty()) {
                                        int i = 1;
                                        for (Map<String,String> t : teachers) {
                                %>
                                <tr>
                                    <td><%= i++ %></td>
                                    <td>
                                        <% if (t.get("photo") != null && !t.get("photo").isEmpty()) { %>
                                        <img src="<%=request.getContextPath()%>/<%= t.get("photo") %>" class="teacher-photo" alt="Photo">
                                        <% } else { %>
                                        <div class="photo-placeholder"><%= t.get("name") != null && t.get("name").length() > 0 ? String.valueOf(t.get("name").charAt(0)).toUpperCase() : "T" %></div>
                                        <% } %>
                                    </td>
                                    <td><strong><%= t.get("name") %></strong><br><small><%= t.get("username") %></small></td>
                                    <td>&#8377;<%= t.get("salary") %></td>
                                    <td class="paid-text">&#8377;<%= t.get("total_paid") != null ? t.get("total_paid") : "0" %></td>
                                    <td class="<%= Double.parseDouble(t.get("remaining_salary") != null ? t.get("remaining_salary") : "0") > 0 ? "due-text" : "paid-text" %>">&#8377;<%= t.get("remaining_salary") != null ? t.get("remaining_salary") : "0" %></td>
                                    <td>
                                        <button class="btn-pay" onclick="openPayModal('<%= t.get("teacher_id") %>','<%= t.get("username") %>','<%= t.get("name") %>','<%= t.get("salary") %>','<%= t.get("remaining_salary") != null ? t.get("remaining_salary") : "0" %>','<%= t.get("account_holder") %>','<%= t.get("account_number") %>','<%= t.get("bank_name") %>','<%= t.get("ifsc_code") %>','<%= t.get("upi_id") %>')">
                                            <i class="fas fa-rupee-sign"></i> Pay Salary
                                        </button>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="7" class="empty-row">No teachers found</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="payModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head"><h3><i class="fas fa-rupee-sign"></i> Pay Salary</h3><button onclick="closePayModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/payment/teacher/pay" method="post">
                <input type="hidden" name="teacher_id" id="pay_teacher_id">
                <div class="teacher-pay-info">
                    <div class="pay-info-row"><span>Teacher ID:</span><strong id="pay_display_id"></strong></div>
                    <div class="pay-info-row"><span>Username:</span><strong id="pay_display_username"></strong></div>
                    <div class="pay-info-row"><span>Name:</span><strong id="pay_display_name"></strong></div>
                    <div class="pay-info-row"><span>Monthly Salary:</span><strong id="pay_display_salary"></strong></div>
                    <div class="pay-info-row"><span>Remaining:</span><strong id="pay_display_remaining" class="due-text"></strong></div>
                </div>
                <hr class="pay-divider">
                <div class="bank-details-section">
                    <div class="bank-details-head">
                        <h4><i class="fas fa-university"></i> Bank / UPI Details</h4>
                        <button type="button" class="btn-edit-bank" id="editBankBtn" onclick="toggleEditBank()"><i class="fas fa-edit"></i> Edit</button>
                    </div>
                    <div id="bankViewMode">
                        <div class="bank-info-grid">
                            <div class="bank-info-item"><span>Account Holder</span><p id="view_account_holder"></p></div>
                            <div class="bank-info-item"><span>Account No.</span><p id="view_account_number"></p></div>
                            <div class="bank-info-item"><span>Bank Name</span><p id="view_bank_name"></p></div>
                            <div class="bank-info-item"><span>IFSC Code</span><p id="view_ifsc"></p></div>
                            <div class="bank-info-item"><span>UPI ID</span><p id="view_upi"></p></div>
                        </div>
                    </div>
                    <div id="bankEditMode" style="display:none;">
                        <div class="form-grid">
                            <div class="form-field"><label>Account Holder</label><input type="text" name="account_holder" id="edit_account_holder"></div>
                            <div class="form-field"><label>Account No.</label><input type="text" name="account_number" id="edit_account_number"></div>
                            <div class="form-field"><label>Bank Name</label><input type="text" name="bank_name" id="edit_bank_name"></div>
                            <div class="form-field"><label>IFSC Code</label><input type="text" name="ifsc_code" id="edit_ifsc"></div>
                            <div class="form-field"><label>UPI ID</label><input type="text" name="upi_id" id="edit_upi"></div>
                        </div>
                    </div>
                    <input type="hidden" name="use_edit" id="use_edit" value="false">
                </div>
                <hr class="pay-divider">
                <div class="form-grid">
                    <div class="form-field">
                        <label>Amount to Pay (&#8377;)</label>
                        <input type="number" name="amount" id="pay_amount" min="1" placeholder="Enter amount" required>
                        <small id="pay_amount_hint"></small>
                    </div>
                    <div class="form-field">
                        <label>Payment Mode</label>
                        <select name="payment_mode" required>
                            <option value="">-- Select --</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="UPI">UPI</option>
                            <option value="Cash">Cash</option>
                            <option value="Cheque">Cheque</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Transaction ID <small>(optional)</small></label>
                        <input type="text" name="transaction_id" placeholder="Transaction / UTR ID">
                    </div>
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
function switchTab(tab) {
    document.getElementById("studentTab").style.display = tab === "student" ? "block" : "none";
    document.getElementById("teacherTab").style.display = tab === "teacher" ? "block" : "none";
    document.querySelectorAll(".tab-btn").forEach((b, i) => b.classList.toggle("active", (i === 0 && tab === "student") || (i === 1 && tab === "teacher")));
}
function searchTeacher() {
    let input = document.getElementById("teacherSearch").value.toLowerCase();
    document.querySelectorAll("#teacherPayTable tbody tr").forEach(row => row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none");
}
let isEditBank = false;
function openPayModal(tid, username, name, salary, remaining, accHolder, accNum, bankName, ifsc, upi) {
    document.getElementById("pay_teacher_id").value = tid;
    document.getElementById("pay_display_id").innerText = tid;
    document.getElementById("pay_display_username").innerText = username;
    document.getElementById("pay_display_name").innerText = name;
    document.getElementById("pay_display_salary").innerText = "₹" + salary;
    document.getElementById("pay_display_remaining").innerText = "₹" + remaining;
    document.getElementById("pay_amount").max = remaining;
    document.getElementById("pay_amount_hint").innerText = "Max: ₹" + remaining + " (Monthly Salary: ₹" + salary + ")";
    document.getElementById("view_account_holder").innerText = accHolder || "-";
    document.getElementById("view_account_number").innerText = accNum || "-";
    document.getElementById("view_bank_name").innerText = bankName || "-";
    document.getElementById("view_ifsc").innerText = ifsc || "-";
    document.getElementById("view_upi").innerText = upi || "-";
    document.getElementById("edit_account_holder").value = accHolder || "";
    document.getElementById("edit_account_number").value = accNum || "";
    document.getElementById("edit_bank_name").value = bankName || "";
    document.getElementById("edit_ifsc").value = ifsc || "";
    document.getElementById("edit_upi").value = upi || "";
    document.getElementById("bankViewMode").style.display = "block";
    document.getElementById("bankEditMode").style.display = "none";
    document.getElementById("use_edit").value = "false";
    isEditBank = false;
    document.getElementById("payModal").style.display = "flex";
}
function toggleEditBank() {
    isEditBank = !isEditBank;
    document.getElementById("bankViewMode").style.display = isEditBank ? "none" : "block";
    document.getElementById("bankEditMode").style.display = isEditBank ? "block" : "none";
    document.getElementById("use_edit").value = isEditBank ? "true" : "false";
    document.getElementById("editBankBtn").innerHTML = isEditBank ? '<i class="fas fa-times"></i> Cancel Edit' : '<i class="fas fa-edit"></i> Edit';
}
function closePayModal() { document.getElementById("payModal").style.display = "none"; }
document.addEventListener("keydown", e => { if (e.key === "Escape") closePayModal(); });
</script>
</body>
</html>