<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>JSP Ajax Discussion Board</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script text="text/javascript">
		function registerCheckFunction() {
			var userID = $('#userID').val();
			$.ajax({
				type: 'POST',
				url: './UserRegisterCheckServlet',
				data: {userID:userID},
				success: function(result) {
					if(result == 1) {
						$('#checkMessage').html('This ID is available to use');
						$('#checkType').attr('class','modal-content panel-success');
					} else {
						$('#checkMessage').html('This ID is not available to use');
						$('#checkType').attr('class','modal-content panel-warning');
					}
					$('#checkModal').modal("show");
				}
			});
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
	<!-- If the user has been successfully logged in, the userID will be displayed. -->
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if(userID != null) {
			session.setAttribute("messageType", "Error Message");
			session.setAttribute("messageContent", "You are currently logged in.");
			response.sendRedirect("index.jsp");
			return;
		}
	%>
	
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
						<li class="active"><a href="signup.jsp">Sign Up</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<form method="post" action="./userRegister">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"><h4>Sign up form</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 110px;"><h5>ID</h5></td>
						<td><input class="form-control" type="text" id="userID" name="userID" maxlength="20" placeholder="Enter ID"></td>
						<td style="width: 110px;"><button class="btn btn-primary" onclick="registerCheckFunction();" type="button">Check</button></td>
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
						<td colspan="2"><input class="form-control" id="userName" type="text" name="userName" maxlength="20" placeholder="Enter Name"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Age</h5></td>
						<td colspan="2"><input class="form-control" id="userAge" type="number" name="userAge" maxlength="20" placeholder="Enter Age"></td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Gender</h5></td>
						<td colspan="3">
							<div class="form-group" style="text-align: center; margin: 0 auto;">
								<div class="btn-group" data-toggle="buttons">
									<label class ="btn btn-primary">
										<input type="radio" name="userGender" autocomplete="off" value="female" checked>Female
									</label>
									<label class ="btn btn-primary">
										<input type="radio" name="userGender" autocomplete="off" value="male">Male
									</label>
									<label class ="btn btn-primary">
										<input type="radio" name="userGender" autocomplete="off" value="rathernottosay">Rather Not To Say
									</label>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 110px;"><h5>Email</h5></td>
						<td colspan="2"><input class="form-control" id="userEmail" type="email" name="userEmail" maxlength="50" placeholder="Enter Email"></td>
					</tr>
					<tr>
						<td style="text-align: left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5><input class="btn btn-primary pull-right" type="submit" value="Submit"></td>
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