<user-describe xmlns:th="http://www.thymeleaf.org">
    <div>
        <div id="wr-page-header">
            <div class="page-header container-fluid">
                <div class="pull-left">
                    <h1 th:text="${user.name}">Name</h1>
                </div>
                <div class="pull-right">
                    <div class="btn-group">
                        <div th:classappend="${prev eq null}?'disabled'" class="previous">
                            <a class="btn btn-default" th:href="${prev ne null} ? @{__${ADMIN_PATH}__/users/describe(id=${prev},query=${query})} : '#'"><span class="glyphicon glyphicon-chevron-left"></span></a>
                        </div>
                    </div>
                    <div class="btn-group">
                        <div th:classappend="${next eq null}?'disabled'" class="next">
                            <a class="btn btn-default" th:href="${next ne null} ? @{__${ADMIN_PATH}__/users/describe(id=${next},query=${query})} : '#'"><span class="glyphicon glyphicon-chevron-right"></span></a>
                        </div>
                    </div>
                    <div class="btn-group">
                        <a th:href="@{__${ADMIN_PATH}__/users/edit(id=${user.id},query=${query})}" title="編集" type="button" class="btn btn-info" th:text="#{Edit}">編集</a>
                    </div>
                </div>
            </div>
        </div>
        <div id="wr-page-content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-12 describe">
                        <div style="margin-bottom: 15px ; position: relative;">
                            <div class="image-box">
                                <img style="width:150px; border-radius: 50%" th:src="${user.getGravatarUrl(170)}" src="http://placehold.it/170/eeeeee/ffffff"/>
                                <!--/*
                                <div class="btn-group">
                                    <a href="#" type="button" class="btn btn-info" data-toggle="modal" data-target="#change-avatar-modal">Change Avatar</a>
                                </div>
                                */-->
                            </div>
                        </div>
                        <table class="table">
                            <tr>
                                <th th:text="#{LoginId}">ログインID</th>
                                <td th:text="${user.loginId}">ログインID</td>
                            </tr>
                            <tr>
                                <th>URL</th>
                                <td><a th:href="${#users.link(user)}" target="_blank"><span class="glyphicon glyphicon-share-alt"></span> <span th:text="${#users.link(user, false)}">http://</span></a></td>
                            </tr>
                            <tr>
                                <th th:text="#{Nickname}">Nickname</th>
                                <td th:text="${user.nickname}"></td>
                            </tr>
                            <tr>
                                <th th:text="#{Email}">メールアドレス</th>
                                <td th:text="${user.email}">メールアドレス</td>
                            </tr>
                            <tr>
                                <th>プロフィール</th>
                                <td>
                                    <pre th:utext="${user.description}"></pre>
                                </td>
                            </tr>
                            <tr>
                                <th th:text="#{Posts}">投稿記事数</th>
                                <td th:text="${articleCounts.get(user.id)}?:0">投稿記事数</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div id="change-avatar-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
            <div id="change-avatar-dialog" class="modal-dialog">
                <form method="post">
                    <div th:fragment="change-avatar-form" class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title">Change Avatar</h4>
                        </div>
                        <div class="modal-body" style="min-height: 118px;">
                            <p>Select a new image</p>
                            <div class="container">
                                <div class="row">
                                    <div class="col-md-4">
                                        <input type="radio" name="from" value="computer" selected="true"/> From your computer. <br/>
                                        <input type="radio" name="from" value="internet"/> From internet.
                                    </div>
                                    <div class="col-md-8">
                                        <div class="form-group">
                                            <input type="file" name="newAvatar" class="btn-default"/>
                                            <input type="text" name="newAvatar" class="form-control" placeholder="Enter your image's url"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                            <button class="btn btn-primary" th:attr="data-action=@{__${ADMIN_PATH}__/users/change-avatar(query=${query})}">Change</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script th:inline="javascript">
            $(function () {
                $('#change-avatar-modal .form-group input[type="text"]').hide().attr('disabled', 'true');

                $('#change-avatar-modal').on('change', 'input[type="radio"]', function () {
                    var from = $(this).val();
                    if (from == 'computer') {
                        $('#change-avatar-modal .form-group input[type="text"]').hide().attr('disabled', 'true');
                        $('#change-avatar-modal .form-group input[type="file"]').show().removeAttr('disabled');
                    } else {
                        $('#change-avatar-modal .form-group input[type="text"]').show().removeAttr('disabled');
                        $('#change-avatar-modal .form-group input[type="file"]').hide().attr('disabled', 'true');
                    }
                });
            });
        </script>

    </div>
    <style>
        #wr-page-content .describe div.btn-group {
            cursor: pointer;
            position: absolute;
            top: 89px;
            left: 20px;
            display: none;

        }

        #wr-page-content .describe .image-box {
            display: inline-block;
        }

        #wr-page-content .describe .image-box:hover .btn-group {
            display: block;
        }

        #change-avatar-modal button {
            position: relative;
        }

        #change-avatar-modal button input {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: 0;
        }
    </style>
</user-describe>
