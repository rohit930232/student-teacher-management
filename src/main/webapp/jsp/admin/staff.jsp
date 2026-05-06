<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "staff");
    request.setAttribute("pageTitle", "Staff");
    String successMsg = request.getParameter("msg");
    List<Map<String,String>> staffList = (List<Map<String,String>>) request.getAttribute("staffList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/staff.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("added".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Staff member added!</div><% } %>
            <% if ("updated".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Staff member updated!</div><% } %>
            <% if ("deleted".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Staff member deleted!</div><% } %>
            <% if ("error".equals(successMsg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div><% } %>

            <div class="page-container">
                <div class="page-title-row">
                    <h2><i class="fas fa-users"></i> All Staff Members</h2>
                    <button class="add-btn" onclick="openAddModal()"><i class="fas fa-plus"></i> Add Staff</button>
                </div>
                <div class="search-row">
                    <div class="search-box"><i class="fas fa-search"></i><input type="text" id="searchInput" placeholder="Search staff..." onkeyup="searchTable()"></div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="staffTable">
                        <thead>
                            <tr><th>#</th><th>Photo</th><th>Name</th><th>Role</th><th>Mobile</th><th>Status</th><th>Salary</th><th>Action</th></tr>
                        </thead>
                        <tbody>
                        <%
                            if (staffList != null && !staffList.isEmpty()) {
                                int i = 1;
                                for (Map<String,String> s : staffList) {
                                    String sid     = s.get("staff_id") != null ? s.get("staff_id") : "0";
                                    String sname   = s.get("name")     != null ? s.get("name")     : "-";
                                    String srole   = s.get("role")     != null ? s.get("role")     : "-";
                                    String smob    = s.get("mobile")   != null ? s.get("mobile")   : "-";
                                    String semail  = s.get("email")    != null ? s.get("email")    : "";
                                    String sstatus = s.get("status")   != null ? s.get("status")   : "Active";
                                    String ssal    = s.get("salary")   != null ? s.get("salary")   : "0";
                                    String saddr   = s.get("address")  != null ? s.get("address").replace("'", "\\'")  : "";
                                    String sphoto  = s.get("photo")    != null ? s.get("photo")    : "";
                                    String sinit   = sname.length() > 0 ? String.valueOf(sname.charAt(0)).toUpperCase() : "S";
                                    String sstatusLower = sstatus.toLowerCase().replace(" ", "");
                        %>
                            <tr>
                                <td><%= i++ %></td>
                                <td>
                                    <% if (!sphoto.isEmpty()) { %>
                                    <img src="<%=request.getContextPath()%>/<%= sphoto %>" class="staff-photo" alt="Photo"
                                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                    <div class="photo-placeholder" style="display:none;"><%= sinit %></div>
                                    <% } else { %>
                                    <div class="photo-placeholder"><%= sinit %></div>
                                    <% } %>
                                </td>
                                <td><strong><%= sname %></strong></td>
                                <td><span class="role-badge"><%= srole %></span></td>
                                <td><%= smob %></td>
                                <td><span class="status-badge status-<%= sstatusLower %>"><%= sstatus %></span></td>
                                <td>&#8377;<%= ssal %></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-action view" onclick="viewStaff(<%= sid %>)"><i class="fas fa-eye"></i> View</button>
                                        <button class="btn-action edit" onclick="openEditModal(<%= sid %>,'<%= sname.replace("'","\\'") %>','<%= srole.replace("'","\\'") %>','<%= smob %>','<%= semail %>','<%= ssal %>','<%= sstatus %>','<%= saddr %>')"><i class="fas fa-edit"></i> Edit</button>
                                        <button class="btn-action delete" onclick="confirmDelete(<%= sid %>,'<%= sname.replace("'","\\'") %>')"><i class="fas fa-trash"></i> Delete</button>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="8" class="empty-row"><i class="fas fa-users-slash"></i> No staff members found</td></tr>
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

<div id="addModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head"><h3><i class="fas fa-plus"></i> Add Staff Member</h3><button onclick="closeAddModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/staff/add" method="post" enctype="multipart/form-data">
                <div class="form-grid">
                    <div class="form-field"><label>Full Name <span style="color:red">*</span></label><input type="text" name="name" placeholder="Enter name" required></div>
                    <div class="form-field"><label>Role / Designation <span style="color:red">*</span></label><input type="text" name="role" placeholder="e.g. Bus Driver, Peon, Guard" required></div>
                    <div class="form-field"><label>Mobile</label><input type="text" name="mobile" placeholder="10 digit mobile"></div>
                    <div class="form-field"><label>Email</label><input type="email" name="email" placeholder="Email address"></div>
                    <div class="form-field"><label>Gender</label>
                        <select name="gender">
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-field"><label>Date of Birth</label><input type="date" name="dob"></div>
                    <div class="form-field"><label>Salary (&#8377;)</label><input type="number" name="salary" placeholder="Monthly salary" min="0"></div>
                    <div class="form-field"><label>Status</label>
                        <select name="status">
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                            <option value="On Leave">On Leave</option>
                        </select>
                    </div>
                    <div class="form-field"><label>Joining Date</label><input type="date" name="joining_date"></div>
                    <div class="form-field"><label>Photo</label><input type="file" name="photo" accept="image/*"></div>
                    <div class="form-field full"><label>Address</label><textarea name="address" rows="2" placeholder="Enter address"></textarea></div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeAddModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Add Staff</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="viewModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head"><h3><i class="fas fa-user"></i> Staff Details</h3><button onclick="closeViewModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body" id="viewModalBody"><div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div></div>
    </div>
</div>

<div id="editModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head"><h3><i class="fas fa-edit"></i> Edit Staff</h3><button onclick="closeEditModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/staff/update" method="post">
                <input type="hidden" name="staff_id" id="edit_staff_id">
                <div class="form-grid">
                    <div class="form-field"><label>Full Name</label><input type="text" name="name" id="edit_name" required></div>
                    <div class="form-field"><label>Role</label><input type="text" name="role" id="edit_role"></div>
                    <div class="form-field"><label>Mobile</label><input type="text" name="mobile" id="edit_mobile"></div>
                    <div class="form-field"><label>Email</label><input type="email" name="email" id="edit_email"></div>
                    <div class="form-field"><label>Salary (&#8377;)</label><input type="number" name="salary" id="edit_salary" min="0"></div>
                    <div class="form-field"><label>Status</label>
                        <select name="status" id="edit_status">
                            <option value="Active">Active</option>
                            <option value="Inactive">Inactive</option>
                            <option value="On Leave">On Leave</option>
                        </select>
                    </div>
                    <div class="form-field full"><label>Address</label><textarea name="address" id="edit_address" rows="2"></textarea></div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeEditModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head"><h3><i class="fas fa-trash"></i> Delete Staff</h3><button onclick="closeDeleteModal()" class="modal-close"><i class="fas fa-times"></i></button></div>
        <div class="modal-body">
            <p class="delete-msg">Are you sure you want to delete <strong id="deleteStaffName"></strong>?</p>
            <div class="modal-actions">
                <button onclick="closeDeleteModal()" class="btn-cancel">Cancel</button>
                <a id="deleteConfirmBtn" href="#" class="btn-delete"><i class="fas fa-trash"></i> Delete</a>
            </div>
        </div>
    </div>
</div>

<script>
var ctxPath = '<%=request.getContextPath()%>';

function searchTable() {
    var input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#staffTable tbody tr").forEach(function(row) {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}

function openAddModal()   { document.getElementById("addModal").style.display    = "flex"; }
function closeAddModal()  { document.getElementById("addModal").style.display    = "none"; }
function closeViewModal() { document.getElementById("viewModal").style.display   = "none"; }
function closeEditModal() { document.getElementById("editModal").style.display   = "none"; }
function closeDeleteModal(){ document.getElementById("deleteModal").style.display = "none"; }

function viewStaff(id) {
    document.getElementById("viewModal").style.display = "flex";
    document.getElementById("viewModalBody").innerHTML = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

    fetch(ctxPath + '/admin/staff/detail?id=' + id)
        .then(function(r) { return r.json(); })
        .then(function(s) {
            var photoHtml = '';
            if (s.photo && s.photo.trim() !== '') {
                photoHtml = '<img src="' + ctxPath + '/' + s.photo + '" class="detail-photo" onerror="this.style.display=\'none\'">';
            } else {
                photoHtml = '<div class="detail-photo-placeholder">' + (s.name ? s.name.charAt(0).toUpperCase() : 'S') + '</div>';
            }

            document.getElementById("viewModalBody").innerHTML =
                '<div class="detail-top">' + photoHtml +
                '<div class="detail-top-info"><h2>' + (s.name || '-') + '</h2><p>' + (s.role || '-') + '</p></div></div>' +
                '<div class="detail-sections"><div class="detail-section">' +
                '<h4><i class="fas fa-user"></i> Info</h4>' +
                '<div class="detail-grid">' +
                '<div class="detail-item"><span>Mobile</span><p>' + (s.mobile || '-') + '</p></div>' +
                '<div class="detail-item"><span>Email</span><p>' + (s.email || '-') + '</p></div>' +
                '<div class="detail-item"><span>Gender</span><p>' + (s.gender || '-') + '</p></div>' +
                '<div class="detail-item"><span>DOB</span><p>' + (s.dob || '-') + '</p></div>' +
                '<div class="detail-item"><span>Salary</span><p>&#8377;' + (s.salary || '0') + '</p></div>' +
                '<div class="detail-item"><span>Status</span><p>' + (s.status || '-') + '</p></div>' +
                '<div class="detail-item"><span>Joining Date</span><p>' + (s.joining_date || '-') + '</p></div>' +
                '<div class="detail-item full"><span>Address</span><p>' + (s.address || '-') + '</p></div>' +
                '</div></div></div>';
        })
        .catch(function(err) {
            document.getElementById("viewModalBody").innerHTML = '<div class="empty-state"><p>Error loading data</p></div>';
            console.error(err);
        });
}

function openEditModal(id, name, role, mobile, email, salary, status, address) {
    document.getElementById("edit_staff_id").value = id;
    document.getElementById("edit_name").value     = name;
    document.getElementById("edit_role").value     = role;
    document.getElementById("edit_mobile").value   = mobile;
    document.getElementById("edit_email").value    = email;
    document.getElementById("edit_salary").value   = salary;
    document.getElementById("edit_status").value   = status;
    document.getElementById("edit_address").value  = address;
    document.getElementById("editModal").style.display = "flex";
}

function confirmDelete(id, name) {
    document.getElementById("deleteStaffName").innerText = name;
    document.getElementById("deleteConfirmBtn").href = ctxPath + '/admin/staff/delete?id=' + id;
    document.getElementById("deleteModal").style.display = "flex";
}

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") {
        closeAddModal(); closeViewModal(); closeEditModal(); closeDeleteModal();
    }
});
</script>
</body>
</html>