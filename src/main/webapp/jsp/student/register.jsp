<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration - Gurukul</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/student/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="animated-bg">
        <div class="bg-shape shape1"></div>
        <div class="bg-shape shape2"></div>
        <div class="bg-shape shape3"></div>
        <div class="bg-shape shape4"></div>
    </div>

    <div class="container">
        <div class="registration-card">
            <div class="header-gradient">
                <div class="logo-container">
                    <img src="<%=request.getContextPath() %>/images/logo.png" alt="Gurukul Logo" class="logo">
                </div>
                <h1 class="school-name">Gurukul</h1>
                <p class="header-title">Student Enrollment Form</p>
                <p class="header-subtitle">Complete all details for admission</p>
            </div>
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
            <form action="<%=request.getContextPath()%>/Student/Register" method="post" class="registration-form" enctype="multipart/form-data">
                <!-- Student Personal Information -->
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-user-graduate"></i>
                        Student Personal Details
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
                                   placeholder="Enter student's full name" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i>
                                Email Address <span class="required">*</span>
                            </label>
                            <input type="email" id="email" name="email" 
                                   placeholder="student@example.com" required>
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
                            <label for="blood_group">
                                <i class="fas fa-tint"></i>
                                Blood Group <span class="required">*</span>
                            </label>
                            <select id="blood_group" name="blood_group" required>
                                <option value="">Select Blood Group</option>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="student_mobile">
                                <i class="fas fa-mobile-alt"></i>
                                Student's Mobile <span class="required">*</span>
                            </label>
                            <input type="tel" id="student_mobile" name="student_mobile" 
                                   placeholder="Enter 10 digit mobile number" 
                                   pattern="[0-9]{10}" 
                                   title="Please enter 10 digit mobile number" 
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="gender">
                                <i class="fas fa-venus-mars"></i>
                                Gender
                            </label>
                            <select id="gender" name="gender">
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="roll_number">
                                <i class="fas fa-hashtag"></i>
                                Roll Number
                            </label>
                            <input type="number" id="roll_number" name="roll_number" 
                                   placeholder="Enter roll number">
                        </div>

                        <div class="form-group">
                            <label for="class_id">
                                <i class="fas fa-chalkboard-teacher"></i>
                                Class <span class="required">*</span>
                            </label>
                            <select id="class_id" name="class_id" required>
                                <option value="">Select Class</option>
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
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="photo">
                                <i class="fas fa-camera"></i>
                                Student Photo
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
                            <label for="alternate_mobile">
                                <i class="fas fa-phone"></i>
                                Alternate Mobile (Optional)
                            </label>
                            <input type="tel" id="alternate_mobile" name="alternate_mobile" 
                                   placeholder="Alternate contact number" pattern="[0-9]{10}">
                        </div>
                    </div>
                </div>
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-users"></i>
                        Parents / Guardian Details
                    </h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="father_name">
                                <i class="fas fa-male"></i>
                                Father's Name <span class="required">*</span>
                            </label>
                            <input type="text" id="father_name" name="father_name" 
                                   placeholder="Enter father's name" required>
                        </div>

                        <div class="form-group">
                            <label for="mother_name">
                                <i class="fas fa-female"></i>
                                Mother's Name <span class="required">*</span>
                            </label>
                            <input type="text" id="mother_name" name="mother_name" 
                                   placeholder="Enter mother's name" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="parents_mobile">
                                <i class="fas fa-phone-alt"></i>
                                Parents' Mobile <span class="required">*</span>
                            </label>
                            <input type="tel" id="parents_mobile" name="parents_mobile" 
                                   placeholder="9876543210" pattern="[0-9]{10}" 
                                   title="Please enter 10 digit mobile number" required>
                        </div>

                        <div class="form-group">
                            <label for="father_occupation">
                                <i class="fas fa-briefcase"></i>
                                Father's Occupation
                            </label>
                            <input type="text" id="father_occupation" name="father_occupation" 
                                   placeholder="e.g., Business, Teacher, etc.">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="mother_occupation">
                                <i class="fas fa-briefcase"></i>
                                Mother's Occupation
                            </label>
                            <input type="text" id="mother_occupation" name="mother_occupation" 
                                   placeholder="e.g., Homemaker, Doctor, etc.">
                        </div>

                        <div class="form-group">
                            <label for="annual_income">
                                <i class="fas fa-rupee-sign"></i>
                                Annual Income
                            </label>
                            <input type="number" id="annual_income" name="annual_income" 
                                   placeholder="Approx. annual income" min="0">
                        </div>
                    </div>
                </div>
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-map-marker-alt"></i>
                        Permanent Address
                    </h3>
                    
                    <div class="form-group full-width">
                        <label for="permanent_address">
                            <i class="fas fa-home"></i>
                            Complete Permanent Address <span class="required">*</span>
                        </label>
                        <textarea id="permanent_address" name="permanent_address" rows="3" 
                                  placeholder="House No., Street, City, District, State - PIN Code" required></textarea>
                    </div>
                </div>
                <div class="form-section">
                    <h3 class="section-title">
                        <i class="fas fa-map-pin"></i>
                        Temporary/Correspondence Address
                    </h3>
                    
                    <div class="form-checkbox">
                        <label class="checkbox-container">
                            <input type="checkbox" id="same_as_permanent" name="same_as_permanent">
                            <span class="checkmark"></span>
                            <span class="checkbox-text">Same as Permanent Address</span>
                        </label>
                    </div>
                    
                    <div class="form-group full-width" id="temporary_address_group">
                        <label for="temporary_address">
                            <i class="fas fa-location-dot"></i>
                            Temporary Address
                        </label>
                        <textarea id="temporary_address" name="temporary_address" rows="3" 
                                  placeholder="Enter temporary address if different from permanent"></textarea>
                    </div>
                </div>
                <div class="terms-section">
                    <label class="checkbox-container">
                        <input type="checkbox" name="terms" required>
                        <span class="checkmark"></span>
                        <span class="terms-text">I confirm that all information provided is correct and I agree to the <a href="#">Terms and Conditions</a> and <a href="#">Privacy Policy</a></span>
                    </label>
                </div>
                <div class="form-actions">
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-redo-alt"></i>
                        Reset Form
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i>
                        Register Student
                    </button>
                </div>
            </form>
            <div class="login-link">
                <p>Already have an account? <a href="../login.jsp">Login here</a></p>
            </div>
        </div>
    </div>
    <script>
        // Handle Same as Permanent Address checkbox
        document.getElementById('same_as_permanent').addEventListener('change', function(e) {
            const temporaryAddressGroup = document.getElementById('temporary_address_group');
            
            if(this.checked) {
                temporaryAddressGroup.style.display = 'none';
            } else {
                temporaryAddressGroup.style.display = 'block';
            }
        });
        document.getElementById('photo').addEventListener('change', function(e) {
            const fileName = e.target.files[0]?.name;
            const fileLabel = document.querySelector('.file-label');
            if(fileName) {
                fileLabel.innerHTML = '<i class="fas fa-check"></i> ' + fileName;
            } else {
                fileLabel.innerHTML = '<i class="fas fa-upload"></i> Choose Photo';
            }
        });
    </script>
</body>
</html>