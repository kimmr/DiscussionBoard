package user;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

/**
 * Servlet implementation class UserProfileServlet
 */
@WebServlet("/UserProfileServlet")
public class UserProfileServlet extends HttpServlet {
	public String savePath = "";
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		
		//Save to /upload. Replace double backslash to a slash
		//String savePath = request.getRealPath("/upload");
		savePath = "C:\\Users\\Megan\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\UserChat\\upload\\";
		
		try {
			//DefaultFileRenamePolicy handles error such as duplicate file name, etc. It automatically adds "1" to the duplicate file name.
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch(Exception e) {
			// Comes here
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "File size cannot be bigger than 10MB");
			response.sendRedirect("profileUpdate.jsp");
			return;
		}
		String userID = multi.getParameter("userID");
		HttpSession session = request.getSession();
		//If an user tries to update the profile of other users
		if(!userID.equals((String) session.getAttribute("userID"))) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "You do not have access");
			response.sendRedirect("index.jsp");
			return;
		}
		String fileName = "";
		File file = multi.getFile("userProfile");
		if(file != null) {
			String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1);
			if(ext.equals("jpg") || ext.equals("png") || ext.equals("gif")) {
				String prev = new UserDAO().getUser(userID).getUserProfile();
				// Erase the previous profile picture and replace it with new profile picture
				File prevFile = new File(savePath + "/" + prev);
				if(prevFile.exists()) {
					prevFile.delete();
				}
				fileName = file.getName();
				} else {
					if(file.exists()) {
						file.delete();
					}
					session.setAttribute("messageType", "Error Message");
					session.setAttribute("messageContent", "Please upload an image file such as jpg, png and gif");
					response.sendRedirect("profileUpdate.jsp");
					return;
				}
			}
		new UserDAO().profile(userID, fileName);
		session.setAttribute("messageType", "Success Message");
		session.setAttribute("messageContent", "Successfully updated your profile");
		response.sendRedirect("index.jsp");
		return;
	}
}

