class App.Selector
    constructor: (options = {}) ->
        {@mainElement, @autoCompleteElement, @containerElement, @source, 
         @saveUrl, selected, canAddNew, @minLength} = options

        if !@minLength? 
            @minLength = 3
        
        @selected = []
        
        @attachRemoveListener()

        for value in selected
            @selected.push value
            
        @setCanAddNew canAddNew    

    bind: ->
        lastXhr = null
        @overrideAutocompleteResponse()
        @getAutoCompleteElement().autocomplete
   
            source: (request, response) =>
                term = request.term
                if(term.length < @minLength)
                    @getMainElement().find('.add-item-btn').hide()
                else
                    
                    @clearErrors()

                    lastXhr = $.getJSON @source, request, (data, status, xhr) ->
                        if data.success
                            response data.success
                         else
                            @showError "messages:error.malformed-json".t()
                    .error =>
                        @showError "messages:error.internal-server-error".t()
          
            select: (event, ui) =>      
                @getMainElement().find('.add-item-btn').hide()
                @getAutoCompleteElement().val(ui.item.value)

                if @isItemAdded(ui.item.id)
                    @showError "messages:error.item-added".t()
                else
                    @addItem ui.item.id, ui.item.value
                
                return false

    overrideAutocompleteResponse: ->

        proto = $.ui.autocomplete.prototype
        canAddNew = @canAddNew
        $.extend proto, {
            _response: (content) ->
                if !this.options.disabled and content and content.length
                    content = this._normalize content
                    this._suggest content
                    this._trigger "open"
                else
                    this.close()

                if canAddNew 
                    $(document.activeElement).parent().find('.add-item-btn').show()
                    
                this.pending--

                if !this.pending
                    this.element.removeClass "ui-autocomplete-loading"
        }   

    isItemAdded: (id) ->
        for value in @selected
            if value == id
                return true

        return false
        
    canAddNew: ->
        return @canAddNew

    setCanAddNew: (canAddNew) ->
        @canAddNew = canAddNew
            
    addItem: (id, value) ->
        if(!value.length < @minLength)
            item = @createItem id, value
            @getContainerElement().append item
            @getAutoCompleteElement().val ""
            @addToSelected id, value
        @getMainElement().find('.add-item-btn').hide()     

    getMainElement: ->
        $(@getParentForm()).find(@mainElement)

    getAutoCompleteElement: ->
        @getMainElement().find(@autoCompleteElement)
        
    getContainerElement: ->
        @getMainElement().find(@containerElement)

    getParentForm: ->
        form = $(document.activeElement).find('form')
        if(!form.length)    # hax for firefox. Firefox's activeElement works differently. Strange.
            form = $(document.activeElement).closest('form')
        return form

    addToSelected: (id, value) ->
        @selected.push id
        @addHiddenField id, value 

    addHiddenField: (id, value) ->
        $(@getAutoCompleteElement()).parent().parent().find('.items ul').append($('<input class="tag-id" name="'+@getFieldName()+'[]" type="hidden"/>').attr({"value": value, 'data-id': id}))

    getFieldName: ->
        fieldName = @getMainElement().attr('data-elementname')
        if !fieldName.length
            fieldName = "selector_item"
        return fieldName

    createItem: (id, value) ->
        item = $('<li>').attr('data-id', id);
        item.html value

        $a = $ '<a href="#"/>';
        $a.attr "class", "remove ui-icon ui-icon-close"
        item.append $a
        
        return item;

    saveItem: (value) ->
        $.ajax 
            url:      @saveUrl,
            dataType: 'json',
            data:     'term=' + value,
            success:  (data) => @addItem data.success.id, data.success.value
            error:    (data) => @showError "messages:error.internal-server-error.try-again".t()

    detachItem: (li) ->
        i = 0
        id = parseInt ($(li).attr "data-id")
        
        @selected.removeItem id

        $(li).parent().find('input[data-id="' + id + '"]').remove();
        $(li).remove()

    removeHiddenField: (id) ->
        $(@getAutoCompleteElement()).parent().parent().find('.items ul').filter('input[data-id="' + id + '"]').remove();

    showError: (error) ->
        el = $('<div/>', {'class': "errorized error"}).html(error)
        $(@getAutoCompleteElement()).after(el)
        
    clearErrors: ->
        if errorized = $(@getAutoCompleteElement()).parent().find('.errorized')
            errorized.remove()
        
    attachRemoveListener: ->
        self = this

        $(".items ul").on "click", "li a.remove", (e) ->
            self.detachItem $(this).parent()
            return false
            
    Array::removeItem = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
