<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>	
<!-- If the user has been successfully logged in, the userID will be displayed. -->
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "Log in to send a message");
			response.sendRedirect("index.jsp");
			return;
		}
		UserDTO user = new UserDAO().getUser(userID);
	%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>JSP Ajax Discussion Board</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
	//It allows to get unread message from an user
		function getUnread() {
			$.ajax({
				type: "POST",
				url: "./chatUnread",
				data: {
					userID: encodeURIComponent('<%= userID %>'),
				},
				success: function(result) {
					//if there is unread message, display the number of unread msg
					if(result >= 1) {
						showUnread(result);
					} else {
					//if there is none, then display none
						showUnread('');
					}
				}
			});
		}
		// request the server to load unread messages for every 4 seconds
		function getInfiniteUnread() {
			setInterval(function() {
				getUnread();
			}, 4000);
		}
		function showUnread(result) {
			$('#unread').html(result);
		}
		function passwordCheckFunction() {
			var userPassword1 = $('#userPassword1').val();
			var userPassword2 = $('#userPassword2').val();
			if(userPassword1 != userPassword2) {
				$('#passwordCheckMessage').html('Those passwords do not match. Please try again.');
			} else {
				$('#passwordCheckMessage').html('');
			}
	
		}
	</script>
</head>
<body>
	<nav class="navbar navbar-default">
	<!-- Creating header of the webpage with a button at the corner 
	When the title is clicked, it will link to index.jsp-->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
			aria-expanded="false">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">Discussion Board</a>
		</div>
		<div class="collpase navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">Main</a>
				<li><a href="find.jsp">Find Friend</a></li>
				<li><a href="box.jsp">Inbox<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">Board</a></li>
			</ul>
			<ul class = "nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">Setting<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li class="active"><a href="update.jsp">Update your account</a></li>
						<li><a href="profileUpdate.jsp">Update your profile</a></li>
						<li><a href="logoutAction.jsp">Log Out</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<form method="post" action="./userUpdate">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2"><h4>Update Account</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>ID</h5></td>
						<td><h5><%= user.getUserID() %></h5>
						<input type="hidden" name="userID" value="<%= user.getUserID() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Password</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" id="userPassword1" type="password" name="userPassword1" maxlength="20" placeholder="Enter Password"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Confirm Password</h5></td>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" id="userPassword2" type="password" name="userPassword2" maxlength="20" placeholder="Confirm Password"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Name</h5></td>
						<td colspan="2"><input class="form-control" id="userName" type="text" name="userName" maxlength="20" placeholder="Enter Name" value="<%= user.getUserName() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Age</h5></td>
						<td colspan="2"><input class="form-control" id="userAge" type="number" name="userAge" maxlength="20" placeholder="Enter Age" value="<%= user.getUserAge() %>"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Gender</h5></td>
						<td colspan="3">
							<div class="form-group" style="text-align: center; margin: 0 auto;">
								<div class="btn-group" data-toggle="buttons">
									<label class ="btn btn-primary" <% if(user.getUserGender().equals("female")) out.print("active"); %>">
										<input type="radio" name="userGender" autocomplete="off" value="female" <% if(user.getUserGender().equals("female")) out.print("checked"); %>>Female
									</label>
									<label class ="btn btn-primary" <% if(user.getUserGender().equals("female")) out.print("active"); %>">
										<input type="radio" name="userGender" autocomplete="off" value="male" <% if(user.getUserGender().equals("male")) out.print("checked"); %>>Male
									</label>
									<label class ="btn btn-primary" <% if(user.getUserGender().equals("rathernottosay")) out.print("active"); %>">
										<input type="radio" name="userGender" autocomplete="off" value="rathernottosay" <% if(user.getUserGender().equals("rathernottosay")) out.print("checked"); %>>Rather Not To Say
									</label>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Email</h5></td>
						<td colspan="2"><input class="form-control" id="userEmail" type="email" name="userEmail" maxlength="50" placeholder="Enter Email" value="<%= user.getUserEmail()%>"></td>
					</tr>
					<tr>
						<td style="text-align: left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5><input class="btn btn-primary pull-right" type="submit" value="update"></td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<%
		String messageContent = null;
		if(session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if(session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
		if(messageContent != null) {
	%>
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertial-align-center">
				<div class="modal-content <% if(messageType.equals("Error Message")) out.println("panel-warning"); else out.println("panel-success"); %>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%= messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%= messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">confirm</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$('#messageModal').modal("show");
	</script>
	<%
		session.removeAttribute("messageContent");
		session.removeAttribute("messageType");
		}
	%>
	<%
		if(userID != null) {
	%>
		<script type="text/javascript">
			$(document).ready(function(){
				getUnread();
				getInfiniteUnread();
			});
		</script>
	<% 
		}
	%>
</body>
</html>