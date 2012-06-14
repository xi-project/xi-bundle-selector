require "./init.coffee"
require "../../Resources/coffee/Selector.coffee"


container = $('<form id="test-form">
    <div class="tag_item_selector" data-elementname="xi_articlebundle_articletype[tags]">
        <div class="items">
        <ul id="xi_articlebundle_articletype_tags"></ul>
        </div>
        <div class="item_input">
            <label for="xi_articlebundle_articletype_tags" class=" required">Tags</label>
            <button name="add-item" class="add-item-btn">Lisää tagi</button>
            <input class="item_field" type="text">
        </div>
    </div>
</form>');

describe "selector", ->

    selector = null

    beforeEach ->

        $('body').append container

        options = {
            mainElement:            '.tag_item_selector'
            autoCompleteElement:    '.item_field'
            containerElement:       '.items ul'
            source:                 'sourceUrl'   
            saveUrl:                'saveUrl'
            selected:               [1..4]
            canAddNew:              true
            minLength:              3
        }
        selector = new App.Selector(options)

        # set focus
        document.activeElement = container.find('.item_field')[0]

    afterEach ->
        container.remove()

    it "creates new selector", ->
        expect(selector).toBeDefined()
        expect(selector.minLength).toEqual 3
        expect(selector.selected.length).toEqual 4
        expect(selector.setCanAddNew).toBeTruthy()

    it "checks form added items", ->
        expect(selector.isItemAdded(4)).toBeTruthy()
        expect(selector.isItemAdded(5)).toBeFalsy()

    it "creates an item", ->
        item = selector.createItem 2, 'diibadaaba'
        expect(item.html()).toEqual 'diibadaaba<a href="#" class="remove ui-icon ui-icon-close"></a>'

    it "saves item, fail", ->        
        spyOn selector, 'showError'
        spyOn($, "ajax").andCallFake (params) ->
            params.error {}

        selector.saveItem 'dingdong'

        expect($.ajax.mostRecentCall.args[0]["data"]).toEqual 'term=dingdong'
        expect(selector.showError).toHaveBeenCalledWith 'messages:error.internal-server-error.try-again'

    it "saves item, succee", ->        
        spyOn selector, 'addItem'
        spyOn($, "ajax").andCallFake (params) ->
            params.success {success:{id: 1, value: 'dingdong'}}

        selector.saveItem 'dingdong'

        expect($.ajax.mostRecentCall.args[0]["data"]).toEqual('term=dingdong');
        expect(selector.addItem).toHaveBeenCalledWith 1, 'dingdong'

    it "gets parent form", ->
        expect(selector.getParentForm().attr('id'))
            .toEqual('test-form')

    it "gets main element", ->
        expect(selector.getMainElement().attr('class'))
            .toEqual('tag_item_selector')

    it "gets container element", ->
        expect(selector.getContainerElement().attr('id'))
            .toEqual('xi_articlebundle_articletype_tags')            

    it "gets field name", ->
        expect(selector.getFieldName()).toEqual 'xi_articlebundle_articletype[tags]'

    it "adds to selected", ->
        selector.addToSelected 123, 'blaa'
        expect(selector.selected[selector.selected.length - 1]).toEqual 123

    it "adds item", ->
        selector.addItem 2, 'xoox'
        expect(container.find('li[data-id="2"]').length).toBeGreaterThan 0

    it "detaches item", ->
        selector.addItem(2, 'xoox')
        selector.detachItem('li[data-id="2"]')
        expect(container.find('li[data-id="2"]').length).toEqual 0

    it "shows errors", ->
        selector.showError 'grave errar!'
        expect(container.find('.error').length).toBeGreaterThan 0
        expect(container.find('.error').html()).toEqual 'grave errar!'

    it "clear errors", ->
        selector.showError 'grave errar!'
        selector.clearErrors()
        expect(container.find('.error').length).toEqual 0

    it "listens for removal clicks", ->
        spyOn(selector, 'detachItem').andReturn true
        selector.addItem 2, 'xoox'
        selector.attachRemoveListener()
        container.find('li[data-id="2"] a').click()

        expect(selector.detachItem).toHaveBeenCalled()
