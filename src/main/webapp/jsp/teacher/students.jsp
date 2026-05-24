<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "students");
    request.setAttribute("pageTitle", "Students");
    String _selClass = request.getParameter("class_id");
    if (_selClass == null) _selClass = "";
    final String selectedClass = _selClass;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Students</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/teacher/students.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <%@ include file="sidebar.jsp" %>
    <div class="main">
        <%@ include file="topbar.jsp" %>
        <div class="page-body">

            <div class="class-tabs">
                <%
                    List<Map<String,String>> _classes = (List<Map<String,String>>) request.getAttribute("classes");
                    if (_classes != null) {
                        for (Map<String,String> _c : _classes) {
                            boolean _isActive = _c.get("class_id").equals(selectedClass);
                %>
                <a href="<%=request.getContextPath()%>/teacher/students?class_id=<%= _c.get("class_id") %>"
                   class="class-tab <%= _isActive ? "active" : "" %>">
                    <i class="fas fa-chalkboard"></i> <%= _c.get("class_name") %>
                </a>
                <% } } %>
            </div>

            <% if (!selectedClass.isEmpty()) { %>
            <div class="page-card">
                <div class="page-card-head">
                    <h2><i class="fas fa-user-graduate"></i> Students</h2>
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Search students..." onkeyup="searchTable()">
                    </div>
                </div>
                <div class="table-wrap">
                    <table class="data-table" id="studentTable">
                        <thead>
                            <tr>
                                <th>#</th><th>Photo</th><th>Name</th><th>Roll No.</th>
                                <th>Gender</th><th>Fees Paid</th><th>Fees Due</th><th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Map<String,String>> _students = (List<Map<String,String>>) request.getAttribute("students");
                                if (_students != null && !_students.isEmpty()) {
                                    int _i = 1;
                                    for (Map<String,String> _s : _students) {
                                        double _due = 0;
                                        try { _due = Double.parseDouble(_s.get("fees_remaining") != null ? _s.get("fees_remaining") : "0"); } catch(Exception _e2) {}
                                        String _sName    = _s.get("name")              != null ? _s.get("name").replace("'","&#39;")              : "";
                                        String _sUser    = _s.get("username")          != null ? _s.get("username")                              : "";
                                        String _sEmail   = _s.get("email")             != null ? _s.get("email")                                 : "";
                                        String _sMobile  = _s.get("mobile")            != null ? _s.get("mobile")                                : "";
                                        String _sAddr    = _s.get("address")           != null ? _s.get("address").replace("'","&#39;")           : "";
                                        String _sPAddr   = _s.get("permanent_address") != null ? _s.get("permanent_address").replace("'","&#39;") : "";
                                        String _sFather  = _s.get("father_name")       != null ? _s.get("father_name").replace("'","&#39;")       : "";
                                        String _sMother  = _s.get("mother_name")       != null ? _s.get("mother_name").replace("'","&#39;")       : "";
                                        String _sPMobile = _s.get("parents_mobile")    != null ? _s.get("parents_mobile")                        : "";
                                        String _sFOcc    = _s.get("father_occupation") != null ? _s.get("father_occupation").replace("'","&#39;") : "";
                                        String _sMOcc    = _s.get("mother_occupation") != null ? _s.get("mother_occupation").replace("'","&#39;") : "";
                                        String _sIncome  = _s.get("annual_income")     != null ? _s.get("annual_income")                         : "0";
                                        String _sPhoto   = _s.get("photo")             != null ? _s.get("photo")                                 : "";
                                        String _sClass   = _s.get("class_name")        != null ? _s.get("class_name")                            : "";
                                        String _sBG      = _s.get("blood_group")       != null ? _s.get("blood_group")                           : "";
                                        String _sDob     = _s.get("dob")               != null ? _s.get("dob")                                   : "";
                                        String _sGender  = _s.get("gender")            != null ? _s.get("gender")                                : "";
                                        String _sFPaid   = _s.get("fees_paid")         != null ? _s.get("fees_paid")                             : "0";
                                        String _sFDue    = _s.get("fees_remaining")    != null ? _s.get("fees_remaining")                        : "0";
                                        String _sSID     = _s.get("student_id")        != null ? _s.get("student_id")                            : "";
                                        String _sRoll    = _s.get("roll_number")       != null ? _s.get("roll_number")                           : "";
                                        String _sCID     = _s.get("class_id")          != null ? _s.get("class_id")                              : "";
                            %>
                            <tr>
                                <td><%= _i++ %></td>
                                <td>
                                    <% if (_sPhoto != null && !_sPhoto.isEmpty()) { %>
                                    <img src="<%=request.getContextPath()%>/<%= _sPhoto %>" class="student-photo" alt="photo">
                                    <% } else { %>
                                    <div class="student-photo-placeholder"><%= _s.get("name") != null && _s.get("name").length() > 0 ? _s.get("name").charAt(0) : "S" %></div>
                                    <% } %>
                                </td>
                                <td><strong><%= _sName %></strong></td>
                                <td><%= _sRoll %></td>
                                <td><%= _sGender %></td>
                                <td><span class="fees-paid">&#8377;<%= _sFPaid %></span></td>
                                <td><span class="<%= _due > 0 ? "fees-due" : "fees-clear" %>">&#8377;<%= _sFDue %></span></td>
                                <td>
                                    <button class="btn-view" onclick="openViewModal(
                                        '<%= _sSID %>','<%= _sName %>','<%= _sRoll %>',
                                        '<%= _sEmail %>','<%= _sMobile %>','<%= _sDob %>',
                                        '<%= _sGender %>','<%= _sBG %>','<%= _sFather %>',
                                        '<%= _sMother %>','<%= _sPMobile %>','<%= _sFOcc %>',
                                        '<%= _sMOcc %>','<%= _sIncome %>','<%= _sAddr %>',
                                        '<%= _sPAddr %>','<%= _sFPaid %>','<%= _sFDue %>',
                                        '<%= _sPhoto %>','<%= _sClass %>','<%= _sUser %>','<%= _sCID %>'
                                    )"><i class="fas fa-eye"></i> View</button>
                                    <button class="btn-edit" onclick="openEditModal(
                                        '<%= _sSID %>','<%= _sRoll %>','<%= _sName %>',
                                        '<%= _sUser %>','<%= _sEmail %>','<%= _sMobile %>',
                                        '<%= _sAddr %>','<%= _sPAddr %>','<%= _sFather %>',
                                        '<%= _sMother %>','<%= _sPMobile %>','<%= _sFOcc %>',
                                        '<%= _sMOcc %>','<%= _sIncome %>','<%= _sCID %>'
                                    )"><i class="fas fa-edit"></i> Edit</button>
                                </td>
                            </tr>
                            <% } } else { %>
                            <tr><td colspan="8" class="empty-row">No students found in this class</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else { %>
            <div class="select-class-msg">
                <i class="fas fa-hand-point-up"></i>
                <p>Please select a class to view students</p>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- VIEW MODAL -->
<div id="viewModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-lg">
        <div class="modal-head">
            <h3><i class="fas fa-user-graduate"></i> Student Details</h3>
            <button onclick="closeViewModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <div class="modal-profile">
                <div class="modal-photo-wrap">
                    <img id="v_photo" src="" class="modal-photo" style="display:none;" alt="Photo">
                    <div id="v_initials" class="modal-photo-placeholder"></div>
                </div>
                <div>
                    <h2 id="v_name"></h2>
                    <span id="v_class" class="badge-class"></span>
                </div>
            </div>
            <div class="modal-grid">
                <div class="modal-field"><span>Student ID</span><p id="v_sid"></p></div>
                <div class="modal-field"><span>Username</span><p id="v_user"></p></div>
                <div class="modal-field"><span>Roll Number</span><p id="v_roll"></p></div>
                <div class="modal-field"><span>Gender</span><p id="v_gender"></p></div>
                <div class="modal-field"><span>DOB</span><p id="v_dob"></p></div>
                <div class="modal-field"><span>Blood Group</span><p id="v_blood"></p></div>
                <div class="modal-field"><span>Mobile</span><p id="v_mobile"></p></div>
                <div class="modal-field"><span>Email</span><p id="v_email"></p></div>
                <div class="modal-field"><span>Father Name</span><p id="v_father"></p></div>
                <div class="modal-field"><span>Mother Name</span><p id="v_mother"></p></div>
                <div class="modal-field"><span>Parents Mobile</span><p id="v_pmobile"></p></div>
                <div class="modal-field"><span>Father Occupation</span><p id="v_focc"></p></div>
                <div class="modal-field"><span>Mother Occupation</span><p id="v_mocc"></p></div>
                <div class="modal-field"><span>Annual Income</span><p id="v_income"></p></div>
                <div class="modal-field"><span>Address</span><p id="v_addr"></p></div>
                <div class="modal-field"><span>Permanent Address</span><p id="v_paddr"></p></div>
                <div class="modal-field"><span>Fees Paid</span><p id="v_fpaid" class="fees-paid"></p></div>
                <div class="modal-field"><span>Fees Due</span><p id="v_fdue"></p></div>
            </div>
            <div class="modal-actions">
                <button onclick="closeViewModal()" class="btn-cancel">Close</button>
                <button onclick="openEditFromView()" class="btn-edit-modal"><i class="fas fa-edit"></i> Edit</button>
            </div>
        </div>
    </div>
</div>

<!-- EDIT MODAL -->
<div id="editModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-lg">
        <div class="modal-head">
            <h3><i class="fas fa-edit"></i> Edit Student — <span id="e_name_title"></span></h3>
            <button onclick="closeEditModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/teacher/students/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="student_id" id="e_student_id">
                <input type="hidden" name="class_id" value="<%= selectedClass %>">

                <div class="edit-section-title"><i class="fas fa-camera"></i> Profile Photo</div>
                <div class="form-field">
                    <label>Change Photo <small>(optional)</small></label>
                    <input type="file" name="photo" accept="image/*">
                </div>

                <div class="edit-section-title"><i class="fas fa-user"></i> Personal Info</div>
                <div class="modal-grid">
                    <div class="form-field">
                        <label>Full Name</label>
                        <input type="text" name="name" id="e_fullname" required>
                    </div>
                    <div class="form-field">
                        <label>Username</label>
                        <input type="text" name="username" id="e_username" required>
                    </div>
                    <div class="form-field">
                        <label>Roll Number</label>
                        <input type="number" name="roll_number" id="e_roll" required>
                    </div>
                    <div class="form-field">
                        <label>Email</label>
                        <input type="email" name="email" id="e_email">
                    </div>
                    <div class="form-field">
                        <label>Mobile</label>
                        <input type="text" name="mobile" id="e_mobile">
                    </div>
                    <div class="form-field">
                        <label>Change Class <small>(promote/demote student)</small></label>
                        <select name="class_id_new" id="e_class_id">
                            <%
                                List<Map<String,String>> _editClasses = (List<Map<String,String>>) request.getAttribute("classes");
                                if (_editClasses != null) {
                                    for (Map<String,String> _ec : _editClasses) {
                            %>
                            <option value="<%= _ec.get("class_id") %>"><%= _ec.get("class_name") %></option>
                            <% } } %>
                        </select>
                    </div>
                </div>

                <div class="edit-section-title"><i class="fas fa-map-marker-alt"></i> Address</div>
                <div class="modal-grid">
                    <div class="form-field full-span">
                        <label>Current Address</label>
                        <textarea name="temporary_address" id="e_addr" rows="2"></textarea>
                    </div>
                    <div class="form-field full-span">
                        <label>Permanent Address</label>
                        <textarea name="permanent_address" id="e_paddr" rows="2"></textarea>
                    </div>
                </div>

                <div class="edit-section-title"><i class="fas fa-users"></i> Family Info</div>
                <div class="modal-grid">
                    <div class="form-field">
                        <label>Father Name</label>
                        <input type="text" name="father_name" id="e_father">
                    </div>
                    <div class="form-field">
                        <label>Mother Name</label>
                        <input type="text" name="mother_name" id="e_mother">
                    </div>
                    <div class="form-field">
                        <label>Parents Mobile</label>
                        <input type="text" name="parents_mobile" id="e_pmobile">
                    </div>
                    <div class="form-field">
                        <label>Father Occupation</label>
                        <input type="text" name="father_occupation" id="e_focc">
                    </div>
                    <div class="form-field">
                        <label>Mother Occupation</label>
                        <input type="text" name="mother_occupation" id="e_mocc">
                    </div>
                    <div class="form-field">
                        <label>Annual Income</label>
                        <input type="number" name="annual_income" id="e_income">
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

<script>
let currentStudent = {};

function searchTable() {
    let input = document.getElementById("searchInput").value.toLowerCase();
    document.querySelectorAll("#studentTable tbody tr").forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
    });
}

