<%--
  Created by IntelliJ IDEA.
  User: wddv587
  Date: 2020/12/19
  Time: 0:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <title>我的文件</title>

    <%--multipart形式上传文件--%>
    <meta http-equiv="Content-Type" content="multipart/form-data; charset=utf-8"/>

    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <link href="${APP_PATH}/static/css/materialdesignicons.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${APP_PATH}/static/css/jquery-confirm.min.css">
    <link href="${APP_PATH}/static/css/style.min.css" rel="stylesheet">

</head>

<body>


<div class="lyear-layout-web">
    <div class="lyear-layout-container">
        <!--头部信息-->
        <header class="lyear-layout-header">
            <nav class="navbar navbar-default">
                <div class="topbar">
                    <h1>NetDisk</h1>
                    <div>
                        <c:choose>
                            <c:when test="${empty sessionScope.session_user }">
                                <a href="/utils/jump/login" target="_parent">登录</a> |&nbsp;
                                <a href="/utils/jump/regist" target="_parent">注册</a>
                            </c:when>
                            <c:otherwise>
                                您好：${sessionScope.session_user.username }&nbsp;&nbsp;|&nbsp;&nbsp;
                                <c:if test="${sessionScope.session_user.status == 0}">
                                    <a id="openVip" href="javascript:void(0)">开通会员</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                                </c:if>
                                <c:if test="${sessionScope.session_user.status == 1}">
                                    <span>您已经是尊贵的会员用户</span>
                                </c:if>
                                <a href="/user/exit">退出</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </nav>
        </header>
        <!--End 头部信息-->


        <!--左侧导航-->
        <aside class="lyear-layout-sidebar">
            <!-- logo -->
            <div id="logo" class="sidebar-header">

                <%--                <a href="index.html"><img src="images/LStorage.png" title="LightYear" alt="LightYear" /></a>--%>
            </div>
            <div class="lyear-layout-sidebar-scroll">
                <nav class="sidebar-main">
                    <ul class="nav nav-pills nav-stacked">
                        <br/><br/><br/><br/><br/><br/>
                        <li role="presentation"><a id="nav_all" href="javascript:void(0)"><font size="4">全部文件</font></a>
                        </li>
                        <li role="presentation" value="1"><a id="nav_img" href="javascript:void(0)"><font
                                size="4">图片</font></a></li>
                        <li role="presentation" value="2"><a id="nav_sound" href="javascript:void(0)"><font
                                size="4">音频</font></a></li>
                        <li role="presentation" value="3"><a id="nav_video" href="javascript:void(0)"><font
                                size="4">视频</font></a></li>
                        <li role="presentation" value="4"><a id="nav_doc" href="javascript:void(0)"><font
                                size="4">文档</font></a></li>
                        <li role="presentation" value="5"><a id="nav_rar" href="javascript:void(0)"><font
                                size="4">压缩包</font></a></li>
                        <li role="presentation" value="6"><a id="nav_other" href="javascript:void(0)"><font size="4">其他资源</font></a>
                        </li>
                        <li role="presentation"><a id="nav_share" href="javascript:void(0)"><font
                                size="4">共享资源</font></a></li>
                        <li role="presentation"><a id="nav_trash" href="javascript:void(0)"><font
                                size="4">回收站</font></a></li>
                    </ul>
                </nav>
            </div>
            <%--进度条--%>
            <div class="progress">
                <div id="percent" class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100">
                    <%--之后会使用jquery为进度条设置百分比--%>
                    <span class="sr-only"></span>
                </div>
            </div>
            <h5 id="sum"></h5>
        </aside>
        <!--End 左侧导航-->

        <!--页面主要内容-->
        <main class="lyear-layout-content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-3 col-md-offset-9" id="div_basicBtn">
                        <%--一些基本的操作按钮，通过jquery填充--%>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-md-offset-0">
                        <h4>文件列表</h4>
                    </div>
                </div>
                <div>
                    <div class="col-md-12">
                        <table class="table table-hover" id="fileTable">
                            <%--表头--%>
                            <thead>
                            <%--使用jQuery渲染页面--%>
                            </thead>
                            <%--表格体--%>
                            <tbody>
                            <%--使用jQuery渲染页面--%>
                            </tbody>
                        </table>
                    </div>
                    <%--显示分页信息--%>
                    <div class="row">
                        <%--分页文字信息--%>
                        <div class="col-md-6" id="page_info_area"></div>
                        <%--分页条信息--%>
                        <div class="col-md-6" id="page_nav_area"></div>
                    </div>
                </div>
            </div>
        </main>
        <!--End 页面主要内容-->

    </div>
