<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    request.setAttribute("currentPage", "timetable");
    request.setAttribute("pageTitle", "Timetable");
    String className = (String) request.getAttribute("className");
    String classId   = (String) request.getAttribute("classId");
    String msg       = request.getParameter("msg");
    Map<String,List<Map<String,String>>> timetableByDay = (Map<String,List<Map<String,String>>>) request.getAttribute("timetableByDay");
    List<Map<String,String>> teachers = (List<Map<String,String>>) request.getAttribute("teachers");
    List<Map<String,String>> gridList = (List<Map<String,String>>) request.getAttribute("gridList");
    String[] days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"};
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/topSide.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/admin/timetable.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<div class="layout">
    <jsp:include page="sidebar.jsp" />
    <div class="main">
        <jsp:include page="topbar.jsp" />
        <div class="page-body">
            <% if ("added".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Period added!</div><% } %>
            <% if ("deleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Deleted!</div><% } %>
            <% if ("gridsaved".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Grid timetable saved!</div><% } %>
            <% if ("griddeleted".equals(msg)) { %><div class="alert alert-success"><i class="fas fa-check-circle"></i> Grid timetable deleted!</div><% } %>
            <% if ("error".equals(msg)) { %><div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Something went wrong!</div><% } %>

            <div class="page-container">
                <div class="class-header">
                    <a href="<%=request.getContextPath()%>/admin/timetable" class="back-btn"><i class="fas fa-arrow-left"></i> Back</a>
                    <h2><i class="fas fa-calendar-alt"></i> <%= className != null ? className : "" %> &mdash; Timetable</h2>
                </div>

                <!-- Mode Tabs -->
                <div class="tt-mode-tabs">
                    <button class="tt-mode-btn active" id="btnPeriod" onclick="switchMode('period')">
                        <i class="fas fa-clock"></i> Period Mode
                    </button>
                    <button class="tt-mode-btn" id="btnGrid" onclick="switchMode('grid')">
                        <i class="fas fa-table"></i> Grid Mode
                    </button>
                </div>

                <!-- ===== PERIOD MODE ===== -->
                <div id="periodMode">
                    <div style="display:flex; justify-content:flex-end; margin-bottom:16px;">
                        <button class="add-btn" onclick="openAddModal()"><i class="fas fa-plus"></i> Add Period</button>
                    </div>
                    <% if (timetableByDay != null && !timetableByDay.isEmpty()) { %>
                    <div class="timetable-grid">
                        <% for (String day : days) {
                            List<Map<String,String>> slots = timetableByDay.get(day);
                            if (slots != null && !slots.isEmpty()) { %>
                        <div class="day-card">
                            <div class="day-head"><%= day %></div>
                            <div class="day-body">
                                <% for (Map<String,String> slot : slots) {
                                    String slotId = slot.get("timetable_id") != null ? slot.get("timetable_id") : "0";
                                %>
                                <div class="slot">
                                    <div class="slot-subject"><i class="fas fa-book"></i> <%= slot.get("subject") != null ? slot.get("subject") : "-" %></div>
                                    <div class="slot-teacher"><i class="fas fa-chalkboard-teacher"></i> <%= slot.get("teacher_name") != null ? slot.get("teacher_name") : "No Teacher" %></div>
                                    <div class="slot-time"><i class="fas fa-clock"></i> <%= slot.get("start_time") != null ? slot.get("start_time") : "" %> - <%= slot.get("end_time") != null ? slot.get("end_time") : "" %></div>
                                    <button class="btn-delete-slot" onclick="deleteSlot('<%= slotId %>')"><i class="fas fa-trash"></i></button>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <% } } %>
                    </div>
                    <% } else { %>
                    <div class="empty-state"><i class="fas fa-calendar-times"></i><p>No periods added yet. Click Add Period to start.</p></div>
                    <% } %>
                </div>

                <!-- ===== GRID MODE ===== -->
                <div id="gridMode" style="display:none;">
                    <div class="grid-builder-card">
                        <div class="grid-builder-head">
                            <h3><i class="fas fa-table"></i> Create Grid Timetable</h3>
                        </div>
                        <div class="grid-controls">
                            <div class="grid-ctrl-group">
                                <label>Rows (Days)</label>
                                <input type="number" id="gridRows" value="5" min="1" max="10" onchange="buildGrid()">
                            </div>
                            <div class="grid-ctrl-group">
                                <label>Columns (Periods)</label>
                                <input type="number" id="gridCols" value="7" min="1" max="15" onchange="buildGrid()">
                            </div>
                            <div class="grid-ctrl-group">
                                <label>Grid Name</label>
                                <input type="text" id="gridName" placeholder="e.g. Weekly Timetable">
                            </div>
                            <button class="add-btn" onclick="buildGrid()"><i class="fas fa-sync"></i> Rebuild Grid</button>
                        </div>

                        <div class="grid-instructions">
                            <p><i class="fas fa-info-circle"></i>
                                Click any cell to edit it. Use <strong>Header</strong> toggle to make a cell a header (bold/colored).
                                First row/column are typically headers (Days, Periods).
                            </p>
                        </div>

                        <div class="grid-table-wrap" id="gridTableWrap">
                            <!-- Grid built by JS -->
                        </div>

                        <div class="grid-actions">
                            <button class="btn-save" onclick="saveGrid()"><i class="fas fa-save"></i> Save Grid Timetable</button>
                            <button class="btn-cancel" onclick="clearGrid()"><i class="fas fa-times"></i> Clear All</button>
                        </div>
                    </div>

                    <!-- Saved Grids -->
                    <% if (gridList != null && !gridList.isEmpty()) { %>
                    <div class="saved-grids-section">
                        <h3><i class="fas fa-history"></i> Saved Grid Timetables</h3>
                        <% for (Map<String,String> g : gridList) { %>
                        <div class="saved-grid-card">
                            <div class="saved-grid-head">
                                <h4><i class="fas fa-table"></i> <%= g.get("grid_name") != null ? g.get("grid_name") : "Timetable" %></h4>
                                <div style="display:flex;gap:8px;">
                                    <button class="btn-action view" onclick="viewSavedGrid('<%= g.get("grid_id") %>','<%= g.get("grid_name") != null ? g.get("grid_name").replace("'","\\'") : "" %>')">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <a href="<%=request.getContextPath()%>/admin/timetable/grid/delete?gridId=<%= g.get("grid_id") %>&classId=<%= classId %>&className=<%= className %>" class="btn-action delete">
                                        <i class="fas fa-trash"></i> Delete
                                    </a>
                                </div>
                            </div>
                            <div class="saved-grid-body" id="gridBody_<%= g.get("grid_id") %>" style="display:none;overflow-x:auto;">
                                <!-- Loaded on view click -->
                            </div>
                        </div>
                        <% } %>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Period Modal -->
<div id="addModal" class="modal-overlay" style="display:none;">
    <div class="modal">
        <div class="modal-head">
            <h3><i class="fas fa-plus"></i> Add Period</h3>
            <button onclick="closeAddModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <form action="<%=request.getContextPath()%>/admin/timetable/add" method="post">
                <input type="hidden" name="class_id" value="<%= classId %>">
                <input type="hidden" name="className" value="<%= className != null ? className : "" %>">
                <div class="form-grid">
                    <div class="form-field">
                        <label>Day <span style="color:red">*</span></label>
                        <select name="day" required>
                            <option value="">-- Select Day --</option>
                            <% for (String d : days) { %><option value="<%= d %>"><%= d %></option><% } %>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Subject <span style="color:red">*</span></label>
                        <input type="text" name="subject" placeholder="e.g. Mathematics" required>
                    </div>
                    <div class="form-field">
                        <label>Teacher</label>
                        <select name="teacher_id">
                            <option value="">-- Select Teacher --</option>
                            <% if (teachers != null) { for (Map<String,String> t : teachers) { %>
                            <option value="<%= t.get("teacher_id") %>"><%= t.get("name") %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div class="form-field">
                        <label>Start Time <span style="color:red">*</span></label>
                        <input type="time" name="start_time" required>
                    </div>
                    <div class="form-field">
                        <label>End Time <span style="color:red">*</span></label>
                        <input type="time" name="end_time" required>
                    </div>
                </div>
                <div class="modal-actions">
                    <button type="button" onclick="closeAddModal()" class="btn-cancel">Cancel</button>
                    <button type="submit" class="btn-save"><i class="fas fa-save"></i> Add Period</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Period Modal -->
<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-small">
        <div class="modal-head">
            <h3><i class="fas fa-trash"></i> Delete Period</h3>
            <button onclick="closeDeleteModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <p class="delete-msg">Are you sure you want to delete this period?</p>
            <div class="modal-actions">
                <button onclick="closeDeleteModal()" class="btn-cancel">Cancel</button>
                <a id="deleteSlotBtn" href="#" class="btn-delete"><i class="fas fa-trash"></i> Delete</a>
            </div>
        </div>
    </div>
</div>

<!-- View Grid Modal -->
<div id="viewGridModal" class="modal-overlay" style="display:none;">
    <div class="modal modal-large">
        <div class="modal-head">
            <h3 id="viewGridTitle"><i class="fas fa-table"></i> Grid Timetable</h3>
            <button onclick="closeViewGridModal()" class="modal-close"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="viewGridBody" style="overflow-x:auto;">
            <div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>
        </div>
    </div>
</div>

<!-- Hidden form for saving grid -->
<form id="saveGridForm" action="<%=request.getContextPath()%>/admin/timetable/grid/save" method="post" style="display:none;">
    <input type="hidden" name="class_id" value="<%= classId %>">
    <input type="hidden" name="className" value="<%= className != null ? className : "" %>">
    <input type="hidden" name="grid_name" id="saveGridName">
    <input type="hidden" name="grid_data" id="saveGridData">
</form>

<script>
var ctxPath  = '<%=request.getContextPath()%>';
var classId  = '<%=classId%>';
var className = '<%=className != null ? className.replace("'","\\'") : ""%>';

// ===== MODE SWITCH =====
function switchMode(mode) {
    document.getElementById("periodMode").style.display = mode === "period" ? "block" : "none";
    document.getElementById("gridMode").style.display   = mode === "grid"   ? "block" : "none";
    document.getElementById("btnPeriod").classList.toggle("active", mode === "period");
    document.getElementById("btnGrid").classList.toggle("active", mode === "grid");
    if (mode === "grid" && document.getElementById("gridTableWrap").innerHTML === "") {
        buildGrid();
    }
}

// ===== GRID BUILDER =====
var gridData = [];

function buildGrid() {
    var rows = parseInt(document.getElementById("gridRows").value) || 5;
    var cols = parseInt(document.getElementById("gridCols").value) || 7;

    // Initialize gridData
    gridData = [];
    for (var r = 0; r < rows; r++) {
        gridData[r] = [];
        for (var c = 0; c < cols; c++) {
            gridData[r][c] = { value: "", isHeader: (r === 0 || c === 0) };
        }
    }

    // Default headers - first row
    var defaultColHeaders = ["Days", "Period 1", "Period 2", "Period 3", "Period 4", "Period 5", "Period 6", "Period 7", "Period 8", "Period 9", "Period 10"];
    var defaultRowHeaders = ["", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

    for (var c = 0; c < cols; c++) {
        if (c < defaultColHeaders.length) gridData[0][c].value = defaultColHeaders[c];
    }
    for (var r = 1; r < rows; r++) {
        if (r < defaultRowHeaders.length) gridData[r][0].value = defaultRowHeaders[r];
    }

    renderGrid();
}

function renderGrid() {
    var rows = gridData.length;
    var cols = gridData[0].length;
    var html = '<table class="grid-tt-table">';

    for (var r = 0; r < rows; r++) {
        html += '<tr>';
        for (var c = 0; c < cols; c++) {
            var cell = gridData[r][c];
            var cellClass = cell.isHeader ? "grid-cell header-cell" : "grid-cell";
            html += '<td class="' + cellClass + '" onclick="editCell(' + r + ',' + c + ')" id="cell_' + r + '_' + c + '">';
            html += '<div class="cell-content">' + (cell.value || '<span class="cell-placeholder">Click to edit</span>') + '</div>';
            html += '</td>';
        }
        html += '</tr>';
    }
    html += '</table>';
    document.getElementById("gridTableWrap").innerHTML = html;
}

function editCell(r, c) {
    var cell = gridData[r][c];
    var td   = document.getElementById("cell_" + r + "_" + c);

    td.innerHTML =
        '<div class="cell-edit-wrap">' +
        '<input type="text" class="cell-input" id="cellInput_' + r + '_' + c + '" value="' + cell.value + '" placeholder="Enter value">' +
        '<div class="cell-edit-actions">' +
        '<label class="header-toggle"><input type="checkbox" id="cellHdr_' + r + '_' + c + '" ' + (cell.isHeader ? "checked" : "") + ' onchange="toggleHeader(' + r + ',' + c + ')"> Header</label>' +
        '<button class="cell-ok-btn" onclick="saveCell(' + r + ',' + c + ')">OK</button>' +
        '</div></div>';

    document.getElementById("cellInput_" + r + "_" + c).focus();
    document.getElementById("cellInput_" + r + "_" + c).addEventListener("keydown", function(e) {
        if (e.key === "Enter") saveCell(r, c);
        if (e.key === "Escape") renderGrid();
    });
}

function toggleHeader(r, c) {
    gridData[r][c].isHeader = document.getElementById("cellHdr_" + r + "_" + c).checked;
    var td = document.getElementById("cell_" + r + "_" + c);
    if (gridData[r][c].isHeader) {
        td.classList.add("header-cell");
    } else {
        td.classList.remove("header-cell");
    }
}

function saveCell(r, c) {
    gridData[r][c].value = document.getElementById("cellInput_" + r + "_" + c).value;
    renderGrid();
}

function clearGrid() {
    var rows = gridData.length;
    var cols = gridData[0] ? gridData[0].length : 0;
    for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
            gridData[r][c].value = "";
        }
    }
    renderGrid();
}

function saveGrid() {
    var gridName = document.getElementById("gridName").value.trim();
    if (!gridName) {
        alert("Please enter a grid name before saving!");
        document.getElementById("gridName").focus();
        return;
    }
    if (!gridData.length) {
        alert("Please build the grid first!");
        return;
    }
    document.getElementById("saveGridName").value = gridName;
    document.getElementById("saveGridData").value = JSON.stringify(gridData);
    document.getElementById("saveGridForm").submit();
}

// ===== VIEW SAVED GRID =====
function viewSavedGrid(gridId, gridName) {
    document.getElementById("viewGridTitle").innerHTML = '<i class="fas fa-table"></i> ' + gridName;
    document.getElementById("viewGridBody").innerHTML  = '<div class="loading"><i class="fas fa-spinner fa-spin"></i> Loading...</div>';
    document.getElementById("viewGridModal").style.display = "flex";

    fetch(ctxPath + '/admin/timetable/grid/get?gridId=' + gridId)
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (!data || !data.length) {
                document.getElementById("viewGridBody").innerHTML = '<div class="empty-state"><p>No data found</p></div>';
                return;
            }
            var html = '<table class="grid-tt-table">';
            for (var r = 0; r < data.length; r++) {
                html += '<tr>';
                for (var c = 0; c < data[r].length; c++) {
                    var cell = data[r][c];
                    var tag  = cell.isHeader ? 'th' : 'td';
                    html += '<' + tag + ' class="grid-cell ' + (cell.isHeader ? 'header-cell' : '') + '">' + (cell.value || '') + '</' + tag + '>';
                }
                html += '</tr>';
            }
            html += '</table>';
            document.getElementById("viewGridBody").innerHTML = html;
        })
        .catch(function() {
            document.getElementById("viewGridBody").innerHTML = '<div class="empty-state"><p>Error loading grid</p></div>';
        });
}

function closeViewGridModal() { document.getElementById("viewGridModal").style.display = "none"; }

// ===== PERIOD MODE =====
function openAddModal()    { document.getElementById("addModal").style.display    = "flex"; }
function closeAddModal()   { document.getElementById("addModal").style.display    = "none"; }
function closeDeleteModal(){ document.getElementById("deleteModal").style.display = "none"; }

function deleteSlot(id) {
    document.getElementById("deleteSlotBtn").href =
        ctxPath + '/admin/timetable/delete?id=' + id +
        '&classId=' + classId +
        '&className=' + encodeURIComponent(className);
    document.getElementById("deleteModal").style.display = "flex";
}

document.addEventListener("keydown", function(e) {
    if (e.key === "Escape") { closeAddModal(); closeDeleteModal(); closeViewGridModal(); }
});
</script>
</body>
</html>