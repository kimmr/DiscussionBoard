<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>JSP Ajax Discussion Board</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
		String boardID = request.getParameter("boardID");
		
		//If non-user tries to download the file
		if(boardID == null || boardID.equals("")) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "Log in to have access");
			response.sendRedirect("index.jsp");
			return;
		}
		
		String root = request.getSession().getServletContext().getRealPath("/");
		String savePath = root + "upload";
		String fileName = "";
		String realFile = "";
		BoardDAO boardDAO = new BoardDAO();
		fileName = boardDAO.getFile(boardID);
		realFile = boardDAO.getRealFile(boardID);
		
		// No attachment
		if(fileName.equals("") || realFile.equals("")) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "No access");
			response.sendRedirect("index.jsp");
			return;
		}
		
		InputStream in = null;
		OutputStream os = null;
		File file = null;
		boolean skip = false;
		String client = "";
		try {
			try {
				file = new File(savePath, realFile);
				in = new FileInputStream(file);
			} catch (FileNotFoundException e) {
				skip = true;
			}
			client = request.getHeader("User-Agent");
			response.reset();
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Description", "JSP Generated Data");
			if(!skip) {
				// download depend on what web browser the user is using. Encodes differently
				if(client.indexOf("MSIE") != -1) {
					response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes("KSC5601"), "ISO8859_1"));
				} else {
					fileName = new String(fileName.getBytes("UTF-8"), "iso-8859-1");
					response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
					response.setHeader("Content-Type", "application/octet-stream; charset=UTF-8");
				}
				response.setHeader("Content-Length", "" + file.length());
				os = response.getOutputStream();
				byte b[] = new byte[(int)file.length()];
				int leng = 0;
				while ((leng = in.read(b)) > 0) {
					os.write(b, 0 ,leng);
				}
			} else {
				response.setContentType("text/html; charset=UTF-8");
				out.println("<script>alert('No File Found');history.back();</script>");
			}
			in.close();
			os.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	<script>
		location.href = 'index.jsp';
	</script>
</body>
</html>