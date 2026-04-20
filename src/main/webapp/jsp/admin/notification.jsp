<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications | Student-Teacher Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin/notification.css">
</head>
<body>

<div class="container">
    <div class="header">
        <div class="icon-circle">
            <span>🔔</span>
        </div>
        <h1>Notifications</h1>
        <p>Stay updated with latest announcements</p>
    </div>

    <div class="notification-wrapper">
        <div class="send-notification-box">
            <div class="box-title">
                <span>📨</span>
                <h2>Send Notification</h2>
            </div>
            <form action="#" method="post" id="notificationForm">
                <div class="input-group">
                    <label>📌 Title</label>
                    <input type="text" placeholder="Enter notification title..." name="title" id="titleInput">
                </div>
                <div class="input-group">
                    <label>📝 Message</label>
                    <textarea rows="3" placeholder="Write notification message here..." name="message" id="messageInput"></textarea>
                </div>
                <div class="input-group">
                    <label>🎯 Priority</label>
                    <select id="priorityInput">
                        <option value="high">🔴 High Priority</option>
                        <option value="medium">🟠 Medium Priority</option>
                        <option value="low">🔵 Low Priority</option>
                    </select>
                </div>
                <button type="submit" class="send-btn">
                    <span>📢</span> Send Notification
                </button>
            </form>
        </div>

        <div class="notifications-box">
            <div class="box-title">
                <span>📬</span>
                <h2>All Notifications</h2>
                <span class="badge" id="notifCount">0</span>
                <button class="clear-all" id="clearAllBtn">🗑️ Clear All</button>
            </div>
            <div class="notifications-list" id="notificationsList">
                <div class="empty-msg">
                    <span>🔕</span>
                    <p>No notifications yet. Send your first notification!</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let allNotifications = [];

    function saveNotifs() {
        localStorage.setItem('notificationData', JSON.stringify(allNotifications));
    }

    function loadNotifs() {
        let saved = localStorage.getItem('notificationData');
        if(saved) {
            allNotifications = JSON.parse(saved);
        }
        showNotifications();
    }

    function getPriorityIcon(priority) {
        if(priority === 'high') return '🔴';
        if(priority === 'medium') return '🟠';
        return '🔵';
    }

    function getPriorityClass(priority) {
        if(priority === 'high') return 'priority-high';
        if(priority === 'medium') return 'priority-medium';
        return 'priority-low';
    }

    function formatTime(dateObj) {
        let hours = dateObj.getHours();
        let minutes = dateObj.getMinutes();
        let ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12;
        hours = hours ? hours : 12;
        let mins = minutes < 10 ? '0' + minutes : minutes;
        return hours + ':' + mins + ' ' + ampm;
    }

    function showNotifications() {
        let listDiv = document.getElementById('notificationsList');
        let countSpan = document.getElementById('notifCount');
        
        if(allNotifications.length === 0) {
            listDiv.innerHTML = '<div class="empty-msg"><span>🔕</span><p>No notifications yet. Send your first notification!</p></div>';
            countSpan.innerText = '0';
            return;
        }
        
        countSpan.innerText = allNotifications.length;
        let html = '';
        
        for(let i = 0; i < allNotifications.length; i++) {
            let n = allNotifications[i];
            let dateObj = new Date(n.date);
            let dateStr = dateObj.getDate() + '/' + (dateObj.getMonth()+1) + '/' + dateObj.getFullYear();
            let timeStr = formatTime(dateObj);
            
            html += '<div class="notif-card ' + getPriorityClass(n.priority) + '" data-id="' + n.id + '">';
            html += '<div class="notif-icon">' + getPriorityIcon(n.priority) + '</div>';
            html += '<div class="notif-content">';
            html += '<div class="notif-header">';
            html += '<h3 class="notif-title">' + escapeText(n.title) + '</h3>';
            html += '<button class="delete-notif" onclick="removeNotification(' + n.id + ')">🗑️</button>';
            html += '</div>';
            html += '<p class="notif-message">' + escapeText(n.message) + '</p>';
            html += '<div class="notif-footer">';
            html += '<span class="notif-date">📅 ' + dateStr + ' | 🕐 ' + timeStr + '</span>';
            html += '</div></div></div>';
        }
        
        listDiv.innerHTML = html;
    }
    
    function escapeText(txt) {
        if(!txt) return '';
        return txt.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function addNotification(title, message, priority) {
        if(title.trim() === '') {
            alert('Please enter notification title');
            return false;
        }
        if(message.trim() === '') {
            alert('Please enter notification message');
            return false;
        }
        
        let newNotif = {
            id: Date.now(),
            title: title.trim(),
            message: message.trim(),
            priority: priority,
            date: new Date().toISOString()
        };
        
        allNotifications.unshift(newNotif);
        saveNotifs();
        showNotifications();
        return true;
    }

    function removeNotification(id) {
        if(confirm('Delete this notification?')) {
            let newList = [];
            for(let i = 0; i < allNotifications.length; i++) {
                if(allNotifications[i].id !== id) {
                    newList.push(allNotifications[i]);
                }
            }
            allNotifications = newList;
            saveNotifs();
            showNotifications();
        }
    }

    function clearAllNotifications() {
        if(allNotifications.length === 0) return;
        if(confirm('Delete ALL notifications? This cannot be undone!')) {
            allNotifications = [];
            saveNotifs();
            showNotifications();
        }
    }

    document.getElementById('notificationForm').addEventListener('submit', function(e) {
        e.preventDefault();
        let titleField = document.getElementById('titleInput');
        let msgField = document.getElementById('messageInput');
        let priorityField = document.getElementById('priorityInput');
        
        if(addNotification(titleField.value, msgField.value, priorityField.value)) {
            titleField.value = '';
            msgField.value = '';
            priorityField.value = 'high';
        }
    });

    document.getElementById('clearAllBtn').addEventListener('click', function() {
        clearAllNotifications();
    });

    loadNotifs();
</script>

</body>
</html>