<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if(userID == null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "You must be logged in");
			response.sendRedirect("index.jsp");
			return;
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
		function findFunction() {
			var userID = $('#findID').val();
			$.ajax({
				type: "POST",
				url: './UserRegisterCheckServlet',
				data: {userID: userID},
				success: function(result) {
					if(result == 0) {
						$('#checkMessage').html('Sucessfully found your bud!');
						$('#checkType').attr('class', 'modal-content panel-success');
						getFriend(userID);
					} else {
						$('#checkMessage').html('Could not find your friend');
						$('#checkType').attr('class', 'modal-content panel-warning');
						failFriend();
					}
					$('#checkModal').modal("show");
				}
			});
		}
		function getFriend(findID) {
			$('#friendResult').html('<thead>' +
					'<tr>' +
					'<tr><h4>Result</h4></th>' +
					'</tr>' +
					'</thead>' + 
					'<tbody>' +
					'<tr>' +
					'<td style="text-align: center;"><h3>' + findID + '</h3><a href="chat.jsp?toID=' + encodeURIComponent(findID) + '" class="btn btn-primary pull-right">' + 'Send Message</a></td>' +
					'</tr>' +
					'</tbody>');
		}
		function failFriend() {
			$('#friendResult').html('');
		}
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
				<li><a href="index.jsp">Main</a>
				<li class="active"><a href="find.jsp">Find Friend</a>
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
						<li><a href="update.jsp">Update your account</a></li>
						<li><a href="profileUpdate.jsp">Update your profile</a></li>
						<li><a href="logoutAction.jsp">Log Out</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="2"><h4>Search your friend</h4></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="width: 110px;"><h5>ID</h5></td>
					<td><input class="form-control" type="text" id="findID" maxlength="20" placeholder="ID to Search"></td>
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="findFunction();">Search</button></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="container">
		<table id="friendResult" class="table table-bordered table-hover" style="text-aligh: center; border: 1px solid #dddddd">
		</table>
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
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="vertical-alignment-helper">
			<div class="modal-dialog vertial-align-center">
				<div id="checkType" class="modal-content panel-info">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">close</span>
						</button>
						<h4 class="modal-title">
							Confirm Message
						</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">confirm</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>