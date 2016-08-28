<user-invitation xmlns:th="http://www.thymeleaf.org">
    <div id="wr-page-header">
        <div class="page-header container-fluid">
            <div class="pull-left">
                <h1 th:text="#{InviteNew}">Invite New User</h1>
            </div>
        </div>
    </div>
    <div id="wr-page-content">
        <div class="container-fluid">
            <div class="alert alert-success" th:if="${resentInvitation ne null}">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                再送信しました。
            </div>
            <div class="alert alert-success" th:if="${deletedInvitation ne null}">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                削除しました。
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <section style="margin:0 0 5em;">
                        <form th:action="@{__${ADMIN_PATH}__/users/invitations/create(query=${query})}" th:object="${form}" method="post" class="form-horizontal" >
                            <fieldset>
                                <div class="form-group" th:classappend="${#fields.hasErrors('invitees')}? has-error">
                                    <div class="col-sm-12">
                                        <textarea th:field="*{invitees}" class="form-control" th:attr="placeholder=#{MultipleEmail}"></textarea>
                                        <span class="help-block" th:each="err : ${#fields.errors('invitees')}" th:text="${err}" />
                                    </div>
                                </div>
                                <div class="form-group" th:classappend="${#fields.hasErrors('message')}? has-error">
                                    <div class="col-sm-12">
                                        <textarea th:field="*{message}" class="form-control" th:attr="placeholder=#{Message}"></textarea>
                                        <span class="help-block" th:each="err : ${#fields.errors('message')}" th:text="${err}" />
                                    </div>
                                </div>
                                <div class="btn-group">
                                    <button class="btn btn-primary" data-loading-text="sending..." th:text="#{Send}">送信</button>
                                </div>
                            </fieldset>
                        </form>
                    </section>
                    <section>
                        <h2 th:text="#{PastInvitations}">過去の招待状</h2>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th th:text="#{Invitee}">招待先</th>
                                    <th th:text="#{SentBy}">送信者</th>
                                    <th th:text="#{DateSent}">送信日</th>
                                    <th th:text="#{DateAccepted}">承認日</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr th:each="invitation : ${invitations}">
                                    <td th:text="${invitation.email}" style="font-weight: bold">send@tagbangers.co.jp</td>
                                    <td th:text="${invitation.createdBy}">Ogatakex</td>
                                    <td th:text="${#temporals.format(invitation.createdAt, 'yyyy/MM/dd HH:mm')}"></td>
                                    <td th:text="${invitation.accepted ? 'Accepted' : 'Waiting'}">Waiting</td>
                                    <td>
                                        <ul class="list-inline">
                                            <li style="margin-right:15px"><a th:href="@{__${ADMIN_PATH}__/users/invitations/resend(token=${invitation.token},query=${query})}"><span class="glyphicon glyphicon-send"></span> <span th:text="#{Resend}">再送信</span></a></li>
                                            <li><a th:href="@{__${ADMIN_PATH}__/users/invitations/delete(token=${invitation.token},query=${query})}"><span class="glyphicon glyphicon-remove"></span> <span th:text="#{Delete}">削除</span></a></li>
                                        </ul>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </section>
                </div>
            </div>
        </div>
    </div>
</user-invitation>
