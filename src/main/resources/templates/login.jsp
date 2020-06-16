<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>聊天室登录</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="stylesheets/style.css">
</head>
<body class="login">
<div class="scrollbar-macosx">
    <div class="main container ">
        <form action="room" id="login_form" method="get">
            <input type="hidden" name="avatar" id="avatar" value="1">
            <div class="jumbotron">
                <h1></h1>
                <p class="user_portrait">
                    <img portrait_id="1" src="images/user/1.png" alt="portrait_1">
                </p>
                <p class="select_portrait">
                    <img portrait_id="1" src="images/user/1.png" alt="portrait_1"
                         class="t">
                    <img portrait_id="2" src="images/user/2.png" alt="portrait_1">
                    <img portrait_id="3" src="images/user/3.png" alt="portrait_1">
                    <img portrait_id="4" src="images/user/4.png" alt="portrait_1">
                    <img portrait_id="5" src="images/user/5.png" alt="portrait_1">
                    <img portrait_id="6" src="images/user/6.png" alt="portrait_1">
                    <img portrait_id="7" src="images/user/7.png" alt="portrait_1">
                    <img portrait_id="8" src="images/user/8.png" alt="portrait_1">
                    <img portrait_id="9" src="images/user/9.png" alt="portrait_1">
                    <img portrait_id="10" src="images/user/10.png" alt="portrait_1">
                    <img portrait_id="11" src="images/user/11.png" alt="portrait_1">
                    <img portrait_id="12" src="images/user/12.png" alt="portrait_1">
                </p>
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="输入你的昵称，不填随机昵称……" name="nickname" id="nickname">
                    <span class="input-group-btn">
							<button id="login" class="btn btn-default" type="submit">
								<span class="glyphicon glyphicon-arrow-right"></span>
							</button>
						</span>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
<script type="text/javascript" src="javascripts/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="rolling/js/rolling.js"></script>
<script type="text/javascript" src="javascripts/Public.js"></script>
</html>