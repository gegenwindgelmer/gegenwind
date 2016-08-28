<customfield-edit xmlns:th="http://www.thymeleaf.org">
    <div id="wr-page-header">
        <div class="page-header container-fluid">
            <h1 th:text="#{EditCustomField}">ユーザー編集</h1>
        </div>
    </div>
    <div id="wr-page-content">
        <div class="container-fluid">
            <form id="custom-field-form" class="form-horizontal" th:include="customfield/create::form(title=#{EditCustomField},customfield=${customField})" th:action="@{__${ADMIN_PATH}__/customfields/edit(query=${query})}" th:object="${form}" action="#" method="post">
            </form>
        </div>
    </div>
</customfield-edit>
