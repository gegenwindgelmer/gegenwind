<page-create xmlns:th="http://www.thymeleaf.org">
    <div>
        <form id="wr-post-form" th:fragment="form(title,id, page)" th:action="@{__${ADMIN_PATH}__/pages/create(query=${query})}" th:object="${form}" action="#" method="post">
            <input type="hidden" name="id" th:value="${page}? ${page.id} : ''"  />
            <div id="wr-page-header">
                <div class="page-header container-fluid">
                    <div class="pull-left">
                        <div class="btn-group back">
                            <a class="btn btn-sm btn-default" th:href="${page} ? @{__${ADMIN_PATH}__/pages/describe(id=${page.id},query=${query})} : @{__${ADMIN_PATH}__/pages/index(query=${query})}"><span class="glyphicon glyphicon-arrow-left"></span></a>
                        </div>
                    </div>
                    <div class="pull-left">
                        <h1 th:text="${title}?:#{AddNewPage}">Add New Page</h1>
                    </div>
                    <div class="pull-right">
                        <div class="tools clearfix">
                            <div class="btn-group">
                                <a id="page-preview" class="btn btn-default" href="#"> <span th:text="#{Preview}">Preview</span></a>
                            </div>
                            <script th:inline="javascript">
                                $(function() {
                                    $('#wr-page-header').on('click', '#page-preview', function(e) {
                                        e.preventDefault();
                                        var form = $(this).closest('form').clone();
                                        var action = /*[[@{__${ADMIN_PATH}__/pages/preview}]]*/ '#';
                                        form.attr('action', action);
                                        form.attr('target', '_blank');
                                        $(':input[name="body"]', form).val($('#wr-page-content :input[name="body"]').froalaEditor('html.get'));
                                        form.submit();
                                    });
                                });
                            </script>
                            <div class="btn-group">
                                <button id="save-draft-button" name="draft" class="btn btn-default" data-loading-text="Saving..." th:text="#{SaveDraft}">Save Draft</button>
                            </div>
                            <script th:inline="javascript">
                                $(document).ready(function() {
                                    $('#save-draft-button').click(function(e) {
                                        var $this = $(this);
                                        $this.button('loading');
                                        var $form = $this.closest('form');
                                        $(':input[name="body"]', $form).val($('#wr-page-content :input[name="body"]').froalaEditor('html.get'));
                                        var data = $form.serializeArray();
                                        data.push({name: 'draft', value: 1});
                                        $.ajax({
                                            type: "POST",
                                            url: $form.attr('action'),
                                            data: data,
                                            success: function(data) {
                                                $form.children(':input[name="id"]').val(data.id);
                                                $form.attr('action', [[@{__${ADMIN_PATH}__/pages/edit(query=${query})}]]);
                                                var url = [[@{__${ADMIN_PATH}__/pages/edit?id=}]] + data.id;
                                                history.replaceState(null, null, url);
                                                new PNotify({
                                                    icon: false,
                                                    title: /*[[#{SavedAsDraft}]]*/ 'Saved as draft',
                                                    type: 'success',
                                                    delay: 3000,
                                                    buttons: {
                                                        sticker: false
                                                    }
                                                });
                                            },
                                            complete: function() {
                                                $this.button('reset');
                                            }
                                        });
                                        return false;
                                    });
                                });
                            </script>
                            <div class="btn-group">
                                <button name="publish" class="btn btn-primary" th:text="#{Publish}">Publish</button>
                                <th:block th:if="${page} ne null and ${#strings.toString(page.status)} ne 'DRAFT'">
                                    <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                        <span class="caret"></span>
                                        <span class="sr-only">Toggle Dropdown</span>
                                    </button>
                                    <ul id="save-menu" class="dropdown-menu pull-right" role="menu">
                                        <li><a href="#" data-name="publish" th:text="#{Publish}">Publish</a></li>
                                        <li><a href="#" data-name="unpublish" th:text="#{Unpublish}">Unpublish</a></li>
                                    </ul>
                                    <script>
                                        $(document).ready(function() {
                                            $('#save-menu a').click(function() {
                                                var $this = $(this);
                                                var $target = $this.closest('.btn-group').children('button:first');
                                                $target.text($this.text());
                                                $target.attr('name', $this.data('name'));
                                            });
                                        });
                                    </script>
                                </th:block>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="wr-page-content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-9">
                            <div class="alert alert-success" th:if="${savedPage ne null}">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <span th:text="#{SavedPage}">Page saved.</span>
                            </div>
                            <div class="alert alert-danger" th:if="${#fields.hasErrors('all')}">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                Error.
                            </div>
                            <div class="alert alert-info" th:if="${draft} ne null">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <span th:text="#{YouHaveDraft}">You have draft.</span><a th:href="@{__${ADMIN_PATH}__/pages/edit(id=${draft.drafted.id},draft,query=${query})}"><span th:text="#{CopyDraft}">Copy draft</span></a>
                            </div>
                            <div class="alert alert-info" th:if="${original ne null}">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <span th:text="#{LanguageNotFound(${#messages.msg('Language.' + #locale.language)}, ${original.title})}">There is no {0} version of "{1}".</span>
                            </div>
                            <fieldset>
                                <div class="form-group">
                                    <div id="post-cover-dropzone" class="wr-post-cover-dropzone col-sm-12" style="">
                                        <p class="placeholder help-block" th:text="#{CoverImage}">Cover Image</p>
                                        <div class="dragover hide"><span class="help-block">Drop files here</span></div>
                                        <div th:classappend="${form.coverId}? '' : 'hide'" class="image-wrap">
                                            <img th:if="${form.coverId ne null}" th:src="@{${#medias.link(form.coverId)}(w=1200,h=500,m=1)}" class="wr-post-cover" />
                                            <div class="remove"><a href="#"><span class="glyphicon glyphicon-remove"></span></a></div>
                                        </div>
                                        <div class="progress hide"><div class="progress-bar progress-bar-success"></div></div>
                                        <input type="hidden" th:field="*{coverId}" />
                                    </div>
                                </div>
                                <script th:inline="javascript">
                                    $(function() {
                                        $('#post-cover-dropzone').fileupload({
                                            url: /*[[@{__${ADMIN_PATH}__/media/create.json}]]*/ '#',
                                            paramName: 'file',
                                            dropZone: $('#post-cover-dropzone'),
                                            dragover: function(e) {
                                                var dropZone = $('#post-cover-dropzone');
                                                var timeout = window.dropZoneTimeout;
                                                if (!timeout) {
                                                    $('#post-cover-dropzone .dragover').removeClass('hide');
                                                } else {
                                                    clearTimeout(timeout);
                                                }
                                                var found = false;
                                                var node = e.target;
                                                do {
                                                    if (node === dropZone[0]) {
                                                        found = true;
                                                        break;
                                                    }
                                                    node = node.parentNode;
                                                } while (node != null);
                                                if (found) {
                                                    $('#post-cover-dropzone .dragover').removeClass('hide');
                                                }
                                                else {
                                                    $('#post-cover-dropzone .dragover').addClass('hide');
                                                }
                                                window.dropZoneTimeout = setTimeout(function () {
                                                    window.dropZoneTimeout = null;
                                                    $('#post-cover-dropzone .dragover').addClass('hide');
                                                }, 100);
                                            },
                                            start: function(e) {
                                                $('#post-cover-dropzone .progress').removeClass('hide');
                                            },
                                            progressall: function (e, data) {
                                                var progress = parseInt(data.loaded / data.total * 100, 10);
                                                $('#post-cover-dropzone .progress-bar').css('width', progress + '%');
                                            },
                                            done: function(e, data) {
                                                $('#post-cover-dropzone :input[name="coverId"]').val(data.result.id);
                                                $('#post-cover-dropzone .progress').addClass('hide');
                                                $('#post-cover-dropzone .progress-bar').css('width', '0%');
                                                var img = $('<img class="wr-post-cover" />').attr('src', data.result.link + '?' + $.param({w: 1200, h: 500, m: 1}));
                                                $('#post-cover-dropzone img').remove();
                                                $('#post-cover-dropzone').append(img);
                                                $('#post-cover-dropzone .image-wrap').removeClass('hide');
                                            }
                                        });
                                        $('#post-cover-dropzone .remove').click(function(e) {
                                            $('#post-cover-dropzone :input[name="coverId"]').val('');
                                            $('#post-cover-dropzone .image-wrap').addClass('hide');
                                            $('#post-cover-dropzone img').remove();
                                            e.preventDefault();
                                        });
                                    });
                                </script>
                            </fieldset>
                            <fieldset>
                                <div class="form-group" th:classappend="${#fields.hasErrors('title')}? has-error">
                                    <input type="text" th:field="*{title}" class="form-control" th:attr="placeholder=#{EnterTitle}" />
                                    <span class="help-block" th:each="err : ${#fields.errors('title')}" th:text="${err}" />
                                </div>
                            </fieldset>
                            <fieldset>
                                <div class="form-group" th:classappend="${#fields.hasErrors('code')}? has-error">
                                    <span th:text="${WEBSITE_LINK + '/'}"></span> <input type="text" th:field="*{code}" class="form-control input-sm wr-code" name="path" placeholder="URLパス" th:attr="placeholder=#{URLPath}" />
                                    <span class="help-block" th:each="err : ${#fields.errors('code')}" th:text="${err}" />
                                </div>
                            </fieldset>
                            <fieldset>
                                <div class="form-group" th:classappend="${#fields.hasErrors('body')}? has-error">
                                    <textarea th:field="*{body}" class="form-control" placeholder="Enter body here" th:attr="placeholder=#{EnterBody}"></textarea>
                                    <span class="help-block" th:each="err : ${#fields.errors('body')}" th:text="${err}" />
                                    <script th:inline="javascript" th:replace="froala::setting(selector='#wr-page-content :input[name=body]')"></script>
                                </div>
                            </fieldset>
                        </div>
                        <div class="col-sm-3 wr-tool-panel">
                            <fieldset>
                                <legend th:text="#{Date}">Date</legend>
                                <div class="form-group row" th:classappend="${#fields.hasErrors('date')}? has-error">
                                    <div class="col-sm-12">
                                        <input type="text" name="date" th:value="*{date ne null ? #temporals.format(date, 'yyyy/MM/dd HH:mm') : ''}" class="form-control" placeholder="YYYY/MM/DD HH:mm"/>
                                    </div>
                                    <script>
                                        $(document).ready(function() {
                                            $(':input[name="date"]').datetimepicker({});
                                        });
                                    </script>
                                    <span class="help-block" th:each="err : ${#fields.errors('date')}" th:text="${err}" />
                                </div>
                            </fieldset>
                            <fieldset>
                                <legend th:text="#{ParentPage}">Parent Page</legend>
                                <div class="form-group">
                                    <select name="parentId" class="form-control" th:field="*{parentId}" >
                                        <option value="">Select Parent Page</option>
                                        <option th:each="page : ${#pages.getAllPages(true)}" th:if="${page.id ne id}" th:value="${page.id}" th:text="${page.title}" th:selected="${page.id eq parentId}"></option>
                                    </select>
                                </div>
                            </fieldset>
                            <fieldset id="category-fieldset">
                                <legend th:text="#{Categories}">Categories</legend>
                                <section>
                                    <ul th:unless="${#lists.isEmpty(categoryNodes)}" th:include="page/create::category-index(${categoryNodes})" id="category-index" class="list-unstyled"></ul>
                                    <ul th:fragment="category-index(nodes)">
                                        <li th:each="node : ${nodes}" class="checkbox">
                                            <label><input type="checkbox" name="categoryIds" th:value="${node.object.id}" th:text="${node.object.name}" th:checked="${#sets.contains(form.categoryIds, node.object.id)}" /></label>
                                            <ul th:unless="${#lists.isEmpty(node.children)}" th:include="page/create::category-index(${node.children})" class="list-unstyled"></ul>
                                        </li>
                                    </ul>
                                    <a th:href="@{__${ADMIN_PATH}__/categories/index?part=category-create-form}" data-toggle="modal" data-target="#category-create-modal"><span class="glyphicon glyphicon-plus"></span> <span th:text="#{AddNewCategory}">Add New Category</span></a>
                                </section>
                            </fieldset>
                            <fieldset>
                                <legend th:text="#{Tags}">Tags</legend>
                                <div class="form-group row" th:classappend="${#fields.hasErrors('tags')}? has-error">
                                    <div class="col-sm-12">
                                        <input id="tags-field" type="text" th:field="*{tags}" style="width: 100%" placeholder=""/>
                                    </div>
                                    <span class="help-block" th:each="err : ${#fields.errors('tags')}"  th:text="${err}" />
                                </div>
                            </fieldset>
                            <script th:inline="javascript">
                                /*<![CDATA[*/
                                $(function() {
                                    $('#tags-field').select2({
                                        minimumInputLength: 1,
                                        multiple: true,
                                        createSearchChoice:function(term, data) {
                                            if ($(data).filter(function() {
                                                        return this.text.localeCompare(term)===0;
                                                    }).length===0) {
                                                return {id: term, text:term};
                                            }
                                        },
                                        ajax: {
                                            url:  /*[[@{__${ADMIN_PATH}__/tags/select}]]*/ '#',
                                            dataType: 'json',
                                            data: function (term, page) {
                                                return {
                                                    keyword: term
                                                };
                                            },
                                            results: function (data, page) {
                                                var results = [];
                                                $.each(data, function() {
                                                    results.push({id: this.text, text: this.text});
                                                });
                                                return {results: results};
                                            }
                                        },
                                        initSelection: function(element, callback) {
                                            var data = [];
                                            $(element.val().split(',')).each(function() {
                                                var id = this;
                                                if (id !== "") {
                                                    data.push({id: id, text: id});
                                                }
                                            });
                                            element.val('');
                                            callback(data);
                                        }
                                    });
                                });
                                /*]]>*/
                            </script>
                            <script th:inline="javascript">
                                /*<![CDATA[*/
                                $(function() {
                                    $(document).on('click', '#save-category', function(e) {
                                        e.preventDefault();
                                        var self = $(this);
                                        self.button('loading');
                                        var checked = [];
                                        $('input[name="categoryIds"]:checked', '#wr-post-form').each(function(i, element) {
                                            checked.push($(element).val());
                                        });
                                        var form = self.closest('form');
                                        var data = {
                                            parentId: $(':input[name="parentId"]', form).val(),
                                            code: $(':input[name="code"]', form).val(),
                                            name: $(':input[name="name"]', form).val(),
                                            description: $(':input[name="description"]', form).val()
                                        };
                                        $.ajax({
                                            url: /*[[@{__${ADMIN_PATH}__/categories.json}]]*/ '#',
                                            type: 'post',
                                            data: data,
                                            success: function(savedCategory) {
                                                checked.push(savedCategory.id.toString());
                                                $.get(/*[[@{__${ADMIN_PATH}__/articles/create?part=category-fieldset}]]*/ '#', function(data) {
                                                    data = $(data);
                                                    $(':input[name="categoryIds"]', data).each(function(i, element) {
                                                        if ($.inArray($(element).val(), checked) != -1) {
                                                            $(element).prop('checked', true);
                                                        }
                                                    });
                                                    $('#category-fieldset').html(data);
                                                });
                                                self.closest('.modal').modal('hide');
                                            },
                                            error: function(jqXHR) {
                                                $.each(jqXHR.responseJSON.fieldErrors, function(field, message) {
                                                    var field = $(':input[name="' + field + '"]', form);
                                                    $(field).closest('.form-group').addClass('has-error');
                                                });
                                            },
                                            complete: function() {
                                                $(self).button('reset');
                                            }
                                        });
                                    });
                                });
                                /*]]>*/
                            </script>
                            <fieldset>
                                <legend th:text="#{RelatedPosts}">Related Posts</legend>
                                <div class="form-group row" th:classappend="${#fields.hasErrors('relatedPostIds')}? has-error">
                                    <div class="col-sm-12">
                                        <input id="related-posts-fieldset" type="text" th:field="*{relatedPostIds}" style="width: 100%" placeholder=""/>
                                    </div>
                                    <span th:if="${#fields.hasErrors('relatedPostIds')}" class="help-block" th:text="${#fields.errors('relatedPostIds')}" />
                                </div>
                            </fieldset>
                            <script th:inline="javascript">
                                /*<![CDATA[*/
                                $(function() {
                                    $('#related-posts-fieldset').select2({
                                        minimumInputLength: 1,
                                        multiple: true,
                                        ajax: {
                                            url:  /*[[@{__${ADMIN_PATH}__/posts/select}]]*/ '#',
                                            dataType: 'json',
                                            data: function (term, page) {
                                                return {
                                                    keyword: term
                                                };
                                            },
                                            results: function (data, page) {
                                                return {results: data};
                                            }
                                        },
                                        initSelection: function(element, callback) {
                                            var data = [];
                                            $(element.val().split(',')).each(function() {
                                                var id = this;
                                                if (id !== "") {
                                                    var url = /*[[@{__${ADMIN_PATH}__/posts/select}]]*/ '#';
                                                    $.ajax(url + "/" + id,  {
                                                        async: false,
                                                        dataType: "json",
                                                        data: { id: id }
                                                    }).done(function(response) { data.push(response); });
                                                }
                                            });
                                            element.val('');
                                            callback(data);
                                        }
                                    });
                                });
                                /*]]>*/
                            </script>
                            <fieldset id="seo-fieldset">
                                <legend th:text="#{Seo}">SEO</legend>
                                <div class="form-group" th:classappend="${#fields.hasErrors('seoTitle')}? has-error">
                                    <input type="text" th:field="*{seoTitle}" class="form-control" th:placeholder="#{SeoTitle}" />
                                    <span th:if="${#fields.hasErrors('seoTitle')}" class="help-block" th:text="${#fields.errors('seoTitle')}" />
                                </div>
                                <div class="form-group" th:classappend="${#fields.hasErrors('seoDescription')}? has-error">
                                    <textarea th:field="*{seoDescription}" class="form-control" th:placeholder="#{SeoDescription}" style="min-height: 100px"></textarea>
                                    <span th:if="${#fields.hasErrors('seoDescription')}" class="help-block" th:text="${#fields.errors('seoDescription')}" />
                                </div>
                                <div class="form-group" th:classappend="${#fields.hasErrors('seoKeywords')}? has-error">
                                    <textarea th:field="*{seoKeywords}" class="form-control" th:placeholder="#{SeoKeywords}"></textarea>
                                    <span th:if="${#fields.hasErrors('seoKeywords')}" class="help-block" th:text="${#fields.errors('seoKeywords')}" />
                                </div>
                            </fieldset>
                            <fieldset th:each="field, stat : *{customFieldValues}">
                                <legend th:text="${field.name}"></legend>
                                <div class="form-group" th:switch="${#strings.toString(field.fieldType)}">
                                    <div th:case="'TEXT'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].stringValue')}? has-error">
                                        <div class="col-sm-12">
                                            <input type="text" class="form-control" th:field="*{customFieldValues[__${stat.index}__].stringValue}" style="width: 100%" placeholder=""/>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].stringValue')}" th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                    </div>
                                    <div th:case="'TEXTAREA'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].textValue')}? has-error">
                                        <div class="col-sm-12">
                                            <textarea type="text" th:field="*{customFieldValues[__${stat.index}__].textValue}" class="form-control" style="min-height: 100px"></textarea>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].textValue')}"  th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                    </div>
                                    <div th:case="'HTML'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].textValue')}? has-error">
                                        <div class="col-sm-12">
                                            <textarea type="text" th:field="*{customFieldValues[__${stat.index}__].textValue}" class="form-control" th:classappend="'customFieldValues__${stat.index}__-textValue'" style="min-height: 150px"></textarea>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].textValue')}" th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                        <script th:inline="javascript" th:replace="froala::setting(selector='.customFieldValues__${stat.index}__-textValue')"></script>
                                    </div>
                                    <div th:case="'NUMBER'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].numberValue')}? has-error">
                                        <div class="col-sm-12">
                                            <input type="text" class="form-control" th:field="*{customFieldValues[__${stat.index}__].numberValue}" style="width: 100%" placeholder=""/>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].numberValue')}" th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                    </div>
                                    <div th:case="'DATE'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].dateValue')}? has-error">
                                        <div class="col-sm-12">
                                            <input type="text" class="form-control" th:field="*{customFieldValues[__${stat.index}__].dateValue}" style="width: 100%" placeholder="YYYY/MM/dd"/>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].dateValue')}" th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                        <script th:inline="javascript">
                                            /*<![CDATA[*/
                                            $(function() {
                                                var selector = /*[[':input[name="' + 'customFieldValues[__${stat.index}__].dateValue' + '"]']]*/ '#';
                                                $(selector).datetimepicker({
                                                    timepicker: false,
                                                    format:'Y/m/d'
                                                });
                                            });
                                            /*]]>*/
                                        </script>
                                    </div>
                                    <div th:case="'DATETIME'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].datetimeValue')}? has-error">
                                        <div class="col-sm-12">
                                            <input type="text" class="form-control" th:field="*{customFieldValues[__${stat.index}__].datetimeValue}" style="width: 100%" placeholder=""/>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].datetimeValue')}" th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                        <script th:inline="javascript">
                                            /*<![CDATA[*/
                                            $(function() {
                                                var selector = /*[[':input[name="' + 'customFieldValues[__${stat.index}__].datetimeValue' + '"]']]*/ '#';
                                                $(selector).datetimepicker({});
                                            });
                                            /*]]>*/
                                        </script>
                                    </div>
                                    <div th:case="'SELECTBOX'" class="form-group row" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].stringValue')}? has-error">
                                        <div class="col-sm-12">
                                            <select type="text" th:field="*{customFieldValues[__${stat.index}__].stringValue}" class="form-control">
                                                <option value=""></option>
                                                <option th:each="option : ${field.options}" th:value="${option}" th:text="${option}">wrtwetwet</option>
                                            </select>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].stringValue')}"  th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                    </div>
                                    <div th:case="'CHECKBOX'" class="form-group row checkbox" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].textValues')}? has-error">
                                        <div class="col-sm-12">
                                            <label th:each="option : ${field.options}"><input type="checkbox" th:field="*{customFieldValues[__${stat.index}__].textValues}" th:value="${option}" th:text="${option}" /></label>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].textValues')}"  th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                    </div>
                                    <div th:case="'RADIO'" class="form-group row checkbox" th:classappend="${#fields.hasErrors('customFieldValues[__${stat.index}__].stringValue')}? has-error">
                                        <div class="col-sm-12">
                                            <label th:each="option : ${field.options}"><input type="radio" th:field="*{customFieldValues[__${stat.index}__].stringValue}" th:value="${option}" th:text="${option}" /></label>
                                        </div>
                                        <span class="help-block" th:each="err : ${#fields.errors('customFieldValues[__${stat.index}__].stringValue')}"  th:text="${err}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].id}" th:value="${field.id}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].customFieldId}" th:value="${field.customFieldId}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].name}" th:value="${field.name}" />
                                        <input type="hidden" th:field="*{customFieldValues[__${stat.index}__].fieldType}" th:value="${field.fieldType}" />
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                    </div>
                </div>
            </div>
            <script th:inline="javascript">
                $(function() {
                    var lastValue = $('#wr-post-form :input[name!="id"]').serialize();
                    setInterval(function() {
                        var currentValue = $('#wr-post-form :input[name!="id"]').serialize();
                        if (lastValue != currentValue) {
                            $('#save-draft-button').trigger('click');
                        }
                        lastValue = currentValue;
                    }, 180000);
                });
            </script>
        </form>
    </div>
    <div id="category-create-modal" th:fragment="category-create-modal" class="modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content"></div>
        </div>
    </div>
</page-create>