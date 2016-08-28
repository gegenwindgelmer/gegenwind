<article-describe xmlns:th="http://www.thymeleaf.org">
    <div id="wr-page-header">
        <div class="page-header container-fluid clearfix">
            <div class="row">
                <div class="col-sm-9">
                    <div class="pull-left back">
                        <a class="btn btn-sm btn-default" th:href="@{__${ADMIN_PATH}__/articles/index(query=${query})}"><span class="glyphicon glyphicon-arrow-left"></span></a>
                    </div>
                    <div class="pull-left">
                        <h1 th:text="${article.title}?:'(No Titled)'">(No Titled)</h1>
                        <p class="small"><a th:href="@{__${WEBSITE_PATH}____${#posts.path(article)}__}" th:text="@{__${WEBSITE_PATH}____${#posts.path(article)}__}" th:if="${#strings.toString(article.status) eq 'PUBLISHED'}" target="_blank"></a></p>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="pull-left">
                        <div class="tools clearfix">
                            <div class="status">
                                <span th:if="${#strings.toString(article.status) eq 'DRAFT'}" class="glyphicon glyphicon-warning-sign"></span>
                                <span th:if="${#strings.toString(article.status) eq 'SCHEDULED'}" class="glyphicon glyphicon-time"></span>
                                <span th:if="${#strings.toString(article.status) ne 'PUBLISHED'}" th:text="${#messages.msg('Post.Status.' + article.status)}">Published</span>
                                <a th:href="@{__${WEBSITE_PATH}____${#posts.path(article)}__}" th:if="${#strings.toString(article.status) eq 'PUBLISHED'}" target="_blank">
                                    <span class="glyphicon glyphicon-globe"></span>
                                    <span th:text="${#messages.msg('Post.Status.' + article.status)}">Published</span>
                                </a>
                            </div>
                            <p class="small"><span th:if="${article.date ne null}" th:text="${#temporals.format(article.date, 'yyyy/MM/dd HH:mm')}"></span></p>
                        </div>
                    </div>
                    <div class="pull-right">
                        <div class="btn-group">
                            <div th:classappend="${prev eq null}?'disabled'" class="previous">
                                <a class="btn btn-default" th:href="${prev ne null} ? @{__${ADMIN_PATH}__/articles/describe(id=${prev},query=${query})} : '#'"><span class="glyphicon glyphicon-chevron-left"></span></a>
                            </div>
                        </div>
                        <div class="btn-group">
                            <div th:classappend="${next eq null}?'disabled'" class="next">
                                <a class="btn btn-default" th:href="${next ne null} ? @{__${ADMIN_PATH}__/articles/describe(id=${next},query=${query})} : '#'"><span class="glyphicon glyphicon-chevron-right"></span></a>
                            </div>
                        </div>
                        <div class="btn-group">
                            <a th:href="@{__${ADMIN_PATH}__/articles/edit(id=${article.id},query=${query})}" type="button" class="btn btn-info" th:text="#{Edit}">Edit</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="wr-page-content">
        <div class="container-fluid">
            <div class="row" th:if="${article ne null}">
                <div class="col-sm-9 wr-describe-main">
                    <div class="alert alert-success" th:if="${savedArticle ne null}">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <span th:text="#{SavedArticle}">Article saved.</span>
                    </div>
                    <div>
                        <img th:if="${article.cover ne null}" th:src="@{${#medias.link(article.cover)}(w=1200,h=500,m=1)}" class="wr-post-cover" />
                    </div>
                    <div class="wr-post-body clearfix">
                        <p th:utext="${#posts.body(article)}"></p>
                    </div>
                    <hr/>
                    <p><span class="glyphicon glyphicon-user"></span> Created By <a th:href="@{__${ADMIN_PATH}__/users/describe(id=${article.author.id})}" th:text="${article.author}">Author</a></p>
                </div>
                <div class="col-sm-3 wr-tool-panel">
                    <dl class="tools clearfix">
                        <dt th:text="#{Categories}">Categories</dt>
                        <dd>
                            <ul class="list-unstyled list-inline">
                                <li th:each="category : ${article.categories}"><a th:href="@{__${ADMIN_PATH}__/articles/index(categoryId=${category.id})}" th:text="${category.name}">Category Name</a></li>
                            </ul>
                        </dd>
                    </dl>
                    <dl class="wr-tags">
                        <dt th:text="#{Tags}">Tags</dt>
                        <dd>
                            <ul class="list-unstyled list-inline list-inline-tag">
                                <li th:each="tag : ${article.tags}"><a th:href="@{__${ADMIN_PATH}__/articles/index(tagId=${tag.id})}"><span class="label label-default"><span class="glyphicon glyphicon-tag"></span> <span th:text="${tag.name}"></span></span></a></li>
                            </ul>
                        </dd>
                    </dl>
                    <dl>
                        <dt th:text="#{RelatedPosts}">Related Posts</dt>
                        <dd>
                            <ul class="list-unstyled">
                                <li th:each="relatedPost : ${article.relatedToPosts}"><a th:href="@{__${ADMIN_PATH}__/posts/describe(id=${relatedPost.id})}"><span class="glyphicon glyphicon-link"></span> <span th:text="${relatedPost.title}"></span></a></li>
                            </ul>
                        </dd>
                    </dl>
                    <dl>
                        <dt th:text="#{Seo}">SEO</dt>
                        <dd>
                            <dl>
                                <dt th:text="#{SeoTitle}">Title</dt>
                                <dd th:text="${article.seo}? ${article.seo.title}"></dd>
                                <dt th:text="#{SeoDescription}">Description</dt>
                                <dd th:text="${article.seo}? ${article.seo.description}"></dd>
                                <dt th:text="#{SeoKeywords}">Keywords</dt>
                                <dd th:text="${article.seo}? ${article.seo.keywords}"></dd>
                            </dl>
                        </dd>
                    </dl>
                    <dl th:each="fieldValue : ${article.customFieldValues}">
                        <dt th:unless="${fieldValue.isEmpty()}" th:text="${fieldValue.customField.name}"></dt>
                        <dd th:switch="${#strings.toString(fieldValue.customField.fieldType)}">
                            <span th:case="'TEXT'" th:text="${fieldValue.stringValue}"></span>
                            <span th:case="'SELECTBOX'" th:text="${fieldValue.stringValue}"></span>
                            <span th:case="'CHECKBOX'" th:text="${fieldValue.textValue}"></span>
                            <span th:case="'RADIO'" th:text="${fieldValue.stringValue}"></span>
                            <span th:case="'TEXTAREA'" th:text="${fieldValue.textValue}"></span>
                            <span th:case="'HTML'" th:utext="${fieldValue.textValue}"></span>
                            <span th:case="'DATE'" th:text="${fieldValue.dateValue}"></span>
                            <span th:case="'DATETIME'" th:text="${fieldValue.datetimeValue}"></span>
                            <span th:case="'NUMBER'" th:text="${fieldValue.numberValue}"></span>
                        </dd>
                    </dl>
                    <a th:href="@{__${ADMIN_PATH}__/articles/describe(part=delete-form,id=${article.id},query=${query})}" data-toggle="modal" data-target="#delete-modal"><span class="glyphicon glyphicon-trash"></span> <span th:text="#{DeleteArticle}">記事を削除</span></a>
                    <!-- #delete-modal -->
                    <div id="delete-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div id="delete-dialog" class="modal-dialog">
                            <div class="modal-content">
                                <form th:fragment="delete-form" th:action="@{__${ADMIN_PATH}__/articles/delete(id=${article.id},query=${query})}" method="post">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                        <h4 class="modal-title" th:text="#{DeleteArticle}">Delete Article</h4>
                                    </div>
                                    <div class="modal-body">
                                        <p th:text="#{MakeSureDelete}">Are you sure you want to delete?</p>
                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-default" data-dismiss="modal" th:text="#{Cancel}">Cancel</button>
                                        <button class="btn btn-primary" th:text="#{Delete}">Delete</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!--/#delete-modal -->
                    <script th:inline="javascript">
                        // <![CDATA[
                        $(function() {
                            $('#delete-modal').on('hidden.bs.modal', function() {
                                $(this).removeData('bs.modal');
                            });
                            $('img', '#wr-page-content').addClass('img-responsive');
                        });
                        // ]]>
                    </script>
                </div>
                <div class="alert alert-warning" th:unless="${article ne null}">
                    <strong>Not Found.</strong> May be deleted.
                </div>
            </div>
        </div>
    </div>
</article-describe>
