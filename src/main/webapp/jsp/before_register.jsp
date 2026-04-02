<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Your Role - Gurukul</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/before_register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- Animated Background -->
    <div class="animated-bg">
        <div class="bg-shape shape1"></div>
        <div class="bg-shape shape2"></div>
        <div class="bg-shape shape3"></div>
        <div class="bg-shape shape4"></div>
    </div>

    <div class="container">
        <div class="role-card">
            <!-- Logo -->
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="Gurukul Logo" class="logo" onerror="this.src='https://via.placeholder.com/100'">
                <h1 class="school-name">Gurukul</h1>
            </div>
            
            <h2 class="title">Welcome to Gurukul</h2>
            
            <p class="subtitle">Please select your role to continue</p>
            
            <p class="description">
                Select your role to access the appropriate registration form and dashboard features.
            </p>

            <!-- Role Selection - No form, just JavaScript -->
            <div class="role-options">
                <!-- Student Card -->
                <div class="role-card-option" onclick="selectRole('student')">
                    <div class="role-label">
                        <div class="role-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <h3>Student</h3>
                        <p>Access courses, assignments, and track your academic progress</p>
                    </div>
                </div>

                <!-- Teacher Card -->
                <div class="role-card-option" onclick="selectRole('teacher')">
                    <div class="role-label">
                        <div class="role-icon">
                            <i class="fas fa-chalkboard-teacher"></i>
                        </div>
                        <h3>Teacher</h3>
                        <p>Manage classes, create assignments, and track student performance</p>
                    </div>
                </div>

                <!-- Admin Card -->
                <div class="role-card-option" onclick="selectRole('admin')">
                    <div class="role-label">
                        <div class="role-icon">
                            <i class="fas fa-user-tie"></i>
                        </div>
                        <h3>Admin</h3>
                        <p>Manage school operations, teachers, students, and overall system</p>
                    </div>
                </div>
            </div>

            <!-- Continue Button -->
            <div class="form-actions">
                <button class="continue-btn" id="continueBtn" onclick="redirectToSelectedRole()" style="opacity:0.5; pointer-events:none;">
                    <span>Please select a role</span>
                    <i class="fas fa-arrow-right"></i>
                </button>
            </div>

            <!-- Login Link -->
            <div class="login-link">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/jsp/login.jsp">Log in</a></p>
            </div>
        </div>
    </div>

    <script>
        // Get context path from JSP
        const contextPath = '${pageContext.request.contextPath}';
        let selectedRole = null;

        // Function to select role
        function selectRole(role) {
            selectedRole = role;
            
            // Remove selected class from all cards
            document.querySelectorAll('.role-card-option').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to clicked card
            event.currentTarget.classList.add('selected');
            
            // Enable continue button and update text
            const continueBtn = document.getElementById('continueBtn');
            continueBtn.style.opacity = '1';
            continueBtn.style.pointerEvents = 'auto';
            
            // Update button text based on role
            const roleNames = {
                'student': 'Student',
                'teacher': 'Teacher',
                'admin': 'Admin'
            };
            
            continueBtn.innerHTML = '<span>Continue as ' + roleNames[role] + '</span> <i class="fas fa-arrow-right"></i>';
        }

        // Function to redirect based on selected role
        function redirectToSelectedRole() {
            if (!selectedRole) {
                alert('Please select a role first');
                return;
            }
            
            // Show loading state
            const continueBtn = document.getElementById('continueBtn');
            continueBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Redirecting...';
            continueBtn.style.pointerEvents = 'none';
            
            // Define redirect URLs
            let redirectUrl = '';
            
            if (selectedRole === 'student') {
                redirectUrl = contextPath + '/jsp/student/register.jsp';
            } else if (selectedRole === 'teacher') {
                redirectUrl = contextPath + '/jsp/teacher/register.jsp';
            } else if (selectedRole === 'admin') {
                redirectUrl = contextPath + '/jsp/admin/register.jsp';
            }
            
            // Log for debugging
            console.log('Redirecting to: ' + redirectUrl);
            
            // Redirect after a small delay
            setTimeout(function() {
                window.location.href = redirectUrl;
            }, 500);
        }

        // Keyboard support - Enter key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && selectedRole) {
                redirectToSelectedRole();
            }
        });

        // Log context path for debugging
        console.log('Context Path: ' + contextPath);
    </script>
</body>
</html>