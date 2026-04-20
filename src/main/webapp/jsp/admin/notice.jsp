<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notice Board | Student-Teacher Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin/notice.css">
</head>
<body>

<div class="container">
    <div class="header">
        <div class="icon-circle">
            <span>📢</span>
        </div>
        <h1>Notice Board</h1>
        <p>Student - Teacher Management System</p>
    </div>

    <div class="notice-wrapper">
        <div class="add-notice-box">
            <div class="box-title">
                <span>✏️</span>
                <h2>Add New Notice</h2>
            </div>
            <form action="#" method="post" id="noticeForm">
                <textarea rows="4" placeholder="Write your important notice here..." name="notice" id="noticeInput"></textarea>
                <button type="submit" class="publish-btn">
                    <span>📌</span> Publish Notice
                </button>
            </form>
        </div>

        <div class="notices-box">
            <div class="box-title">
                <span>📋</span>
                <h2>All Notices</h2>
                <span class="badge" id="noticeCount">0</span>
            </div>
            <div class="notices-list" id="noticesList">
                <div class="empty-msg">
                    <span>📭</span>
                    <p>No notices yet. Add your first notice!</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let allNotices = [];

    function saveToStorage() {
        localStorage.setItem('noticeData', JSON.stringify(allNotices));
    }

    function loadFromStorage() {
        let saved = localStorage.getItem('noticeData');
        if(saved) {
            allNotices = JSON.parse(saved);
        }
        showNotices();
    }

    function showNotices() {
        let listDiv = document.getElementById('noticesList');
        let countSpan = document.getElementById('noticeCount');
        
        if(allNotices.length === 0) {
            listDiv.innerHTML = '<div class="empty-msg"><span>📭</span><p>No notices yet. Add your first notice!</p></div>';
            countSpan.innerText = '0';
            return;
        }
        
        countSpan.innerText = allNotices.length;
        let html = '';
        
        for(let i = 0; i < allNotices.length; i++) {
            let n = allNotices[i];
            let dateObj = new Date(n.date);
            let dateStr = dateObj.getDate() + '/' + (dateObj.getMonth()+1) + '/' + dateObj.getFullYear() + ' ' + dateObj.getHours() + ':' + (dateObj.getMinutes()<10?'0':'') + dateObj.getMinutes();
            
            html += '<div class="notice-card" data-id="' + n.id + '">';
            html += '<div class="notice-icon'>📄</div>';
            html += '<div class="notice-content">';
            html += '<p class="notice-text">' + escapeText(n.text) + '</p>';
            html += '<div class="notice-footer">';
            html += '<span class="date-badge">📅 ' + dateStr + '</span>';
            html += '<button class="delete-btn" onclick="removeNotice(' + n.id + ')">🗑️ Delete</button>';
            html += '</div></div></div>';
        }
        
        listDiv.innerHTML = html;
    }
    
    function escapeText(txt) {
        return txt.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function addNewNotice(text) {
        if(text.trim() === '') {
            alert('Please enter notice text');
            return false;
        }
        
        let newNotice = {
            id: Date.now(),
            text: text.trim(),
            date: new Date().toISOString()
        };
        
        allNotices.unshift(newNotice);
        saveToStorage();
        showNotices();
        return true;
    }

    function removeNotice(id) {
        if(confirm('Delete this notice?')) {
            let newList = [];
            for(let i = 0; i < allNotices.length; i++) {
                if(allNotices[i].id !== id) {
                    newList.push(allNotices[i]);
                }
            }
            allNotices = newList;
            saveToStorage();
            showNotices();
        }
    }

    document.getElementById('noticeForm').addEventListener('submit', function(e) {
        e.preventDefault();
        let inputField = document.getElementById('noticeInput');
        if(addNewNotice(inputField.value)) {
            inputField.value = '';
        }
    });

    loadFromStorage();
</script>

</body>
</html>