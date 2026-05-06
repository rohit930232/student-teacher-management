<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "teachers");
    request.setAttribute("pageTitle", "Teachers");
    String successMsg = request.getParameter("update");
    List<Map<String,String>> teachers = (List<Map<String,String>>) request.getAttribute("teachers");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teachers</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/teachers.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("success".equals(successMsg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Teacher updated successfully!</div><% } %>
            <% if ("error".equals(successMsg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div><% } %>

            <div class="page-container">
                <div class="page-title-row">
                    <h2><i class="fas fa-chalkboard-teacher"></i> All Teachers</h2>
                    <a href="<%=request.getContextPath()%>/jsp/teacher/register.jsp" class="add-btn"><i class="fas fa-plus"></i> Add Teacher</a>
                </div>
                <div class="search-row">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search teacher..." onkeyup="searchTable()">
                    </div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="teacherTable">
                        <thead>
                            <tr>
                                <th>#</th><th>Photo</th><th>Name</th><th>Subject</th>
                                <th>Class</th><th>Status</th><th>Salary</th><th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            if (teachers != null && !teachers.isEmpty()) {
                                int i = 1;
                                for (Map<String,String> t : teachers) {
                                    String tUsername  = t.get("username")   != null ? t.get("username")   : "";
                                    String tName      = t.get("name")       != null ? t.get("name")       : "-";
                                    String tSubject   = t.get("subject")    != null ? t.get("subject")    : "-";
                                    String tClass     = t.get("class_name") != null ? t.get("class_name") : "-";
                                    String tClassId   = t.get("class_id")   != null ? t.get("class_id")   : "";
                                    String tClassTch  = t.get("class_teacher") != null ? t.get("class_teacher") : "";
                                    String tSalary    = t.get("salary")     != null ? t.get("salary")     : "0";
                                    String tRemaining = t.get("remaining_salary") != null ? t.get("remaining_salary") : "0";
                                    String tStatus    = t.get("status")     != null ? t.get("status")     : "Active";
                                    String tPhoto     = t.get("photo")      != null ? t.get("photo")      : "";
                                    String tInit      = tName.length() > 0 ? String.valueOf(tName.charAt(0)).toUpperCase() : "T";
                                    String tStatusCss = tStatus.toLowerCase().replace(" ", "");

                                    // JS me safely pass karne ke liye JSON-safe strings
                                    String jsUsername  = tUsername.replace("\\","\\\\").replace("\"","\\\"");
                                    String jsClassId   = tClassId;
                                    String jsClassTch  = tClassTch.replace("\\","\\\\").replace("\"","\\\"");
                                    String jsSalary    = tSalary;
                                    String jsRemaining = tRemaining;
                                    String jsStatus    = tStatus.replace("\\","\\\\").replace("\"","\\\"");
                                    String jsSubject   = tSubject.replace("\\","\\\\").replace("\"","\\\"");
                                    String jsName      = tName.replace("\\","\\\\").replace("\"","\\\"");
                        %>
                            <tr>
                                <td><%= i++ %></td>
                                <td>
                                    <% if (!tPhoto.isEmpty()) { %>
                                    <img src="<%=request.getContextPath()%>/<%= tPhoto %>" class="teacher-photo" alt="Photo"
                                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                    <div class="photo-placeholder" style="display:none;"><%= tInit %></div>
                                    <% } else { %>
                                    <div class="photo-placeholder"><%= tInit %></div>
                                    <% } %>
                                </td>
                                <td><strong><%= tName %></strong><br><small><%= tUsername %></small></td>
                                <td><span class="subject-badge"><%= tSubject %></span></td>
                                <td><%= tClass %></td>
                                <td><span class="status-badge status-<%= tStatusCss %>"><%= tStatus %></span></td>
                                <td>&#8377;<%= tSalary %></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="btn-action view"
                                            data-username="<%= jsUsername %>"
                                            onclick="viewTeacher(this)">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <button class="btn-action edit"
                                            data-username="<%= jsUsername %>"
                                            data-classid="<%= jsClassId %>"
                                            data-classteacher="<%= jsClassTch %>"
                                            data-salary="<%= jsSalary %>"
                                            data-remaining="<%= jsRemaining %>"
                                            data-status="<%= jsStatus %>"
                                            data-subject="<%= jsSubject %>"
                                            onclick="openEditModal(this)">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="btn-action delete"
                                            data-username="<%= jsUsername %>"
                                            data-name="<%= jsName %>"
                                            onclick="confirmDelete(this)">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="8" class="empty-row"><i class="fas fa-user-slash"></i> No teachers found</td></tr>
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

<!-- View Modal -->
<div id="viewModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-large">
        <div class="modal-head">
            <h3><i class="fas fa-chalkboard-teacher"></i> Teacher Details</h3>
            <button onclick="closeViewModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="viewModalBody">
            <div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-edit"></i> Edit Teacher</h3>
            <button onclick="closeEditModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/Admin/UpdateTeacher" method="post">
                <input type="hidden" name="username" id="edit_username">
                <div class="form-grid">
                    <div class="form-field">
                        <label>Class</label>
                        <select name="class_id" id="edit_class_id">
                            <option value="">-- Select Class --</option>
                            <% for (int c = 1; c <= 12; c++) { %>
                            <option value="<%= c %>">Class <%= c %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Class Teacher Of</label>
                        <select name="class_teacher" id="edit_class_teacher">
                            <option value="">Not a Class Teacher</option>
                            <% for (int c = 1; c <= 12; c++) { %>
                            <option value="Class <%= c %>">Class <%= c %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Subject</label>
                        <input type="text" name="subject" id="edit_subject" placeholder="e.g. Mathematics">
                    </div>
                    <div class="form-field">
                        <label>Status</label>
                        <select name="status" id="edit_status">
                            <option value="Active">Active</option>
                            <option value="Suspended">Suspended</option>
                            <option value="On Leave">On Leave</option>
                            <option value="Resigned">Resigned</option>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Salary (&#8377;)</label>
                        <input type="number" name="salary" id="edit_salary" min="0">
                    </div>
                    <div class="form-field">
                        <label>Remaining Salary (&#8377;)</label>
                        <input type="number" name="remaining_salary" id="edit_remaining" min="0">
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeEditModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head">
            <h3><i class="fas fa-trash"></i> Delete Teacher</h3>
            <button onclick="closeDeleteModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p class="delete-msg">Are you sure you want to delete <strong id="deleteTeacherName"></strong>? This cannot be undone.</p>
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
    document.querySelectorAll("#teacherTable tbody tr").forEach(function(row) {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}

function viewTeacher(btn) {
    var username = btn.getAttribute("data-username");
    document.getElementById("viewModal").style.display = "flex";
    document.getElementById("viewModalBody").innerHTML =
        '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';

    fetch(ctxPath + '/Admin/ViewTeacherDetail?username=' + encodeURIComponent(username))
        .then(function(r) { return r.json(); })
        .then(function(t) {
            var photoHtml = (t.photo && t.photo.trim() !== '')
                ? '<img src="' + ctxPath + '/' + t.photo + '" class="detail-photo" onerror="this.style.display=\'none\'">'
                : '<div class="detail-photo-placeholder">' + (t.name ? t.name.charAt(0).toUpperCase() : 'T') + '</div>';

            document.getElementById("viewModalBody").innerHTML =
                '<div class="detail-top">' + photoHtml +
                '<div class="detail-top-info">' +
                    '<h2>' + (t.name || '-') + '</h2>' +
                    '<p>ID: ' + (t.teacher_id || '-') + ' &nbsp;|&nbsp; ' + (t.subject || '-') + '</p>' +
                    '<span class="status-badge status-' + ((t.status || 'active').toLowerCase().replace(' ','')) + '">' + (t.status || '-') + '</span>' +
                '</div></div>' +
                '<div class="detail-sections">' +
                    '<div class="detail-section">' +
                        '<h4><i class="fas fa-user"></i> Personal Info</h4>' +
                        '<div class="detail-grid">' +
                            '<div class="detail-item"><span>Email</span><p>' + (t.email || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Mobile</span><p>' + (t.mobile || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Gender</span><p>' + (t.gender || '-') + '</p></div>' +
                            '<div class="detail-item"><span>DOB</span><p>' + (t.dob || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Qualification</span><p>' + (t.qualification || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Experience</span><p>' + (t.experience || '-') + ' yrs</p></div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="detail-section">' +
                        '<h4><i class="fas fa-graduation-cap"></i> Employment Info</h4>' +
                        '<div class="detail-grid">' +
                            '<div class="detail-item"><span>Class</span><p>' + (t.class_name || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Class Teacher Of</span><p>' + (t.class_teacher || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Salary</span><p>&#8377;' + (t.salary || '0') + '</p></div>' +
                            '<div class="detail-item"><span>Remaining</span><p>&#8377;' + (t.remaining_salary || '0') + '</p></div>' +
                            '<div class="detail-item"><span>Joining Date</span><p>' + (t.joining_date || '-') + '</p></div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="detail-section">' +
                        '<h4><i class="fas fa-university"></i> Bank Details</h4>' +
                        '<div class="detail-grid">' +
                            '<div class="detail-item"><span>Account Holder</span><p>' + (t.account_holder || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Account No.</span><p>' + (t.account_number || '-') + '</p></div>' +
                            '<div class="detail-item"><span>Bank</span><p>' + (t.bank_name || '-') + '</p></div>' +
                            '<div class="detail-item"><span>IFSC</span><p>' + (t.ifsc_code || '-') + '</p></div>' +
                            '<div class="detail-item"><span>UPI</span><p>' + (t.upi_id || '-') + '</p></div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="detail-section">' +
                        '<h4><i class="fas fa-map-marker-alt"></i> Address</h4>' +
                        '<div class="detail-grid">' +
                            '<div class="detail-item full"><span>Current Address</span><p>' + (t.address || '-') + '</p></div>' +
                            '<div class="detail-item full"><span>Permanent Address</span><p>' + (t.permanent_address || '-') + '</p></div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
        })
        .catch(function(err) {
            document.getElementById("viewModalBody").innerHTML =
                '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>Error loading data. Please try again.</p></div>';
            console.error('ViewTeacher error:', err);
        });
}

function openEditModal(btn) {
    document.getElementById("edit_username").value      = btn.getAttribute("data-username");
    document.getElementById("edit_class_id").value      = btn.getAttribute("data-classid");
    document.getElementById("edit_class_teacher").value = btn.getAttribute("data-classteacher");
    document.getElementById("edit_salary").value        = btn.getAttribute("data-salary");
    document.getElementById("edit_remaining").value     = btn.getAttribute("data-remaining");
    document.getElementById("edit_status").value        = btn.getAttribute("data-status");
    document.getElementById("edit_subject").value       = btn.getAttribute("data-subject");
    document.getElementById("editModal").style.display  = "flex";
}

function confirmDelete(btn) {
    document.getElementById("deleteTeacherName").innerText = btn.getAttribute("data-name");
    document.getElementById("deleteConfirmBtn").href =
        ctxPath + '/Admin/DeleteTeacher?username=' + encodeURIComponent(btn.getAttribute("data-username"));
    document.getElementById("deleteModal").style.display = "flex";
}

function closeViewModal()  { document.getElementById("viewModal").style.display   = "none"; }
function closeEditModal()  { document.getElementById("editModal").style.display   = "none"; }
function closeDeleteModal(){ document.getElementById("deleteModal").style.display = "none"; }

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") { closeViewModal(); closeEditModal(); closeDeleteModal(); }
});
</script>
</body>
</html>