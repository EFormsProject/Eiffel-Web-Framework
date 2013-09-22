#IMPORTANT PLEASE COMPILE WITH:: coffee -cbw widget.coffee
cache = {}
template  = tmpl = (str, data) ->
  # Simple JavaScript Templating
  # John Resig - http://ejohn.org/ - MIT Licensed
  fn = (if not /\W/.test(str) then cache[str] = cache[str] or tmpl(str) else new Function("obj", "var p=[],print=function(){p.push.apply(p,arguments);};" + "with(obj){p.push('" + str.replace(/[\r\t\n]/g, " ").split("{{").join("\t").replace(/((^|}})[^\t]*)'/g, "$1\r").replace(/\t=(.*?)}}/g, "',$1,'").split("\t").join("');").split("}}").join("p.push('").split("\r").join("\\'") + "');}return p.join('');"))
  (if data then fn(data) else fn)

Mini =
  compile:(t)->
    {
      render:template(t)
    }
 
build_control = (control_name, state, control)->
  $el = control.$el.find('[data-name='+control_name+']')
  #get control type
  type = $el.data('type')
  #create class
  typeclass = null
  try
    typeclass = eval(type)
  catch e
    typeclass = WSF_CONTROL
  if type? and typeclass?
    return new typeclass(control, $el, control_name, state)
  return null

class WSF_VALIDATOR
  constructor: (@parent_control, @settings)->
    @error = @settings.error
    return

  validate: ()->
    return true

class WSF_REGEXP_VALIDATOR extends WSF_VALIDATOR
  constructor: ()->
    super
    @pattern = new RegExp(@settings.expression,'g')

  validate: ()->
    val = @parent_control.value()
    res = val.match(@pattern)
    return (res!=null)

class WSF_MIN_VALIDATOR extends WSF_VALIDATOR

  validate: ()->
    val = @parent_control.value()
    return (val.length>=@settings.min)

class WSF_MAX_VALIDATOR extends WSF_VALIDATOR

  validate: ()->
    val = @parent_control.value()
    return (val.length<=@settings.max)


class WSF_CONTROL
  constructor: (@parent_control, @$el, @control_name, @fullstate)->
    @state = @fullstate.state 
    @load_subcontrols()
    return

  load_subcontrols: ()->
    if @fullstate.controls?
      @controls=(build_control(control_name, state, @) for control_name, state of @fullstate.controls)
    else
      @controls = []


  attach_events: ()->
    console.log "Attached #{@control_name}"
    for control in @controls
      if control?
        control.attach_events()
    return

  update: (state)->
    return 
  get_state: ()->
    @state

  get_control_states:()->
    result = {}
    for control in @controls 
      if control?
        result[control.control_name]=control.get_full_state()
    result

  get_full_state: ()->
    {"state":@get_state(),"controls":@get_control_states()}

  process_update: (new_states)->
    if new_states[@control_name]?
      @update(new_states[@control_name])
    for control in @controls
      if control?
        control.process_update(new_states)

  get_context_state : ()->
    if @parent_control?
      return @parent_control.get_context_state()
    return @get_full_state()

  trigger_callback: (control_name,event,event_parameter)->
    if @parent_control?
      return @parent_control.trigger_callback(control_name,event,event_parameter)
    self = @
    $.ajax
      type: 'POST',
      url: '?' + $.param
                      control_name: control_name
                      event: event
      data:
        JSON.stringify(@get_full_state())
      processData: false,
      contentType: 'application/json',
      cache: no
    .done (new_states)->
      #Update all classes
      self.process_update(new_states)
  #Simple event listener

  #subscribe to an event
  on: (name, callback, context)->
    if not @_events?
      @_events = {}
    if not @_events[name]?
      @_events[name] = []
    @_events[name].push({callback:callback,context:context})
    return @

  #trigger an event
  trigger: (name)->
    if not @_events?[name]?
      return @
    for ev in @_events[name]
      ev.callback.call(ev.context)
    return @

class WSF_PAGE_CONTROL extends WSF_CONTROL
  constructor: (@fullstate)->
    @state = @fullstate.state
    @parent_control=null
    @$el = $('[data-name='+@state.id+']') 
    @control_name = @state.id
    @load_subcontrols()

controls = {}

class WSF_BUTTON_CONTROL extends WSF_CONTROL
  attach_events: ()->
    super
    self = @
    @$el.click (e)->
      e.preventDefault()
      self.click()

  click: ()->
    if @state['callback_click']
      @trigger_callback(@control_name, 'click')

  update: (state) ->
    if state.text?
      @state['text'] = state.text
      @$el.text(state.text)

class WSF_INPUT_CONTROL extends WSF_CONTROL
  attach_events: ()->
    super
    self = @
    @$el.change ()->
      self.change()

  change: ()->
    #update local state
    @state['text'] = @$el.val()
    if @state['callback_change']
      @trigger_callback(@control_name, 'change')
    @trigger('change')

  value:()->
    return @$el.val()

  update: (state) ->
    if state.text?
      @state['text'] = state.text
      @$el.val(state.text)

class WSF_TEXTAREA_CONTROL extends WSF_INPUT_CONTROL

class WSF_AUTOCOMPLETE_CONTROL extends WSF_INPUT_CONTROL
  attach_events: () ->
    super
    self = @
    @$el.typeahead({
      name: @control_name
      template: @state['template']
      engine: Mini
      remote:
        url:""
        replace: (url, uriEncodedQuery) ->
            self.state['text'] = self.$el.val()
            '?' + $.param
                      control_name: self.control_name
                      event: 'autocomplete'
                      states: JSON.stringify(self.get_context_state())
        filter: (parsedResponse) ->
            parsedResponse[self.control_name]['suggestions']
        fn: ()->
          self.trigger_callback(self.control_name, 'autocomplete')
    })
    @$el.on 'typeahead:closed',()->
        self.change() 
    @$el.on 'typeahead:blured',()->
        self.change() 

class WSF_CHECKBOX_CONTROL extends WSF_CONTROL
  attach_events: ()->
    super
    self = @
    @checked_value = @state['checked_value']
    @$el.change ()->
      self.change()

  change: ()->
    #update local state
    @state['checked'] = @$el.is(':checked')
    if @state['callback_change']
      @trigger_callback(@control_name, 'change')
    @trigger('change')

  value:()->
    return @$el.is(':checked')

  update: (state) ->
    if state.text?
      @state['checked'] = state.checked
      @$el.prop('checked',state.checked)

class WSF_FORM_ELEMENT_CONTROL extends WSF_CONTROL
  attach_events: ()->
    super
    self = @
    @value_control = @controls[0]
    if @value_control?
      #subscribe to change event on value_control
      @value_control.on('change',@change,@)
    @serverside_validator = false
    #Initialize validators
    @validators = []
    for validator in @state['validators']
      try
        validatorclass = eval(validator.name)
        @validators.push new validatorclass(@,validator)
      catch e
        #Use serverside validator if no js implementation
        @serverside_validator = true
    return

  #value_control changed run validators
  change: ()->
    for validator in @validators
      if not validator.validate()
        @showerror(validator.error)
        return
    @showerror("")
    #If there is validator which is not implemented in js ask server to validate
    if @serverside_validator
      @trigger_callback(@control_name, 'validate')
    return

  showerror: (message)->
    @$el.removeClass("has-error")
    @$el.find(".validation").remove()
    if message.length>0
      @$el.addClass("has-error")
      errordiv = $("<div />").addClass('help-block').addClass('validation').text(message)
      @$el.find(".col-lg-10").append(errordiv)

  update: (state) ->
    if state.error?
      @showerror(state.error)

  value: ()->
    @value_control.value()

class WSF_HTML_CONTROL extends WSF_CONTROL

  value:()->
    return @$el.html()

  update: (state) ->
    if state.html?
      @state['html'] = state.html
      @$el.html(state.html)

class WSF_CHECKBOX_LIST_CONTROL extends WSF_CONTROL

  attach_events: ()->
    super
    #Listen to events of subelements and forward them
    for control in @controls
      control.on('change',@change,@)
    return
 
  change:()->
    @trigger("change")

  value:()->
    result = []
    for subc in @controls
      if subc.value()
        result.push(subc.checked_value)
    return result

class WSF_PROGRESS_CONTROL extends WSF_CONTROL

  attach_events:() ->
    super
    self = @
    runfetch= ()->
            self.fetch()
    setInterval(runfetch, 5000)

  fetch: ()->
    @trigger_callback(@control_name, 'progress_fetch')

  update: (state)->
    if state.progress?
      @state['progress'] = state.progress
      @$el.children('.progress-bar').attr('aria-valuenow', state.progress).width(state.progress + '%')

class WSF_PAGINATION_CONTROL extends WSF_CONTROL

  attach_events: ()->
    self = @
    @$el.on 'click', 'a', (e)->
      e.preventDefault()
      self.click(e)

  click: (e)->
    nr = $(e.target).data('nr')
    if nr == "next"
      @trigger_callback(@control_name, "next")
    else if nr == "prev"
      @trigger_callback(@control_name, "prev")
    else
      @trigger_callback(@control_name, "goto", nr)

  update: (state) ->
    if state._html?
      @$el.html($(state._html).html())

class WSF_GRID_CONTROL extends WSF_CONTROL
  attach_events: ()->
    super
    self = @

  update: (state) ->
    if state.datasource?
      @state['datasource'] = state.datasource
    if state._body?
      @$el.find('tbody').html(state._body)

class WSF_REPEATER_CONTROL extends WSF_CONTROL
  attach_events: ()->
    super
    self = @

  update: (state) ->
    if state.datasource?
      @state['datasource'] = state.datasource
    if state._body?
      @$el.find('.repeater_content').html(state._body)
      console.log state._body

 