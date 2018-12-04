package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class UserRegisterServlet
 */
@WebServlet("/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		HttpSession session = request.getSession();
		String userPassword1 = request.getParameter("userPassword1");
		String userPassword2 = request.getParameter("userPassword2");
		String userName = request.getParameter("userName");
		String userAge = request.getParameter("userAge");
		String userGender = request.getParameter("userGender");
		String userEmail = request.getParameter("userEmail");
		// If the requested user information is null
		if(userID == null || userID.equals("") || userPassword1 == null || userPassword1.equals("") || userPassword2 == null || userPassword2.equals("")
				|| userName == null || userName.equals("") || userAge == null || userAge.equals("") || userGender == null || userGender.equals("")
				|| userEmail == null || userEmail.equals("")) {
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "Please fill out the form entirely");
			response.sendRedirect("update.jsp");
			return;
		}
		// Allows access to change if it is the right user
		if(!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "You do not have access");
			response.sendRedirect("index.jsp");
			return;
		}
		if(!userPassword1.equals(userPassword2)) {
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "Password does not match");
			response.sendRedirect("update.jsp");
			return;
		}
		int result = new UserDAO().update(userID, userPassword1, userName, userAge, userGender, userEmail);
		if (result == 1) {
			request.getSession().setAttribute("userID", userID);
			request.getSession().setAttribute("messageType", "Success");
			request.getSession().setAttribute("messageContent", "Sign up completed!");
			response.sendRedirect("index.jsp");
		}
		else {
			request.getSession().setAttribute("messageType", "Error");
			request.getSession().setAttribute("messageContent", "Database Error");
			response.sendRedirect("update.jsp");
		}
		
	}

}
