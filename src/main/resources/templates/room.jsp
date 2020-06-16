<!DOCTYPE html>
<html lang="zh-CN"  xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>聊天室</title>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="rolling/css/rolling.css">
    <link rel="stylesheet" href="stylesheets/style.css">

</head>
<body class="room">
<input type="hidden" id="nickname" th:value="${param.nickname}">
<input type="hidden" id="avatar" th:value="${param.avatar}">
<div class="scrollbar-macosx" id="app">
    <div class="header">
        <ul class="topnavlist">
            <li class="userlist">
                <a><span class="glyphicon glyphicon-th-list"></span>用户列表</a>
                <div class="popover fade bottom in">
                    <div class="arrow"></div>
                    <h3 class="popover-title">在线用户 <span id="count"></span>人</h3>
                    <div class="popover-content scrollbar-macosx userlist">
                        <ul>

                        </ul>
                    </div>
                </div>
            </li>
        </ul>
        <div class="clapboard hidden"></div>
    </div>
    <div class="main container">
        <div class="col-md-12">
            <ul class="chat_info">
            </ul>
        </div>
    </div>
    <div class="input">
        <div class="center">
            <div class="tools">

                <span class="glyphicon glyphicon-heart face_btn"></span>

                <div class="faces popover fade top in">
                    <div class="arrow"></div>
                    <h3 class="popover-title">表情包</h3>
                    <div class="popover-content scrollbar-macosx">
                        <img src="images/face/1.gif" alt="1">
                        <img src="images/face/2.gif" alt="2">
                        <img src="images/face/3.gif" alt="3">
                        <img src="images/face/4.gif" alt="4">
                        <img src="images/face/5.gif" alt="5">
                        <img src="images/face/6.gif" alt="6">
                        <img src="images/face/7.gif" alt="7">
                        <img src="images/face/8.gif" alt="8">
                        <img src="images/face/9.gif" alt="9">
                        <img src="images/face/10.gif" alt="10">
                        <img src="images/face/11.gif" alt="11">
                        <img src="images/face/12.gif" alt="12">
                        <img src="images/face/13.gif" alt="13">
                        <img src="images/face/14.gif" alt="14">
                        <img src="images/face/15.gif" alt="15">
                        <img src="images/face/16.gif" alt="16">
                        <img src="images/face/17.gif" alt="17">
                        <img src="images/face/18.gif" alt="18">
                        <img src="images/face/19.gif" alt="19">
                        <img src="images/face/20.gif" alt="20">
                        <img src="images/face/21.gif" alt="21">
                        <img src="images/face/22.gif" alt="22">
                        <img src="images/face/23.gif" alt="23">
                        <img src="images/face/24.gif" alt="24">
                        <img src="images/face/25.gif" alt="25">
                        <img src="images/face/26.gif" alt="26">
                        <img src="images/face/27.gif" alt="27">
                        <img src="images/face/28.gif" alt="28">
                        <img src="images/face/29.gif" alt="29">
                        <img src="images/face/30.gif" alt="30">
                        <img src="images/face/31.gif" alt="31">
                        <img src="images/face/32.gif" alt="32">
                        <img src="images/face/33.gif" alt="33">
                        <img src="images/face/34.gif" alt="34">
                        <img src="images/face/35.gif" alt="35">
                        <img src="images/face/36.gif" alt="36">
                        <img src="images/face/37.gif" alt="37">
                        <img src="images/face/38.gif" alt="38">
                        <img src="images/face/39.gif" alt="39">
                        <img src="images/face/40.gif" alt="40">
                        <img src="images/face/41.gif" alt="41">
                        <img src="images/face/42.gif" alt="42">
                        <img src="images/face/43.gif" alt="43">
                        <img src="images/face/44.gif" alt="44">
                        <img src="images/face/45.gif" alt="45">
                        <img src="images/face/46.gif" alt="46">
                        <img src="images/face/47.gif" alt="47">
                        <img src="images/face/48.gif" alt="48">
                        <img src="images/face/49.gif" alt="49">
                        <img src="images/face/50.gif" alt="50">
                        <img src="images/face/51.gif" alt="51">
                        <img src="images/face/52.gif" alt="52">
                        <img src="images/face/53.gif" alt="53">
                        <img src="images/face/54.gif" alt="54">
                        <img src="images/face/55.gif" alt="55">
                        <img src="images/face/56.gif" alt="56">
                        <img src="images/face/57.gif" alt="57">
                        <img src="images/face/58.gif" alt="58">
                        <img src="images/face/59.gif" alt="59">
                        <img src="images/face/60.gif" alt="60">
                        <img src="images/face/61.gif" alt="61">
                        <img src="images/face/62.gif" alt="62">
                        <img src="images/face/63.gif" alt="63">
                        <img src="images/face/64.gif" alt="64">
                        <img src="images/face/65.gif" alt="65">
                        <img src="images/face/66.gif" alt="66">
                        <img src="images/face/67.gif" alt="67">
                        <img src="images/face/68.gif" alt="68">
                        <img src="images/face/69.gif" alt="69">
                        <img src="images/face/70.gif" alt="70">
                        <img src="images/face/71.gif" alt="71">
                        <img src="images/face/72.gif" alt="72">
                        <img src="images/face/73.gif" alt="73">
                        <img src="images/face/74.gif" alt="74">
                        <img src="images/face/75.gif" alt="75">
                    </div>
                </div>
            </div>
            <div class="text">

                <div class="col-xs-10 col-sm-11">
                    <input type="text" class="form-control" placeholder="输入聊天信息...">
                </div>
                <div class="col-xs-2 col-sm-1">
                    <a id="subxx" role="button"><span class="glyphicon glyphicon-share-alt"></span></a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript" src="javascripts/jquery-1.11.2.min.js"></script>
<script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="rolling/js/rolling.js"></script>
<script type="text/javascript" src="javascripts/Public.js"></script>
</html>