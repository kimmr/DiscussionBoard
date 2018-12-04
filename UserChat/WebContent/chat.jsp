<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		String toID = null;
		if(request.getParameter("toID") != null) {
			toID = (String) request.getParameter("toID");
		}
		if(userID == null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "Log in to send a message");
			response.sendRedirect("index.jsp");
			return;
		}
		if(toID == null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "Receiver needed");
			response.sendRedirect("index.jsp");
			return;
		}
		String fromProfile = new UserDAO().getProfile(userID);
		String toProfile = new UserDAO().getProfile(toID);
	%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>JSP Ajax Discussion Board</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
		function autoClosingAlert(selector, delay) {
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function() { alert.hide() }, delay);
		}
		function submitFunction() {
			var fromID = '<%= userID %>';
			var toID = '<%= toID %>';
			var chatContent = $('#chatContent').val();
			$.ajax({
				type: "POST",
				url: "./chatSubmitServlet",
				data: {
					fromID: encodeURIComponent(fromID),
					toID: encodeURIComponent(toID),
					chatContent: encodeURIComponent(chatContent),
				},
				success: function(result) {
					if(result == 1) {
						autoClosingAlert('#successMessage', 2000);
					} else if (result == 0) {
						autoClosingAlert('#dangerMessage', 2000);
					} else {
						autoClosingAlert('#warningMessage', 2000);
					}
				}
			});
			$('#chatContent').val('');
		}
		var lastID = 0;
		function chatListFunction(type) {
			var fromID = '<%= userID %>';
			var toID = '<%= toID %>';
			$.ajax({
				type: "POST",
				url: "./chatListServlet",
				data: {
					fromID: encodeURIComponent(fromID),
					toID: encodeURIComponent(toID),
					listType: type
				},
				success: function(data) {
					if(data =="") return;
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i = 0; i < result.length; i++) {
						// when I'm sending the message to myself
						if(result[i][0].value == fromID) {
							result[i][0].value = 'me';
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
					lastID = Number(parsed.last);
				}
			});
		}
		function addChat(chatName, chatContent, chatTime) {
			if(chatName == 'me') {
			$('#chatList').append('<div class="row">' +
				'<div class="col-lg-12">' +
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle" style="width:30px; height:30px;" src="<%= fromProfile %>" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				chatName +
				'<span class="small pull-right">' +
				chatTime +
				'</span>' +
				'</h4>' +
				'<p>' +
				chatContent +
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');
			} else {
				$('#chatList').append('<div class="row">' +
						'<div class="col-lg-12">' +
						'<a class="pull-left" href="#">' +
						'<img class="media-object img-circle" style="width:30px; height:30px;" src="<%= toProfile %>" alt="">' +
						'</a>' +
						'<div class="media-body">' +
						'<h4 class="media-heading">' +
						chatName +
						'<span class="small pull-right">' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr>');
			}
				$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		}
		function getInfiniteChat() {
			setInterval(function() {
				chatListFunction(lastID);
			}, 3000);
		}
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
				<li class="nav-item"><a href="index.jsp">Main</a>
				<li class="nav-item"><a href="find.jsp">Find Friend</a>
				<li><a href="box.jsp">Inbox<span id="unread" class="label label-info"></span></a></li>
				<li><a href="boardView.jsp">Board</a></li>
			</ul>
			<%
				if(userID != null) {
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
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>Live Chat</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height: 600px;">
						</div>
						<div class="portlet-footer">
						<!--
							<div class="row">
								<div class="form-group col-xs-4">
									<input style="height: 40px;" type="text" id="chatName" class="form-control" placeholder="Name" maxlength="8">
								</div>
							</div>
							 -->
							<div class="row" style="height: 90px;">
								<div class="form-group col-xs-10">
									<textarea style="height: 80px;" id="chatContent" class="form-control" placeholder="Enter Message" maxlength="300"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction()">Send</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="alert alert-success" id="successMessage" style="display: none;">
		<strong>Message Sent</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display: none;">
		<strong>Enter the message</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage" style="display: none;">
		<strong>Database Error</strong>
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
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
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
	<script type="text/javascript">
		$(document).ready(function(){
			getUnread()
			chatListFunction('0');
			getInfiniteChat();
			getInfiniteUnread();
		});
	</script>
</body>
</html>