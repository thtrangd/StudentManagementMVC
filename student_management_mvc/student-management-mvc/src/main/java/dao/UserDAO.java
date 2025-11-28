package dao;

import model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;

public class UserDAO {
    
    // 1. Cấu hình Database (Đã điền đúng pass của bạn)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Abcd@123"; 
    
    // 2. Các câu lệnh SQL
    private static final String SQL_AUTHENTICATE = 
        "SELECT * FROM users WHERE username = ? AND is_active = TRUE";
    
    private static final String SQL_UPDATE_LAST_LOGIN = 
        "UPDATE users SET last_login = NOW() WHERE id = ?";
    
    private static final String SQL_GET_BY_ID = 
        "SELECT * FROM users WHERE id = ?";
        
    private static final String SQL_INSERT = 
        "INSERT INTO users (username, password, full_name, role) VALUES (?, ?, ?, ?)";
    
    // 3. Hàm kết nối Database
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy Driver MySQL", e);
        }
    }
    
    /**
     * Hàm kiểm tra đăng nhập (QUAN TRỌNG NHẤT)
     */
    public User authenticate(String username, String password) {
        User user = null;
        
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL_AUTHENTICATE)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    
                    // So sánh mật khẩu nhập vào với mật khẩu mã hóa trong DB
                    if (BCrypt.checkpw(password, hashedPassword)) {
                        user = mapResultSetToUser(rs);
                        
                        // Nếu đúng thì cập nhật giờ đăng nhập
                        updateLastLogin(user.getId());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    
    // Cập nhật thời gian đăng nhập lần cuối
    private void updateLastLogin(int userId) {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL_UPDATE_LAST_LOGIN)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Lấy user theo ID
    public User getUserById(int id) {
        User user = null;
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL_GET_BY_ID)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // Map dữ liệu từ SQL vào đối tượng Java
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        
        // Đã bỏ dòng setCreatedAt và setLastLogin để tránh lỗi code
        // vì file User.java của bạn chưa khai báo 2 biến này.
        return user;
    }
    
    // --- HÀM MAIN ĐỂ TEST NGAY LẬP TỨC ---
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        
        System.out.println("--- BẮT ĐẦU TEST ĐĂNG NHẬP ---");
        
        // Test 1: Đăng nhập đúng (admin / password123)
        User user = dao.authenticate("admin", "password123");
        if (user != null) {
            System.out.println("✅ Test 1: Đăng nhập thành công!");
            System.out.println("   Xin chào: " + user.getFullName());
        } else {
            System.out.println("❌ Test 1: Thất bại (Kiểm tra lại DB hoặc pass)");
        }
        
        // Test 2: Đăng nhập sai pass
        User invalidUser = dao.authenticate("admin", "sai_pass_roi");
        if (invalidUser == null) {
             System.out.println("✅ Test 2: Chặn đăng nhập sai thành công!");
        } else {
             System.out.println("❌ Test 2: Lỗi (Tại sao sai pass mà vẫn vào được?)");
        }
    }
    // --- EXERCISE 8: CHANGE PASSWORD ---
    public boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newHashedPassword);
            pstmt.setInt(2, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}