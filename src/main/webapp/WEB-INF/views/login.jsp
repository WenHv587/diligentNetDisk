<%--
  Created by IntelliJ IDEA.
  User: wddv587
  Date: 2020/12/13
  Time: 14:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
    <title>登录界面</title>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <%--引入bootstrap的资源--%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<div class="row">
    <div class="col-md-12"><h1 align="center">登录，发现更多！</h1></div>
</div>
<br/><br/><br/>
<div class="row">
    <div class="col-md-4 col-md-offset-4">
        <form class="form-horizontal" id="loginForm">
            <div class="form-group">
                <label for="InputUsername">用户名</label>
                <input type="text" name="username" class="form-control" id="InputUsername" placeholder="Username">
                <span class="help-block"></span>
            </div>
            <div class="form-group">
                <label for="InputPassword">密码</label>
                <input type="password" name="password" class="form-control" id="InputPassword" placeholder="Password">
                <span class="help-block"></span>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-5 col-sm-2">
                    <button type="button" class="btn btn-primary btn-lg" id="login_btn"> 登 录 </button>
                </div>
            </div>
            <div class="form-group">
                <a href="/utils/jump/regist">去注册</a>
            </div>
        </form>
    </div>
</div>

    <script type="text/javascript">
        /*抽取出显示校验结果的提示信息*/
        function show_validate_msg(ele, status, msg) {
            // 清除当前元素的校验状态
            $(ele).parent().removeClass('has-success has-error');
            $(ele).next("span").text("");
            if ("success" === status) {
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            } else if ("error" === status) {
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        function remove_validate(ele) {
            $(ele).focus(function () {
                // 当输入框获得焦点的时候，清除当前元素的校验状态
                $(ele).parent().removeClass('has-success has-error');
                $(ele).next("span").text("");
            });
        }
        remove_validate("#InputUsername");
        remove_validate("#InputPassword");

        $("#login_btn").click(function () {
            $.ajax({
                url:"${APP_PATH}/user/login",
                type:"POST",
                data:$("#loginForm").serialize(),
                success:function (result) {
                    if (result.code === 200) {
                        show_validate_msg("#InputUsername", "success", "");
                        show_validate_msg("#InputPassword", "success", "");
                        window.location.href = "${APP_PATH}/utils/jump/main"
                    } else {
                        if (typeof(result.extend.errorMap) != "undefined") {
                            if (typeof(result.extend.errorMap.username) != "undefined") {
                                show_validate_msg("#InputUsername", "error", result.extend.errorMap.username);
                            } else {
                                show_validate_msg("#InputUsername", "success", "");
                            }
                            if (typeof(result.extend.errorMap.password) != "undefined") {
                                show_validate_msg("#InputPassword", "error", result.extend.errorMap.password);
                            } else {
                                show_validate_msg("#InputPassword", "success", "");
                            }
                        } else {
                            show_validate_msg("#InputUsername", "success", "");
                            show_validate_msg("#InputPassword", "success", "");
                        }
                        if (typeof(result.extend.loginException) != "undefined") {
                            if (result.extend.loginException === "用户不存在！") {
                                show_validate_msg("#InputUsername", "error", result.extend.loginException);
                            } else if (result.extend.loginException === "密码错误！") {
                                show_validate_msg("#InputPassword", "error", result.extend.loginException);
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
