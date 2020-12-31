<%--
  Created by IntelliJ IDEA.
  User: wddv587
  Date: 2020/12/13
  Time: 17:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>注册界面</title>

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
        <div class="col-md-12"><h1 align="center">欢迎注册</h1></div>
    </div>
    <br/><br/><br/>
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <form class="form-horizontal" id="registAddForm">
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
                    <label for="InputEmail">邮箱</label>
                    <input type="text" name="email" class="form-control" id="InputEmail" placeholder="Email">
                    <span class="help-block"></span>
                </div>
                <div class="form-group">
                    <label for="InputVerifyCode">验证码</label>
                    <input type="text" name="verifyCode" class="form-control" id="InputVerifyCode" placeholder="verifyCode">
                    <span class="help-block"></span>
                    <img id="img" src="/utils/verifyCode"/>
                    <a href="javascript:_change()">看不清，换一张</a>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-5 col-sm-2">
                        <button type="button" class="btn btn-primary btn-lg" id="regist_btn">注册</button>
                    </div>
                </div>
                <div class="form-group">
                    <a href="/utils/jump/login">去登录</a>
                </div>
            </form>
        </div>
    </div>

    <script type="text/javascript">
        // 更换验证码图片
        function _change() {
            var imgEle = document.getElementById("img");
            imgEle.src = "/utils/verifyCode?a=" + new Date().getTime();
        }

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
        remove_validate("#InputEmail");
        remove_validate("#InputVerifyCode");

        $("#regist_btn").click(function () {
            // 发送ajax请求完成注册
                $.ajax({
                    url: "${APP_PATH}/user/regist",
                    type: "POST",
                    data: $("#registAddForm").serialize(),
                    success: function (result) {
                        if (result.code === 200) {
                            show_validate_msg("#InputUsername", "success", "");
                            show_validate_msg("#InputPassword", "success", "");
                            show_validate_msg("#InputEmail", "success", "");
                            show_validate_msg("#InputVerifyCode", "success", "");
                            alert("注册成功！即将跳转至登录界面！");
                            window.location.href = "${APP_PATH}/utils/jump/login"
                        } else {
                            if (typeof(result.extend.errorMap) != "undefined") {
                                // 哪个字段有错误信息就显示哪个字段的错误信息，没错就将输入框的状态设置为成功
                                if (typeof (result.extend.errorMap.username) != "undefined") {
                                    // 显示用户名的错误信息
                                    show_validate_msg("#InputUsername", "error", result.extend.errorMap.username);
                                } else {
                                    show_validate_msg("#InputUsername", "success", "");
                                }

                                if (typeof (result.extend.errorMap.password) != "undefined") {
                                    // 显示密码的错误信息
                                    show_validate_msg("#InputPassword", "error", result.extend.errorMap.password);
                                } else {
                                    show_validate_msg("#InputPassword", "success", "");
                                }

                                if (typeof (result.extend.errorMap.email) != "undefined") {
                                    // 显示邮箱的错误信息
                                    show_validate_msg("#InputEmail", "error", result.extend.errorMap.email);
                                } else {
                                    show_validate_msg("#InputEmail", "success", "");
                                }

                                if (typeof (result.extend.errorMap.verifyCode) != "undefined") {
                                    // 显示验证码的错误信息
                                    show_validate_msg("#InputVerifyCode", "error", result.extend.errorMap.verifyCode);
                                } else {
                                    show_validate_msg("#InputVerifyCode", "success", "");
                                }
                            } else {
                                // 如果errorMap为undefined，说明后端的合理性校验全部通过
                                show_validate_msg("#InputUsername", "success", "");
                                show_validate_msg("#InputPassword", "success", "");
                                show_validate_msg("#InputEmail", "success", "");
                                show_validate_msg("#InputVerifyCode", "success", "");
                            }
                        }
                        if (typeof(result.extend.UserException) != "undefined") {
                            // console.log(result.extend.errorMap);
                            if (result.extend.UserException === "用户名已被注册！") {
                                show_validate_msg("#InputUsername", "error", result.extend.UserException);
                            } else if (result.extend.UserException === "邮箱已被注册！") {
                                show_validate_msg("#InputEmail", "error", result.extend.UserException);
                            }
                        }
                    }
                });
            // }
        });
    </script>
</body>
</html>
