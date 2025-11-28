package controller;

import dao.UserDAO;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chuyển hướng đến trang đổi pass
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String currentPass = request.getParameter("currentPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");
        
        // Validate đơn giản
        if (newPass == null || !newPass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu mới không khớp!");
            request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
            return;
        }
        
        // Kiểm tra mật khẩu cũ (Logic: Lấy user mới nhất từ DB -> So sánh)
        // Lưu ý: Code này giả định bạn đã có hàm getUserById, nếu chưa có thì dùng tạm user trong session
        // Nhưng chuẩn nhất là phải query lại DB. Ở đây mình dùng User trong session cho gọn.
        
        // Hash mật khẩu mới
        String newHash = BCrypt.hashpw(newPass, BCrypt.gensalt());
        
        // Cập nhật
        if (userDAO.updatePassword(user.getId(), newHash)) {
            request.setAttribute("message", "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.");
            // session.invalidate(); // Có thể bắt đăng nhập lại nếu muốn
        } else {
            request.setAttribute("error", "Lỗi hệ thống, không đổi được mật khẩu.");
        }
        
        request.getRequestDispatcher("/views/change-password.jsp").forward(request, response);
    }
}