</div>

<!-- 上传文件的模态框 -->
<div class="modal fade" id="uploadModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <%--                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>--%>
                <%--                </button>--%>
                <h4 class="modal-title" id="myModalLabel">文件上传</h4>
            </div>
            <div class="modal-body">
                <form method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="InputFile">File input</label>
                        <input type="file" id="InputFile" name="file">
                        <p class="help-block"></p>
                    </div>
                    <div class="form-group">
                        <label for="SelectCategory">Select category</label>
                        <select class="form-control" id="SelectCategory">
                            <option value="0">请选择文件夹</option>
                            <option value="1">图片</option>
                            <option value="2">音频</option>
                            <option value="3">视频</option>
                            <option value="4">文档</option>
                            <option value="5">压缩包</option>
                            <option value="6">其他资源</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="btn_goUpload">上传</button>
            </div>
        </div>
    </div>
</div>

<%--修改文件名称的模态框--%>
<div class="modal fade" id="modifyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel1">修改文件名</h4>
            </div>
            <div class="modal-body">
                <label for="modifyName">文件名称</label>
                <input type="text" class="form-control" id="modifyName" placeholder="请输入文件名（不需要输入后缀名）">
                <span class="help-block"></span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="btn_goModify">修改</button>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    // 当前用户的id
    var userId = ${sessionScope.session_user.userId};

    // 页面加载完成以后，发送ajax请求，渲染页面
    $(function () {
        show();
        calcSum();
    });

    /**
     * 显示所有文件
     */
    function show() {
        $.ajax({
            url: "${APP_PATH}/file/getAll",
            data: "userId=" + userId,
            type: "GET",
            async: false,
            success: function (result) {
                // 解析显示文件信息
                build_file_table(result);
            }
        });
    }

    /**
     * 请求计算文件总大小并进行显示
     */
    function calcSum() {
        var status = ${sessionScope.session_user.status};
        $.ajax({
            url: "${APP_PATH}/file/fileSizeSum",
            data: "userId=" + userId,
            success: function (result) {
                if (result.code === 200) {
                    // 显示文件总大小信息
                    var sum = result.extend.sum;
                    var str;
                    var percent;
                    if (status === 0) {
                        str = sum + "MB / 1GB<br/>开通会员容量扩大到5GB</font>";
                        percent = sum / 10;
                    } else {
                        str = sum + "MB / 5GB";
                        percent = sum / 50;
                    }
                    $("#sum").empty().append(str);
                    $("#percent").attr("style", "width:" + percent.toFixed(2) + "%");
                }
            }
        });
    }

    /**
     * 显示文件列表
     * @param result 查询后台得到的结果
     */
    function build_file_table(result) {
        $("#div_basicBtn").empty()
            .append("<button type='button' class='btn btn-default' id='btn_upload'>上传</button>")
            .append("<button type='button' class='btn btn-default' id='btn_delete_multiple'>删除</button>")
            .append("<button type='button' class='btn btn-default' id='btn_share_multiple'>共享</button>");
        // 清空table表格头
        $("#fileTable thead").empty();
        $("<tr></tr>").append("<td><input type='checkbox' id='check_all'></td>")
            .append("<th>文件名</th>")
            .append("<th>文件大小</th>")
            .append("<th>上传时间</th>")
            .append("<th>文件状态</th>")
            .append("<th>操作</th>")
            .appendTo("#fileTable thead");
        // 清空table表格体
        $("#fileTable tbody").empty();
        // 得到文件信息集合
        var fileList = result.extend.fileList;
        $.each(fileList, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'></td>");

            var fileNameTd;
            var a;
            // 如果文件是图片或是文本文件类型，以超链接显示文件的名称，便于预览
            var username = ${sessionScope.session_user.username};
            if (item.category.cid === 1) {
                var path = "${APP_PATH}/file/previewImg?username=" + username + "&filename=" + item.fname;
                a = $("<a id='previewImg' target='_blank'></a>").text(item.fname).attr("href", path);
                fileNameTd = $("<td></td>").append(a);
            } else if (item.category.cid === 4) {
                a = $("<a id='previewOffice' href='javascript:void(0)'></a>").text(item.fname);
                fileNameTd = $("<td></td>").append(a);
            } else {
                fileNameTd = $("<td></td>").append(item.fname);
            }

            var fileSizeTd = $("<td></td>").append(item.fsize);
            var uploadTimeTd = $("<td></td>").append(item.fuploadtime);
            var fstatusTd = $("<td></td>").append(item.fstatus === "0" ? "私密" : "共享");
            var downloadBtn = $("<button data-toggle='tooltip' data-placement='top' title='下载'></button>")
                .addClass("btn btn-primary btn-sm btn_download")
                .append($("<span></span>")).addClass("glyphicon glyphicon-download-alt");
            // 为下载按钮带上文件名称，便于下载
            downloadBtn.attr("filename", item.fname);
            var deleteBtn = $("<button data-toggle='tooltip' data-placement='top' title='删除'></button>")
                .addClass("btn btn-danger btn-sm btn_delete")
                .append($("<span></span>")).addClass("glyphicon glyphicon-trash");
            deleteBtn.attr("fid", item.fid);
            var shareBtn = $("<button data-toggle='tooltip' data-placement='top' title='共享文件'></button>")
                .addClass("btn btn-info btn-sm btn_share")
                .append($("<span></span>")).addClass("glyphicon glyphicon-share");
            // 为共享按钮带上文件id，便于共享
            shareBtn.attr("fid", item.fid);
            var cancelShareBtn = $("<button data-toggle='tooltip' data-placement='top' title='取消共享'></button>")
                .addClass("btn btn-warning btn-sm btn_noshare")
                .append($("<span></span>")).addClass("glyphicon glyphicon-remove");
            // 为取消共享按钮带上文件id
            cancelShareBtn.attr("fid", item.fid);
            var updateNameBtn = $("<button data-toggle='tooltip' data-placement='top' title='修改名称'></button>")
                .addClass("btn btn-default btn-sm btn_update_name")
                .addClass("btn_modifyName")
                .append($("<span></span>")).addClass("glyphicon glyphicon-pencil");
            // 为修改文件名称按钮带上文件id
            updateNameBtn.attr("fid", item.fid);
            var btnTd = ($("<td></td>"));
            if (item.fstatus === "0") {
                // 文件状态为0说明文件是私密的
                btnTd = btnTd.append(downloadBtn).append(" ").append(shareBtn).append(" ").append(updateNameBtn).append(" ").append(deleteBtn);
            } else {
                btnTd = btnTd.append(downloadBtn).append(" ").append(cancelShareBtn).append(" ").append(updateNameBtn).append(" ").append(deleteBtn);
            }
            $("<tr></tr>").append(checkBoxTd)
                .append(fileNameTd)
                .append(fileNameTd)
                .append(fileSizeTd)
                .append(uploadTimeTd)
                .append(fstatusTd)
                .append(btnTd)
                .appendTo("#fileTable tbody");
        });
    }

    /**
     * 清空表单
     * @param ele
     */
    function reset_form(ele) {
        // 清空表单数据
        $(ele)[0].reset();
    }

    /**
     * 点击上传，弹出上传文件模态框
     */
    $(document).on("click", "#btn_upload", function () {
        $("#uploadModal").modal();
    });

    /**
     * 发送ajax请求上传文件
     */
    $("#btn_goUpload").click(function () {
        var fileInput = $("#InputFile").get(0).files[0];
        // 先判断是否选择了文件
        if (fileInput) {
            // 判断文件大小（设置的最大上传限制为50M）
            if (fileInput.size > 52428800) {
                alert("上传文件的最大限制为50MB");
            } else {
                var cid = $("#SelectCategory").val();
                // 再判断是否选择了文件类别
                if (cid == 0) {
                    alert("请选择文件夹！")
                } else {
                    var form = new FormData($("#uploadModal form")[0]);
                    $.ajax({
                        url: "${APP_PATH}/file/upload/" + cid,
                        type: "POST",
                        data: form,
                        cache: false,//上传文件无需缓存
                        processData: false,//用于对data参数进行序列化处理 这里必须false
                        contentType: false,
                        async: false,
                        success: function (result) {
                            if (result.code === 200) {
                                $("#uploadModal").modal("hide");
                                // 上传成功以后重新渲染右侧的主体页面
                                show();
                                alert("上传成功！");
                                // 显示总容量以及百分比
                                calcSum();
                            } else if (result.code === 500) {
                                $("#uploadModal").modal("hide");
                                show();
                                // 显示总容量以及百分比
                                calcSum();
                                alert(result.extend.msg);
                            } else {
                                alert("上传失败，请联系管理员！");
                            }
                        }
                    });
                }
            }
        } else {
            alert("请选择文件！");
        }
    });

    /**
     * 点击弹出修改文件名称的模态框
     */
    $(document).on("click", ".btn_modifyName", function () {
        // 将此次要修改的文件的id带给模态框中的修改按钮
        var fid = $(this).attr("fid");
        // 清除模态框修改按钮上的原本带有的文件id，带上新的文件id
        $("#btn_goModify").removeClass("fid").attr("fid", fid);
        var modifyInput = $("#modifyName");
        // 清空输入框的内容
        modifyInput.val("");
        // 显示模态框
        modifyInput.next("span").text("");
        modifyInput.parent().removeClass('has-success has-error');
        $("#modifyModal").modal();
    });

    /**
     * 修改文件名称
     */
    $("#btn_goModify").click(function () {
        // 获取用户输入的新名称
        var newName = $("#modifyName").val();
        // 获取要修改的文件的id
        var fid = $(this).attr("fid");
        // 用户名称
        var username = ${sessionScope.session_user.username};
        // 发送ajax请求完成改名
        $.ajax({
            url: "${APP_PATH}/file/modifyName",
            data: "userId=" + userId + "&newName=" + newName + "&fid=" + fid + "&username=" + username,
            type: "POST",
            success:function (result) {
                if (result.code === 200) {
                    show_validate_msg("#modifyName", "success", "");
                    // 关闭模态框
                    $("#modifyModal").modal("hide");
                    // 提示改名成功
                    alert("修改成功！");
                    // 修改成功以后重新显示文件信息
                    show();
                } else {
                    // 在模态框上显示错误信息
                    show_validate_msg("#modifyName", "error", result.extend.errorMsg);
                }
            }
        });
    });

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
    remove_validate("#modifyName");

    /**
     * 显示对应类别的文件
     *
     * @param ele
     */
    function navigate(ele) {
        var cid = $(ele).parent().val();
        $.ajax({
            url: "${APP_PATH}/file/getByCategory",
            data: "userId=" + userId + "&cid=" + cid,
            type: "GET",
            success: function (result) {
                build_file_table(result);
            }
        });
    }

    /**
     * 为导航栏的中的li绑定点击事件
     */
    $("#nav_img, #nav_sound, #nav_video, #nav_doc, #nav_rar, #nav_other").click(function () {
        navigate(this);
    });
    $("#nav_all").click(function () {
        show();
    });
    $("#nav_share").click(function () {
        // 发送ajax请求查询共享资源
        $.ajax({
            url: "${APP_PATH}/file/getPublic",
            type: "GET",
            success: function (result) {
                // 渲染共享资源的页面
                build_publicFile_table(result);
            }
        })
    });
    $("#nav_trash").click(function () {
        // 发送ajax请求查询回收站中的资源
        $.ajax({
            url: "${APP_PATH}/file/getTrash",
            data: "userId=" + userId,
            type: "GET",
            success: function (result) {
                // 渲染回收站页面
                build_trashFile_table(result);
            }
        });
    });

    /**
     * 显示共享资源列表
     * @param result
     */
    function build_publicFile_table(result) {
        $("#div_basicBtn").empty()
            .append("<button type='button' class='btn btn-default' id='btn_upload'>上传</button>")
            // .append("<button type='button' class='btn btn-default' id='btn_download_multiple'>下载</button>");
        // 清空文件列表的表头，重新设置一个表头
        $("#fileTable thead").empty();
        $("<tr></tr>").append("<td><input type='checkbox' id='check_all'></td>")
            .append("<th>文件名</th>")
            .append("<th>文件大小</th>")
            .append("<th>共享时间</th>")
            .append("<th>上传者</th>")
            .append("<th>操作</th>")
            .appendTo("#fileTable thead");
        // 清空table表格体
        $("#fileTable tbody").empty();
        // 得到文件信息集合
        var fileList = result.extend.fileList;
        $.each(fileList, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'></td>");

            var fileNameTd;
            var a;
            // 如果文件是图片或是文本文件类型，以超链接显示文件的名称，便于预览
            var username = ${sessionScope.session_user.username};
            if (item.category.cid === 1) {
                var path = "${APP_PATH}/file/previewImg?username=" + username + "&filename=" + item.fname;
                a = $("<a id='previewImg' target='_blank'></a>").text(item.fname).attr("href", path);
                fileNameTd = $("<td></td>").append(a);
            } else if (item.category.cid === 4) {
                a = $("<a id='previewOffice' href='javascript:void(0)'></a>").text(item.fname);
                fileNameTd = $("<td></td>").append(a);
            } else {
                fileNameTd = $("<td></td>").append(item.fname);
            }

            var fileSizeTd = $("<td></td>").append(item.fsize);
            // 处理文件状态的字符串得到文件的共享时间
            var fstatus = item.fstatus;
            var shareTime = fstatus.substring(2, fstatus.length);
            var uploadTimeTd = $("<td></td>").append(shareTime);
            var fileUserNameTd = $("<td></td>").append(item.user.username);
            var downloadBtn = $("<button data-toggle='tooltip' data-placement='top' title='下载'></button>")
                .addClass("btn btn-primary btn-sm btn_download")
                .append($("<span></span>")).addClass("glyphicon glyphicon-download-alt");
            // 为下载按钮带上文件名称和上传者，便于下载
            downloadBtn.attr("filename", item.fname);
            downloadBtn.attr("username", item.user.username);
            var btnTd = $("<td></td>").append(downloadBtn);
            $("<tr></tr>").append(checkBoxTd)
                .append(fileNameTd)
                .append(fileSizeTd)
                .append(uploadTimeTd)
                .append(fileUserNameTd)
                .append(btnTd)
                .appendTo("#fileTable tbody");
        });
    }

    /**
     * 显示回收站资源列表
     * @param result
     */
    function build_trashFile_table(result) {
        var emptyBtn = $("<button></button>").addClass("btn btn-danger btn-md btn_empty_all")
            .append($("<span></span>")).addClass("glyphicon glyphicon-remove-circle").append("清空回收站");
        // var restoreBtn = $("<button></button>").addClass("btn btn-success btn-md btn_restore_multiple")
        //     .append($("<span></span>")).addClass("glyphicon glyphicon-repeat").append("恢复");
        $("#div_basicBtn").empty()
            // .append(restoreBtn)
            .append(" ")
            .append(emptyBtn);
        // 清空表格头
        $("#fileTable thead").empty();
        // 清空table表格体
        $("#fileTable tbody").empty();

        $("<tr></tr>").append("<td><input type='checkbox' id='check_all'></td>")
            .append("<th>文件名</th>")
            .append("<th>文件大小</th>")
            .append("<th>删除时间</th>")
            .append("<th>操作</th>")
            .appendTo("#fileTable thead");
        // 得到文件信息集合
        var fileList = result.extend.fileList;
        $.each(fileList, function (index, item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'></td>");
            var fileNameTd = $("<td></td>").append(item.fname);
            var fileSizeTd = $("<td></td>").append(item.fsize);
            // 处理文件状态的字符串得到文件的删除时间
            var fstatus = item.fstatus;
            var deleteTime = fstatus.substring(2, fstatus.length);
            var uploadTimeTd = $("<td></td>").append(deleteTime);
            var deleteBtn = $("<button data-toggle='tooltip' data-placement='top' title='彻底删除'></button>")
                .addClass("btn btn-danger btn-sm btn_remove")
                .append($("<span></span>")).addClass("glyphicon glyphicon-trash");
            deleteBtn.attr("fid", item.fid);
            var restoreBtn = $("<button data-toggle='tooltip' data-placement='top' title='恢复文件'></button>")
                .addClass("btn btn-success btn-sm btn_restore")
                .append($("<span></span>")).addClass("glyphicon glyphicon-repeat");
            restoreBtn.attr("fid", item.fid);
            var btnTd = $("<td></td>").append(restoreBtn).append(" ").append(deleteBtn);
            $("<tr></tr>").append(checkBoxTd)
                .append(fileNameTd)
                .append(fileSizeTd)
                .append(uploadTimeTd)
                .append(btnTd)
                .appendTo("#fileTable tbody");
        });
    }

    /**
     * 用户个人文件的下载
     */
    $(document).on("click", ".btn_download", function () {
        var username = ${sessionScope.session_user.username};
        var filename = $(this).attr("filename");
        location.href = "${APP_PATH}/file/download?username=" + username + "&filename=" + filename;
    });

    /**
     * 共享文件的下载功能
     */
    $(document).on("click", ".btn_download_share", function () {
        var username = $(this).attr("username");
        var filename = $(this).attr("filename");
        location.href = "${APP_PATH}/file/download?username=" + username + "&filename=" + filename;
    });

    /**
     * 共享文件功能
     */
    $(document).on("click", ".btn_share", function () {
        $.ajax({
            url: "${APP_PATH}/file/shareFile",
            data: "fid=" + $(this).attr("fid"),
            success: function (result) {
                if (result.code === 200) {
                    // 将文件状态修改为“共享”
                    $(this).parents("tr").find("td:eq(4)").replaceWith($("<td>共享</td>"));
                    // 将按钮改为“取消共享”的按钮，并加上文件id属性
                    var cancelShareBtn = $("<button data-toggle='tooltip' data-placement='top' title='取消共享'></button>")
                        .addClass("btn btn-warning btn-sm btn_noshare")
                        .append($("<span></span>")).addClass("glyphicon glyphicon-remove")
                        .attr("fid", $(this).attr("fid"));
                    $(this).replaceWith(cancelShareBtn);
                }
            }.bind(this)
        });
    });

    /**
     * 取消文件共享
     */
    $(document).on("click", ".btn_noshare", function () {
        $.ajax({
            url: "${APP_PATH}/file/cancelShare",
            data: "fid=" + $(this).attr("fid"),
            success: function (result) {
                if (result.code === 200) {
                    $(this).parents("tr").find("td:eq(4)").replaceWith($("<td>私密</td>"));
                    var shareBtn = $("<button data-toggle='tooltip' data-placement='top' title='共享文件'></button>")
                        .addClass("btn btn-info btn-sm btn_share")
                        .append($("<span></span>")).addClass("glyphicon glyphicon-share")
                        .attr("fid", $(this).attr("fid"));
                    $(this).replaceWith(shareBtn);
                }
            }.bind(this)
        });
    });

    /**
     * 删除文件（将文件放入回收站）
     */
    $(document).on("click", ".btn_delete", function () {
        var filename = $(this).parents("tr").find("td:eq(1)").text();
        if (confirm("确认删除[" + filename + "]吗")) {
            $.ajax({
                url: "${APP_PATH}/file/trash",
                data: "fid=" + $(this).attr("fid"),
                success: function (result) {
                    if (result.code === 200) {
                        // 在页面上删除此条记录
                        $(this).parents("tr").remove();
                        alert("删除成功，文件已放入回收站。");
                    }
                }.bind(this)
            });
        }
    });

    /**
     * 在回收站中彻底删除文件
     */
    $(document).on("click", ".btn_remove", function () {
        var username = ${sessionScope.session_user.username};
        var filename = $(this).parents("tr").find("td:eq(1)").text();
        var fid = $(this).attr("fid");
        if (confirm("确认要永久性删除[" + filename + "]吗？")) {
            $.ajax({
                url: "${APP_PATH}/file/delete",
                data: "fid=" + fid + "&username=" + username + "&filename=" + filename,
                success: function (result) {
                    if (result.code === 200) {
                        $(this).parents("tr").remove();
                        alert("文件已永久性删除！");
                    } else {
                        alert("文件删除出现异常状况，请与管理员联系！");
                    }
                }.bind(this)
            });
        }
    });

    /**
     * 将回收站的文件恢复
     */
    $(document).on("click", ".btn_restore", function () {
        var fid = $(this).attr("fid");
        $.ajax({
            url: "${APP_PATH}/file/restore",
            data: "fid=" + fid,
            success: function (result) {
                if (result.code === 200) {
                    $(this).parents("tr").remove();
                    alert("已恢复！");
                }
            }.bind(this)
        });
    });

    /**
     * 全选/全不选
     */
    $(document).on("click", "#check_all", function () {
        // 使用attr不能操作，attr是针对于自定义属性。checked这种原生的dom属性，应该使用prop。
        $(".check_item").prop("checked", $(this).prop("checked"))
    });

    /**
     * 选中所有check_item时，check_all也要选中
     */
    $(document).on("click", ".check_item", function () {
        // 判断当前选中的元素是否是全部
        var flag = $(".check_item:checked").length === $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    /**
     * 批量放入回收站
     */
    $(document).on("click", "#btn_delete_multiple", function () {
        // 用来拼接文件名称
        var fileNames = "";
        var checkItems = $(".check_item:checked");
        if (checkItems.size() === 0) {
            alert("清先选中文件！");
        } else {
            $.each(checkItems, function () {
                fileNames += $(this).parents("tr").find("td:eq(1)").text() + ",";
            });
            fileNames = fileNames.substring(0, fileNames.length - 1);
            if (confirm("确认删除 [" + fileNames + "] 吗")) {
                // 发送ajax请求删除
                $.ajax({
                    url: "${APP_PATH}/file/trashMultiple",
                    data: "userId=" + userId + "&fileNames=" + fileNames,
                    success: function (result) {
                        if (result.code === 200) {
                            alert("文件已经放入回收站");
                            // 在页面上删除记录
                            $(".check_item:checked").parents("tr").remove();
                        }
                    }
                });
            }
        }
    });

    /**
     * 批量共享
     */
    $(document).on("click", "#btn_share_multiple", function () {
        // 用来拼接文件名称
        var fileNames = "";
        var checkItems = $(".check_item:checked");
        if (checkItems.size() === 0) {
            alert("清先选中文件！");
        } else {
            $.each(checkItems, function () {
                fileNames += $(this).parents("tr").find("td:eq(1)").text() + ",";
            });
            fileNames = fileNames.substring(0, fileNames.length - 1);
            $.ajax({
                url: "${APP_PATH}/file/shareMultiple",
                data: "userId=" + userId + "&fileNames=" + fileNames,
                success: function (result) {
                    if (result.code === 200) {
                        alert("已成功分享");
                        $.each(checkItems, function () {
                            // 将文件状态修改为“共享”
                            $(this).parents("tr").find("td:eq(4)").replaceWith($("<td>共享</td>"));
                            // 将按钮改为“取消共享”的按钮，并加上文件id
                            var fid = $(this).parents("tr").find("td:eq(5)").find("button:eq(1)").attr("fid");
                            var cancelShareBtn = $("<button data-toggle='tooltip' data-placement='top' title='取消共享'></button>")
                                .addClass("btn btn-warning btn-sm btn_noshare")
                                .append($("<span></span>")).addClass("glyphicon glyphicon-remove")
                                .attr("fid", fid);
                            $(this).parents("tr").find("td:eq(5)").find("button:eq(1)").replaceWith(cancelShareBtn);
                            // 取消选中的状态
                            $(this).parents("tr").find("td:eq(0)").find("input").removeProp("checked");
                        });
                    }
                }
            });
        }
    });

    /**
     * 清空回收站
     */
    $(document).on("click", ".btn_empty_all", function () {
        var username = ${sessionScope.session_user.username};
        if (confirm("确认永久删除回收站中的所有文件吗？")) {
            $.ajax({
                url: "${APP_PATH}/file/emptyTrash",
                data: "userId=" + userId + "&username=" + username,
                success: function (result) {
                    if (result.code === 200) {
                        // 模拟用户点击事件
                        $("#nav_trash").trigger("click");
                        alert("回收站已清空！");
                    }
                }
            });
        }
    });

    /**
     * 开通会员
     */
    $("#openVip").click(function () {
        $.ajax({
            url: "${APP_PATH}/user/sendEmail",
            success: function (result) {
                if (result.code === 200) {
                    alert("请去邮箱验证开通会员！");
                } else {
                    alert("开通失败！请联系管理员！")
                }
            }
        });
    });

    /**
     * 预览图片
     */
    <%--$(document).on("click", "#previewImg", function () {--%>
        // 获取文件名称
        <%--var filename = $(this).text();--%>
        <%--// 获取用户名--%>
        <%--var username = ${sessionScope.session_user.username};--%>
    <%--    // 发送ajax请求去后台进行处理--%>
    <%--    $.ajax({--%>
    <%--        url: "${APP_PATH}/file/previewImg",--%>
    <%--        data: "filename=" + filename +  "&username=" + username,--%>
    <%--    });--%>
    <%--});--%>

    /**
     * 预览文本文件
     */
    $(document).on("click", "#previewOffice", function () {
        // 获取文件名称
        var filename = $(this).text();
        // 获取用户名
        var username = ${sessionScope.session_user.username};
        // 发送ajax请求去后台
        $.ajax({
            url: "${APP_PATH}/file/previewOffice",
            data: "username=" + username + "&filename=" + filename,
            success: function (result) {
                if (result.code === 200) {
                    var path = "${APP_PATH}/pdfjs/web/viewer.html?file=../../preview/" + result.extend.urlName;
                    window.open(path);
                }
            }
        })
    });

</script>

</body>
</html>