function openViewModal(id, name, roll, email, mobile, dob, gender, blood,
                       father, mother, pmobile, focc, mocc, income,
                       addr, paddr, fpaid, fdue, photo, className, username, cid) {
    currentStudent = {id, name, roll, email, mobile, dob, gender, blood,
                      father, mother, pmobile, focc, mocc, income,
                      addr, paddr, fpaid, fdue, photo, className, username, cid};
    document.getElementById("v_sid").innerText     = id;
    document.getElementById("v_name").innerText    = name;
    document.getElementById("v_class").innerText   = className;
    document.getElementById("v_user").innerText    = username;
    document.getElementById("v_roll").innerText    = roll;
    document.getElementById("v_gender").innerText  = gender;
    document.getElementById("v_dob").innerText     = dob;
    document.getElementById("v_blood").innerText   = blood;
    document.getElementById("v_mobile").innerText  = mobile;
    document.getElementById("v_email").innerText   = email;
    document.getElementById("v_father").innerText  = father;
    document.getElementById("v_mother").innerText  = mother;
    document.getElementById("v_pmobile").innerText = pmobile;
    document.getElementById("v_focc").innerText    = focc;
    document.getElementById("v_mocc").innerText    = mocc;
    document.getElementById("v_income").innerText  = "₹" + income;
    document.getElementById("v_addr").innerText    = addr;
    document.getElementById("v_paddr").innerText   = paddr;
    document.getElementById("v_fpaid").innerText   = "₹" + fpaid;
    let dueEl = document.getElementById("v_fdue");
    dueEl.innerText = "₹" + fdue;
    dueEl.className = parseFloat(fdue) > 0 ? "fees-due" : "fees-clear";
    let photoEl    = document.getElementById("v_photo");
    let initialsEl = document.getElementById("v_initials");
    if (photo && photo.trim() !== "") {
        photoEl.src              = "<%=request.getContextPath()%>/" + photo;
        photoEl.style.display    = "block";
        initialsEl.style.display = "none";
    } else {
        photoEl.style.display    = "none";
        initialsEl.style.display = "flex";
        initialsEl.innerText     = name.charAt(0).toUpperCase();
    }
    document.getElementById("viewModal").style.display = "flex";
}

