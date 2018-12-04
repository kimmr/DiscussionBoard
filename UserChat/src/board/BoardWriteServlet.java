package board;

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

public class BoardWriteServlet extends HttpServlet {
	public String savePath = "";
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		MultipartRequest multi = null;
		int fileMaxSize = 10 * 1024 * 1024;
		
		//Save to /upload. Replace double backslash to a slash
		//String savePath = request.getRealPath("/upload").replaceAll("\\\\","/");
		savePath = "C:\\Users\\Megan\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\UserChat\\upload\\";
		
		try {
			//DefaultFileRenamePolicy handles error such as duplicate file name, etc. It automatically adds "1" to the duplicate file name.
			multi = new MultipartRequest(request, savePath, fileMaxSize, "UTF-8", new DefaultFileRenamePolicy());
		} catch(Exception e) {
			// Comes here
			request.getSession().setAttribute("messageType", "Error Message");
			request.getSession().setAttribute("messageContent", "File size cannot be bigger than 10MB");
			response.sendRedirect("index.jsp");
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
		String boardTitle = multi.getParameter("boardTitle");
		String boardContent = multi.getParameter("boardContent");
		
		if(boardTitle == null || boardTitle.equals("") || boardContent == null || boardContent.equals("")) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "Fill out all forms");
			response.sendRedirect("boardWrite.jsp");
			return;
		}
		String boardFile = "";
		String boardRealFile = "";
		File file = multi.getFile("boardFile");
		if(file != null) {
			boardFile = multi.getOriginalFileName("boardFile");
			boardRealFile = file.getName();
			}
		BoardDAO boardDAO = new BoardDAO();
		boardDAO.write(userID, boardTitle, boardContent, boardFile, boardRealFile);
		
		session.setAttribute("messageType", "Success Message");
		session.setAttribute("messageContent", "Successfully posted!");
		response.sendRedirect("boardView.jsp");
		return;
	}
}

