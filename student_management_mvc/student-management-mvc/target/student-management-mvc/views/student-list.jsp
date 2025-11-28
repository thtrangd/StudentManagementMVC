<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>
    <style>
        /* --- GIỮ NGUYÊN TOÀN BỘ CSS CỦA BẠN --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        /* Chỉnh sửa header một chút để chứa nút Logout/User info */
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
        }

        h1 { color: #333; font-size: 28px; margin: 0; }
        
        .subtitle { color: #666; font-style: italic; margin-top: 5px; display: block;}
        
        /* CSS cho phần thông tin User */
        .user-panel {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        
        .role-badge {
            background-color: #ffc107;
            color: #333;
            padding: 3px 8px;
            border-radius: 10px;
            font-weight: bold;
            font-size: 11px;
            text-transform: uppercase;
        }

        .btn-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            margin-left: 10px;
        }
        .btn-link:hover { text-decoration: underline; }

        .message { padding: 15px; margin-bottom: 20px; border-radius: 5px; font-weight: 500; }
        .success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .btn { display: inline-block; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: 500; transition: all 0.3s; border: none; cursor: pointer; font-size: 14px; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); }
        .btn-secondary { background-color: #6c757d; color: white; padding: 8px 12px; }
        .btn-danger { background-color: #dc3545; color: white; padding: 8px 12px; }
        .btn-danger:hover { background-color: #c82333; }
        
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        thead { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px; }
        tbody tr { transition: background-color 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }
        .actions { display: flex; gap: 10px; }
        .empty-state { text-align: center; padding: 60px 20px; color: #999; }
        .empty-state-icon { font-size: 64px; margin-bottom: 20px; }
        
        /* CSS cho nút Back */
        .btn-back {
            display: inline-block;
            margin-bottom: 15px;
            color: #666;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }
        .btn-back:hover { color: #667eea; }
        
        /* CSS cho thanh search */
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .search-form { display: flex; gap: 10px; }
        .search-input { padding: 8px 10px; border: 1px solid #ddd; border-radius: 5px; width: 200px; }
        .btn-search { background-color: #6c757d; color: white; padding: 8px 15px; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        
        <div class="header-section">
            <div>
                <h1>📚 Student Management</h1>
                <span class="subtitle">MVC Pattern with Jakarta EE & JSTL</span>
            </div>
            
            <div class="user-panel">
                <span>Welcome, <strong>${sessionScope.fullName}</strong></span>
                <span class="role-badge">${sessionScope.role}</span>
                
                <a href="change-password" class="btn-link">Change Password</a>
                
                <a href="logout" class="btn btn-danger" style="margin-left: 10px; padding: 5px 15px;">Logout</a>
            </div>
        </div>
        
        <a href="dashboard" class="btn-back">⬅️ Back to Dashboard</a>
        
        <c:if test="${not empty param.message}">
            <div class="message success">✅ ${param.message}</div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="message error">❌ ${param.error}</div>
        </c:if>
        
        <div class="toolbar">
            <div>
                <c:if test="${sessionScope.role == 'admin'}">
                    <a href="student?action=new" class="btn btn-primary">
                        ➕ Add New Student
                    </a>
                </c:if>
            </div>
            
            <form action="student" method="get" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" class="search-input" placeholder="Search..." value="${searchKeyword}">
                <button type="submit" class="btn-search">🔍</button>
            </form>
        </div>
        
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student Code</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Major</th>
                            
                            <c:if test="${sessionScope.role == 'admin'}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>
                                
                                <c:if test="${sessionScope.role == 'admin'}">
                                    <td>
                                        <div class="actions">
                                            <a href="student?action=edit&id=${student.id}" class="btn btn-secondary">
                                                ✏️ Edit
                                            </a>
                                            <a href="student?action=delete&id=${student.id}" 
                                               class="btn btn-danger"
                                               onclick="return confirm('Are you sure you want to delete this student?')">
                                                🗑️ Delete
                                            </a>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-state-icon">📭</div>
                    <h3>No students found</h3>
                    <c:if test="${sessionScope.role == 'admin'}">
                        <p>Start by adding a new student</p>
                    </c:if>
                    <br>
                    <a href="student?action=list" class="btn-link">View All Students</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>