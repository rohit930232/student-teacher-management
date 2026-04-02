<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration - Gurukul</title>
   <link rel="stylesheet" href="<%=request.getContextPath() %>/css/admin/register.css">
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
        <div class="registration-card">
            <!-- Header with Logo -->
            <div class="header-gradient">
                <div class="logo-container">
                    <img src="<%=request.getContextPath() %>/images/logo.png" alt="Gurukul Logo" class="logo">
                </div>
                <h1 class="school-name">Gurukul</h1>
                <p class="header-title">Admin Registration</p>
                <p class="header-subtitle">Create administrator account</p>
            </div>

            <!-- Message Display -->
            <%
                String message = request.getParameter("message");
                String error = request.getParameter("error");
                if(message != null && !message.isEmpty()) {
            %>
                <div class="alert success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= message %></span>
                </div>
            <%
                } else if(error != null && !error.isEmpty()) {
            %>
                <div class="alert error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= error %></span>
                </div>
            <%
                }
            %>

            <!-- Registration Form -->
            <form action="<%=request.getContextPath()%>/Admin/Register" method="post" class="registration-form" enctype="multipart/form-data">
                <!-- Admin Information -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-user-shield"></i>
                        Admin Details
                    </h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username">
                                <i class="fas fa-user"></i>
                                Username <span class="required">*</span>
                            </label>
                            <input type="text" id="username" name="username" 
                                   placeholder="Choose a username" required>
                        </div>

                        <div class="form-group">
                            <label for="fullname">
                                <i class="fas fa-signature"></i>
                                Full Name <span class="required">*</span>
                            </label>
                            <input type="text" id="fullname" name="fullname" 
                                   placeholder="Enter admin's full name" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i>
                                Email Address <span class="required">*</span>
                            </label>
                            <input type="email" id="email" name="email" 
                                   placeholder="admin@example.com" required>
                        </div>

                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i>
                                Password <span class="required">*</span>
                            </label>
                            <div class="password-wrapper">
                                <input type="password" id="password" name="password" 
                                       placeholder="Create password" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="confirm_password">
                                <i class="fas fa-lock"></i>
                                Confirm Password <span class="required">*</span>
                            </label>
                            <div class="password-wrapper">
                                <input type="password" id="confirm_password" name="confirm_password" 
                                       placeholder="Re-enter password" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="dob">
                                <i class="fas fa-calendar-alt"></i>
                                Date of Birth <span class="required">*</span>
                            </label>
                            <input type="date" id="dob" name="dob" 
                                   placeholder="Select date of birth" required 
                                   max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="gender">
                                <i class="fas fa-venus-mars"></i>
                                Gender <span class="required">*</span>
                            </label>
                            <select id="gender" name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="mobile">
                                <i class="fas fa-phone-alt"></i>
                                Mobile Number (Optional)
                            </label>
                            <input type="tel" id="mobile" name="mobile" 
                                   placeholder="9876543210" pattern="[0-9]{10}" 
                                   title="Please enter 10 digit mobile number">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="photo">
                                <i class="fas fa-camera"></i>
                                Profile Photo
                            </label>
                            <div class="file-input-wrapper">
                                <input type="file" id="photo" name="photo" accept="image/*">
                                <label for="photo" class="file-label">
                                    <i class="fas fa-upload"></i>
                                    Choose Photo
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="address">
                                <i class="fas fa-map-marker-alt"></i>
                                Address (Optional)
                            </label>
                            <input type="text" id="address" name="address" 
                                   placeholder="Enter address">
                        </div>
                    </div>
                </div>

                <!-- Terms and Conditions -->
                <div class="terms-section">
                    <label class="checkbox-container">
                        <input type="checkbox" name="terms" required>
                        <span class="checkmark"></span>
                        <span class="terms-text">I confirm that all information provided is correct and I agree to the <a href="#">Terms and Conditions</a> and <a href="#">Privacy Policy</a></span>
                    </label>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-redo-alt"></i>
                        Reset
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i>
                        Register Admin
                    </button>
                </div>
            </form>

            <!-- Login Link -->
            <div class="login-link">
                <p>Already have an account? <a href="../login.jsp">Login here</a></p>
            </div>
        </div>
    </div>

    <!-- JavaScript for File Input and Password Match -->
    <script>
        // File input display
        document.getElementById('photo').addEventListener('change', function(e) {
            const fileName = e.target.files[0]?.name;
            const fileLabel = document.querySelector('.file-label');
            if(fileName) {
                fileLabel.innerHTML = '<i class="fas fa-check"></i> ' + fileName;
            } else {
                fileLabel.innerHTML = '<i class="fas fa-upload"></i> Choose Photo';
            }
        });

        // Password match validation
        document.getElementById('confirm_password').addEventListener('input', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if(password !== confirmPassword) {
                this.setCustomValidity('Passwords do not match');
            } else {
                this.setCustomValidity('');
            }
        });

        document.getElementById('password').addEventListener('input', function(e) {
            const confirmPassword = document.getElementById('confirm_password').value;
            if(confirmPassword && this.value !== confirmPassword) {
                document.getElementById('confirm_password').setCustomValidity('Passwords do not match');
            } else {
                document.getElementById('confirm_password').setCustomValidity('');
            }
        });

        // Optional: Auto-calculate age from DOB if needed
        document.getElementById('dob').addEventListener('change', function(e) {
            const dob = new Date(this.value);
            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDiff = today.getMonth() - dob.getMonth();
            
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                age--;
            }
            
            console.log("Admin age: " + age); // You can display this if needed
        });
    </script>
</body>
</html>