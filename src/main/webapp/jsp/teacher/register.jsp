<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Registration - Gurukul</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/teacher/register.css">
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
                <p class="header-title">Teacher Registration Form</p>
                <p class="header-subtitle">Join our teaching faculty</p>
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
            <form action="<%=request.getContextPath()%>/Teacher/Register" method="post" class="registration-form" enctype="multipart/form-data">
                <!-- Personal Information -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-user-tie"></i>
                        Personal Information
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
                            <input type="text" id="fullname" name="name" 
                                   placeholder="Enter teacher's full name" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i>
                                Email Address <span class="required">*</span>
                            </label>
                            <input type="email" id="email" name="email" 
                                   placeholder="teacher@example.com" required>
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
                            <label for="dob">
                                <i class="fas fa-calendar-alt"></i>
                                Date of Birth <span class="required">*</span>
                            </label>
                            <input type="date" id="dob" name="dob" 
                                   placeholder="Select date of birth" required 
                                   max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>

                        <div class="form-group">
                            <label for="age">
                                <i class="fas fa-birthday-cake"></i>
                                Age <span class="required">*</span>
                            </label>
                            <input type="number" id="age" name="age" 
                                   placeholder="Enter age" min="21" max="70" required>
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
                                <i class="fas fa-mobile-alt"></i>
                                Mobile Number <span class="required">*</span>
                            </label>
                            <input type="tel" id="mobile" name="mobile" 
                                   placeholder="9876543210" pattern="[0-9]{10}" 
                                   title="Please enter 10 digit mobile number" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="photo">
                                <i class="fas fa-camera"></i>
                                Photo
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
                            <label for="qualification">
                                <i class="fas fa-graduation-cap"></i>
                                Qualification <span class="required">*</span>
                            </label>
                            <input type="text" id="qualification" name="qualification" 
                                   placeholder="e.g., M.Sc, B.Ed, Ph.D" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="experience">
                                <i class="fas fa-chart-line"></i>
                                Experience (Years) <span class="required">*</span>
                            </label>
                            <input type="number" id="experience" name="experience" 
                                   placeholder="Total teaching experience" min="0" max="50" required>
                        </div>

                        <div class="form-group">
                            <label for="subject">
                                <i class="fas fa-book"></i>
                                Subject Specialization <span class="required">*</span>
                            </label>
                            <input type="text" id="subject" name="subject" 
                                   placeholder="e.g., Mathematics, Science" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="class_teacher">
                                <i class="fas fa-chalkboard-teacher"></i>
                                Class Teacher Of
                            </label>
                            <select id="class_teacher" name="class_teacher">
                                <option value="1">Class 1</option>
                                <option value="2">Class 2</option>
                                <option value="3">Class 3</option>
                                <option value="4">Class 4</option>
                                <option value="5">Class 5</option>
                                <option value="6">Class 6</option>
                                <option value="7">Class 7</option>
                                <option value="8">Class 8</option>
                                <option value="9">Class 9</option>
                                <option value="10">Class 10</option>
                                <option value="11">Class 11</option>
                                <option value="12">Class 12</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="status">
                                <i class="fas fa-toggle-on"></i>
                                Employment Status <span class="required">*</span>
                            </label>
                            <select id="status" name="status" required>
                                <option value="Active">Active</option>
                                <option value="Resigned">Resigned</option>
                                <option value="Suspended">Suspended</option>
                                <option value="On Leave">On Leave</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="salary">
                                <i class="fas fa-rupee-sign"></i>
                                Monthly Salary <span class="required">*</span>
                            </label>
                            <input type="number" id="salary" name="salary" 
                                   placeholder="Enter monthly salary" min="0" step="1000" required>
                        </div>

                        <div class="form-group">
                            <label for="account_holder">
                                <i class="fas fa-user"></i>
                                Account Holder Name <span class="required">*</span>
                            </label>
                            <input type="text" id="account_holder" name="account_holder" 
                                   placeholder="Name as per bank records" required>
                        </div>
                    </div>
                </div>

                <!-- Bank Details -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-university"></i>
                        Bank Details
                    </h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="account_number">
                                <i class="fas fa-credit-card"></i>
                                Account Number <span class="required">*</span>
                            </label>
                            <input type="text" id="account_number" name="account_number" 
                                   placeholder="Enter account number" pattern="[0-9]{9,18}" 
                                   title="Please enter valid account number" required>
                        </div>

                        <div class="form-group">
                            <label for="bank_name">
                                <i class="fas fa-university"></i>
                                Bank Name <span class="required">*</span>
                            </label>
                            <input type="text" id="bank_name" name="bank_name" 
                                   placeholder="e.g., State Bank of India" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="ifsc_code">
                                <i class="fas fa-code"></i>
                                IFSC Code <span class="required">*</span>
                            </label>
                            <input type="text" id="ifsc_code" name="ifsc_code" 
                                   placeholder="e.g., SBIN0001234" 
                                   pattern="^[A-Z]{4}0[A-Z0-9]{6}$" 
                                   title="Please enter valid IFSC code" required>
                        </div>

                        <div class="form-group">
                            <label for="branch">
                                <i class="fas fa-location-dot"></i>
                                Branch
                            </label>
                            <input type="text" id="branch" name="branch" 
                                   placeholder="Bank branch name">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="pan_number">
                                <i class="fas fa-id-card"></i>
                                PAN Number
                            </label>
                            <input type="text" id="pan_number" name="pan_number" 
                                   placeholder="e.g., ABCDE1234F" 
                                   pattern="^[A-Z]{5}[0-9]{4}[A-Z]{1}$" 
                                   title="Please enter valid PAN number">
                        </div>

                        <div class="form-group">
                            <label for="upi_id">
                                <i class="fas fa-mobile-alt"></i>
                                UPI ID (Optional)
                            </label>
                            <input type="text" id="upi_id" name="upi_id" 
                                   placeholder="e.g., teacher@bank">
                        </div>
                    </div>
                </div>

                <!-- Address Information -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-map-marker-alt"></i>
                        Address Information
                    </h3>
                    
                    <div class="form-group full-width">
                        <label for="address">
                            <i class="fas fa-home"></i>
                            Current Address <span class="required">*</span>
                        </label>
                        <textarea id="address" name="address" rows="2" 
                                  placeholder="Enter current address" required></textarea>
                    </div>

                    <div class="form-checkbox">
                        <label class="checkbox-container">
                            <input type="checkbox" id="same_as_current" name="same_as_current">
                            <span class="checkmark"></span>
                            <span class="checkbox-text">Permanent address same as current address</span>
                        </label>
                    </div>

                    <div class="form-group full-width" id="permanent_address_group">
                        <label for="permanent_address">
                            <i class="fas fa-map-pin"></i>
                            Permanent Address
                        </label>
                        <textarea id="permanent_address" name="permanent_address" rows="2" 
                                  placeholder="Enter permanent address"></textarea>
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
                        Reset Form
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i>
                        Register Teacher
                    </button>
                </div>
            </form>

            <!-- Login Link -->
            <div class="login-link">
                <p>Already have an account? <a href="../login.jsp">Login here</a></p>
            </div>
        </div>
    </div>

    <!-- JavaScript for Same Address Checkbox and File Input -->
    <script>
        // Handle Same as Current Address checkbox
        document.getElementById('same_as_current').addEventListener('change', function(e) {
            const permanentAddressGroup = document.getElementById('permanent_address_group');
            
            if(this.checked) {
                permanentAddressGroup.style.display = 'none';
            } else {
                permanentAddressGroup.style.display = 'block';
            }
        });

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

        // Calculate age from DOB (optional)
        document.getElementById('dob').addEventListener('change', function(e) {
            const dob = new Date(this.value);
            const today = new Date();
            let age = today.getFullYear() - dob.getFullYear();
            const monthDiff = today.getMonth() - dob.getMonth();
            
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
                age--;
            }
            
            const ageField = document.getElementById('age');
            if(age > 0) {
                ageField.value = age;
            }
        });
    </script>
</body>
</html>