function closeViewModal() {
    document.getElementById("viewModal").style.display = "none";
}

function openEditFromView() {
    closeViewModal();
    openEditModal(
        currentStudent.id, currentStudent.roll, currentStudent.name,
        currentStudent.username, currentStudent.email, currentStudent.mobile,
        currentStudent.addr, currentStudent.paddr, currentStudent.father,
        currentStudent.mother, currentStudent.pmobile, currentStudent.focc,
        currentStudent.mocc, currentStudent.income, currentStudent.cid
    );
}

function openEditModal(id, roll, name, username, email, mobile,
                       addr, paddr, father, mother, pmobile, focc, mocc, income, cid) {
    document.getElementById("e_student_id").value     = id;
    document.getElementById("e_name_title").innerText = name;
    document.getElementById("e_fullname").value       = name;
    document.getElementById("e_username").value       = username;
    document.getElementById("e_roll").value           = roll;
    document.getElementById("e_email").value          = email;
    document.getElementById("e_mobile").value         = mobile;
    document.getElementById("e_addr").value           = addr;
    document.getElementById("e_paddr").value          = paddr;
    document.getElementById("e_father").value         = father;
    document.getElementById("e_mother").value         = mother;
    document.getElementById("e_pmobile").value        = pmobile;
    document.getElementById("e_focc").value           = focc;
    document.getElementById("e_mocc").value           = mocc;
    document.getElementById("e_income").value         = income;
    // Set class dropdown to student's current class
    let classSelect = document.getElementById("e_class_id");
    if (classSelect) {
        for (let i = 0; i < classSelect.options.length; i++) {
            if (classSelect.options[i].value === String(cid)) {
                classSelect.selectedIndex = i;
                break;
            }
        }
    }
    document.getElementById("editModal").style.display = "flex";
}

function closeEditModal() {
    document.getElementById("editModal").style.display = "none";
}
</script>
</body>
</html>