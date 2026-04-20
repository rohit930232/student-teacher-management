<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Teacher | Admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/edit-teacher.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

<div class="edit-container">
    <div class="edit-card">
        
        <div class="card-header">
            <h1>✏️ Edit Teacher</h1>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/Admin/Teachers" class="back-btn">← Back to List</a>
                <a href="${pageContext.request.contextPath}/Admin/ViewTeacher?username=${teacher.username}" class="view-btn">👁️ View Details</a>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/Admin/UpdateTeacher" method="post">
            <input type="hidden" name="username" value="${teacher.username}">
            
            <div class="two-columns">
                <div class="left-column">
                    <div class="info-section read-only">
                        <h3>📋 Personal Information</h3>
                        <div class="info-row">
                            <span class="info-label">Full Name:</span>
                            <span class="info-value">${teacher.name}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Employee ID:</span>
                            <span class="info-value">${teacher.username}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email:</span>
                            <span class="info-value">${teacher.email}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Mobile No:</span>
                            <span class="info-value">${teacher.mobile}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Age:</span>
                            <span class="info-value">${teacher.age} years</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Gender:</span>
                            <span class="info-value">${teacher.gender}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Qualification:</span>
                            <span class="info-value">${teacher.qualification}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Joining Date:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${teacher.joining_date}" pattern="dd MMM yyyy"/>
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-section read-only">
                        <h3>🏦 Bank Details</h3>
                        <div class="info-row">
                            <span class="info-label">Account Holder:</span>
                            <span class="info-value">${teacher.account_holder}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Account Number:</span>
                            <span class="info-value">${teacher.account_number}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Bank Name:</span>
                            <span class="info-value">${teacher.bank_name}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">IFSC Code:</span>
                            <span class="info-value">${teacher.ifsc_code}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Branch:</span>
                            <span class="info-value">${teacher.branch}</span>
                        </div>
                    </div>
                    
                    <div class="info-section read-only">
                        <h3>📍 Address</h3>
                        <div class="info-row">
                            <span class="info-label">Current Address:</span>
                            <span class="info-value">${teacher.address}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Permanent Address:</span>
                            <span class="info-value">${teacher.permanent_address}</span>
                        </div>
                    </div>
                </div>
                
                <div class="right-column">
                    <div class="info-section editable">
                        <h3>💰 Salary Information</h3>
                        <div class="form-group">
                            <label>Monthly Salary (INR)</label>
                            <input type="number" name="salary" id="monthlySalary" value="${teacher.salary}" step="0.01" required oninput="calculatePaidSalary()">
                        </div>
                        <div class="form-group">
                            <label>Paid Salary This Month (INR)</label>
                            <input type="number" name="paid_salary" id="paidSalary" value="0" step="0.01" oninput="calculateRemainingSalary()">
                        </div>
                        <div class="form-group">
                            <label>Remaining/Unpaid Salary (INR)</label>
                            <input type="number" name="remaining_salary" id="remainingSalary" value="${teacher.remaining_salary}" step="0.01" readonly style="background:#f1f5f9;">
                        </div>
                    </div>
                    <div class="info-section editable">
                        <h3>🏫 Class Teacher (Select Multiple)</h3>
                        <p class="helper-text">💡 You can select multiple classes. Click again to deselect.</p>
                        <div class="subjects-group">
                            <button type="button" class="subject-btn class-btn" data-class="Non Class" onclick="toggleClassTeacher('Non Class')">📌 Non Class</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 1" onclick="toggleClassTeacher('Class 1')">📚 Class 1</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 2" onclick="toggleClassTeacher('Class 2')">📚 Class 2</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 3" onclick="toggleClassTeacher('Class 3')">📚 Class 3</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 4" onclick="toggleClassTeacher('Class 4')">📚 Class 4</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 5" onclick="toggleClassTeacher('Class 5')">📚 Class 5</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 6" onclick="toggleClassTeacher('Class 6')">📚 Class 6</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 7" onclick="toggleClassTeacher('Class 7')">📚 Class 7</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 8" onclick="toggleClassTeacher('Class 8')">📚 Class 8</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 9" onclick="toggleClassTeacher('Class 9')">📚 Class 9</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 10" onclick="toggleClassTeacher('Class 10')">📚 Class 10</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 11" onclick="toggleClassTeacher('Class 11')">📚 Class 11</button>
                            <button type="button" class="subject-btn class-btn" data-class="Class 12" onclick="toggleClassTeacher('Class 12')">📚 Class 12</button>
                        </div>
                        <input type="hidden" name="class_teacher" id="classTeacherValue" value="${teacher.class_teacher}">
                        <div class="selected-subjects" id="selectedClassesDisplay">
                            Selected: ${not empty teacher.class_teacher ? teacher.class_teacher : 'None'}
                        </div>
                    </div>
                    <div class="info-section editable">
                        <h3>📚 Subjects Taught (Select Multiple)</h3>
                        <p class="helper-text">💡 You can select multiple subjects. Click again to deselect.</p>
                        <div class="subjects-group">
                            <button type="button" class="subject-btn" data-subject="Non Taught" onclick="toggleSubject('Non Taught')">📌 Non Taught</button>
                            <button type="button" class="subject-btn" data-subject="Maths" onclick="toggleSubject('Maths')">📐 Maths</button>
                            <button type="button" class="subject-btn" data-subject="Science" onclick="toggleSubject('Science')">🔬 Science</button>
                            <button type="button" class="subject-btn" data-subject="English" onclick="toggleSubject('English')">📖 English</button>
                            <button type="button" class="subject-btn" data-subject="Hindi" onclick="toggleSubject('Hindi')">📕 Hindi</button>
                            <button type="button" class="subject-btn" data-subject="Physics" onclick="toggleSubject('Physics')">⚡ Physics</button>
                            <button type="button" class="subject-btn" data-subject="Chemistry" onclick="toggleSubject('Chemistry')">🧪 Chemistry</button>
                            <button type="button" class="subject-btn" data-subject="Biology" onclick="toggleSubject('Biology')">🧬 Biology</button>
                            <button type="button" class="subject-btn" data-subject="History" onclick="toggleSubject('History')">🏛️ History</button>
                            <button type="button" class="subject-btn" data-subject="Geography" onclick="toggleSubject('Geography')">🌍 Geography</button>
                            <button type="button" class="subject-btn" data-subject="Computer" onclick="toggleSubject('Computer')">💻 Computer</button>
                        </div>
                        <input type="hidden" name="subject" id="subjectsValue" value="${teacher.subject}">
                        <div class="selected-subjects" id="selectedSubjectsDisplay">
                            Selected: ${not empty teacher.subject ? teacher.subject : 'None'}
                        </div>
                    </div>
                    <div class="info-section editable">
                        <h3>⚙️ Status</h3>
                        <div class="subjects-group">
                            <button type="button" class="subject-btn" data-status="Active" onclick="selectStatus('Active')">🟢 Active</button>
                            <button type="button" class="subject-btn" data-status="Inactive" onclick="selectStatus('Inactive')">🔴 Inactive</button>
                            <button type="button" class="subject-btn" data-status="Leave" onclick="selectStatus('Leave')">🌴 On Leave</button>
                        </div>
                        <input type="hidden" name="status" id="statusValue" value="${teacher.status}">
                    </div>
                    <div class="info-section editable">
                        <h3>📅 Experience</h3>
                        <div class="form-group">
                            <label>Years of Experience</label>
                            <input type="number" name="experience" value="${teacher.experience}" step="1">
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="button" class="cancel-btn" onclick="window.location.href='${pageContext.request.contextPath}/Admin/Teachers'">Cancel</button>
                        <button type="submit" class="save-btn">💾 Save Changes</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
