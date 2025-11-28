<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password</title>
    <style>
        /* --- GIỮ NGUYÊN STYLE CŨ --- */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            min-height: 100vh; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
        }

        .card { 
            background: white; 
            padding: 40px; 
            border-radius: 15px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.2); 
            width: 100%; 
            max-width: 450px; 
        }

        h2 { 
            text-align: center; 
            color: #333; 
            margin-bottom: 10px; 
            font-size: 28px;
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .form-group { margin-bottom: 20px; }
        
        label { 
            display: block; 
            margin-bottom: 8px; 
            color: #555; 
            font-weight: 600; 
            font-size: 14px; 
        }
        
        input { 
            width: 100%; 
            padding: 12px 15px; 
            border: 2px solid #eee; 
            border-radius: 8px; 
            font-size: 14px; 
            transition: all 0.3s;
        }
        
        input:focus {
            border-color: #667eea;
            outline: none;
        }

        .btn { 
            width: 100%; 
            padding: 14px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: 600; 
            margin-top: 10px; 
            transition: transform 0.2s;
        }
        
        .btn:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4); 
        }

        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 20px; 
            text-decoration: none; 
            color: #666; 
            font-size: 14px; 
            transition: color 0.3s;
        }
        
        .back-link:hover { color: #667eea; }

        .message { padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; text-align: center; }
        .error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
    </style>
</head>
<body>

    <div class="card">
        <h2>🔒 Change Password</h2>
        <p class="subtitle">Secure your account with a new password</p>
        
        <c:if test="${not empty error}">
            <div class="message error">❌ ${error}</div>
        </c:if>
        <c:if test="${not empty message}">
            <div class="message success">✅ ${message}</div>
        </c:if>
        
        <form action="change-password" method="post">
            <div class="form-group">
                <label>Current Password</label>
                <input type="password" name="currentPassword" placeholder="Enter current password" required>
            </div>
            
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" placeholder="Enter new password" required>
            </div>
            
            <div class="form-group">
                <label>Confirm New Password</label>
                <input type="password" name="confirmPassword" placeholder="Confirm new password" required>
            </div>
            
            <button type="submit" class="btn">Update Password</button>
        </form>
        
        <a href="dashboard" class="back-link">
            ← Back to Dashboard
        </a>
    </div>

</body>
</html>