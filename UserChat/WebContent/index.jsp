<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>	
<!-- If the user has been successfully logged in, the userID will be displayed. -->
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
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
				<li class="active"><a href="index.jsp">Main</a>
				<li><a href="find.jsp">Find Friend</a></li>
				<li><a href="box.jsp">Inbox<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">Board</a></li>
			</ul>
			<%
				if(userID == null) {
			%>
			<ul class = "nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">Join us<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">Log In</a></li>
						<li><a href="signup.jsp">Sign Up</a></li>
					</ul>
				</li>
			</ul>
			<% } else if (userID.equals("admin")) {
			%>
				<ul class = "nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">Setting<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="admin.jsp">Admin</a></li>
						<li><a href="update.jsp">Update your account</a></li>
						<li><a href="profileUpdate.jsp">Update your profile</a></li>
						<li><a href="logoutAction.jsp">Log Out</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class = "nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">Setting<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">Update your account</a></li>
						<li><a href="profileUpdate.jsp">Update your profile</a></li>
						<li><a href="logoutAction.jsp">Log Out</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
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