function calculatePaidSalary() {
    let monthly = parseFloat(document.getElementById('monthlySalary').value) || 0;
    let paid = parseFloat(document.getElementById('paidSalary').value) || 0;
    let remaining = monthly - paid;
    document.getElementById('remainingSalary').value = remaining < 0 ? 0 : remaining;
}

function calculateRemainingSalary() {
    let monthly = parseFloat(document.getElementById('monthlySalary').value) || 0;
    let paid = parseFloat(document.getElementById('paidSalary').value) || 0;
    let remaining = monthly - paid;
    document.getElementById('remainingSalary').value = remaining < 0 ? 0 : remaining;
}
let selectedClasses = [];

function initClassTeacher() {
    let classValue = document.getElementById('classTeacherValue').value;
    if(classValue && classValue !== 'null' && classValue !== '') {
        if(classValue.includes(' | ')) {
            selectedClasses = classValue.split(' | ');
        } else {
            selectedClasses = [classValue];
        }
    } else {
        selectedClasses = [];
    }
    updateClassDisplay();
    let btns = document.querySelectorAll('.class-btn');
    btns.forEach(btn => {
        let cls = btn.dataset.class;
        if(selectedClasses.includes(cls)) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}

function toggleClassTeacher(className) {
    let index = selectedClasses.indexOf(className);
    if(className === 'Non Class') {
        if(index > -1) {
            selectedClasses = [];
        } else {
            selectedClasses = ['Non Class'];
        }
    } else {
        let nonClassIndex = selectedClasses.indexOf('Non Class');
        if(nonClassIndex > -1) {
            selectedClasses.splice(nonClassIndex, 1);
        }
        
        if(index > -1) {
            selectedClasses.splice(index, 1);
        } else {
            selectedClasses.push(className);
        }
    }
    let btns = document.querySelectorAll('.class-btn');
    btns.forEach(btn => {
        let cls = btn.dataset.class;
        if(selectedClasses.includes(cls)) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    
    updateClassDisplay();
}

function updateClassDisplay() {
    let display = document.getElementById('selectedClassesDisplay');
    let hiddenInput = document.getElementById('classTeacherValue');
    
    let classesStr = selectedClasses.join(' | ');
    display.innerHTML = 'Selected: ' + (classesStr || 'None');
    hiddenInput.value = classesStr;
}
function selectStatus(value) {
    document.getElementById('statusValue').value = value;
    
    let btns = document.querySelectorAll('[data-status]');
    btns.forEach(btn => {
        if(btn.dataset.status === value) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}
let selectedSubjects = [];

function initSubjects() {
    let subjectsValue = document.getElementById('subjectsValue').value;
    if(subjectsValue && subjectsValue !== 'null' && subjectsValue !== '') {
        if(subjectsValue.includes(' | ')) {
            selectedSubjects = subjectsValue.split(' | ');
        } else {
            selectedSubjects = [subjectsValue];
        }
    } else {
        selectedSubjects = [];
    }
    updateSubjectsDisplay();
    let btns = document.querySelectorAll('[data-subject]');
    btns.forEach(btn => {
        let sub = btn.dataset.subject;
        if(selectedSubjects.includes(sub)) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}

function toggleSubject(subject) {
    let index = selectedSubjects.indexOf(subject);
    if(subject === 'Non Taught') {
        if(index > -1) {
            selectedSubjects = [];
        } else {
            selectedSubjects = ['Non Taught'];
        }
    } else {
        let nonTaughtIndex = selectedSubjects.indexOf('Non Taught');
        if(nonTaughtIndex > -1) {
            selectedSubjects.splice(nonTaughtIndex, 1);
        }
        
        if(index > -1) {
            selectedSubjects.splice(index, 1);
        } else {
            selectedSubjects.push(subject);
        }
    }
    let btns = document.querySelectorAll('[data-subject]');
    btns.forEach(btn => {
        let sub = btn.dataset.subject;
        if(selectedSubjects.includes(sub)) {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
    
    updateSubjectsDisplay();
}

function updateSubjectsDisplay() {
    let display = document.getElementById('selectedSubjectsDisplay');
    let hiddenInput = document.getElementById('subjectsValue');
    
    let subjectsStr = selectedSubjects.join(' | ');
    display.innerHTML = 'Selected: ' + (subjectsStr || 'None');
    hiddenInput.value = subjectsStr;
}
initClassTeacher();
initSubjects();
let statusValue = document.getElementById('statusValue').value;
if(statusValue) {
    let btns = document.querySelectorAll('[data-status]');
    btns.forEach(btn => {
        if(btn.dataset.status === statusValue) {
            btn.classList.add('active');
        }
    });
}
</script>

</body>
</html>