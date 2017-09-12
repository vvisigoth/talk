util = require '../util.coffee'
clas = require 'classnames'

recl = React.createClass
{img, div,pre,a,label,h2,h3} = React.DOM

Member          = require './MemberComponent.coffee'

module.exports = recl
  displayName: "Message"

  lz: (n) -> if n<10 then "0#{n}" else "#{n}"

  setInitialStore: -> {}

  convTime: (time) ->
    d = new Date time
    h = @lz d.getHours()
    m = @lz d.getMinutes()
    s = @lz d.getSeconds()
    "~#{h}.#{m}.#{s}"

  _handleAudi: (e) ->
    audi = _.map $(e.target).closest('.path').find('div'), (div) ->
      return $(div).text()
    @props._handleAudi audi

  _handlePm: (e) ->
    return if not @props._handlePm
    user = $(e.target).closest('.iden').text()
    if user[0] is "~" then user = user.slice 1
    return if user.toLowerCase() is 'system'
    @props._handlePm user

  _isUnfurl: (speech)->
    console.log(speech)
    if speech.app? and speech.app.src == 'unfurl'
        return true
    else
      return false

  _measureSelf: ({target:img}) ->
    console.log(img.offsetHeight)
    @setState {imgHeight: img.offsetHeight}
    console.log(img.offsetWidth)
    @setState {imgWidth: img.offsetWidth}

  componentDidUpdate: ->
    if @state?
      if not @state.totalWidth?
        b = @refs.unfurl.getBoundingClientRect()
        console.log('@refs.unfurl.getBoundingClientRect()')
        console.log(@refs.unfurl.getBoundingClientRect())
        @setState {totalWidth: b.width}

  renderSpeech: ({lin,app,exp,tax,url,mor,fat,com}) ->  # one of
    switch
      when (lin or app or exp or tax)
        # logic here for expanded
        if app? and app.src == 'unfurl'
          console.log(app)
          j = JSON.parse(app.txt)
          console.log('json')
          console.log(j)
          console.log('redner state')
          console.log(@state)
          style =
            #width: if @state? then 'calc(99% -' + @state.imgWidth + 'px)' else '100%'
            width: if @state? and @state.totalWidth? then (@state.totalWidth - @state.imgWidth - 20) else '100%'
          console.log(style)
          if j.image?
            (div {className: "unfurled", ref: "unfurl"},
              (div {className: "title"}, j.title)
              (div {className: "imageCont", style: {height: @props.height * 2.5}},
                (img {src: j.image, onLoad: @_measureSelf})
              )
              # make this width dependent on image state
              (div {className: "description", style}, j.description)
            )
          else
            (div {className: "unfurled"},
              (div {className: "title"}, j.title)
              (div {className: "onlyDescription", style}, j.description)
            )
        else
          (lin or app or exp or tax).txt
      when url
        (a {href:url.txt,target:"_blank",key:"speech"}, url.txt)
      when com
        (div {},
          com.txt
          (div {}, (a {className:"btn", href: com.url}, "Go to thread"))
        )
      when mor then mor.map @renderSpeech
      when fat
        (div {},
          (@renderSpeech fat.taf)
          (div {className:"fat"}, @renderTorso fat.tor)
        )
      else "Unknown speech type:" + (" %"+x for x of arguments[0]).join ''

  renderTorso: ({text,tank,name}) -> # one of
    switch
      when text? then text
      when tank? then pre {}, tank.join("\n")
      when name? then (div {}, name.nom, ": ", @renderTorso name.mon)
      else "Unknown torso:"+(" %"+x for x of arguments[0]).join ''

  classesInSpeech: ({url,exp,app,lin,mor,fat}) -> # at most one of
    switch
      when url then "url"
      when exp then "exp"
      when app then "say"
      when lin then {say: lin.say is false}
      when mor then mor?.map @classesInSpeech
      when fat then @classesInSpeech fat.taf

  render: ->
    {thought} = @props
    delivery = _.uniq _.pluck thought.audience, "delivery"
    speech = thought.statement.speech
    bouquet = thought.statement.bouquet
    if !speech? then return;

    name = if @props.name then @props.name else ""
    aude = _.keys thought.audience
    audi = util.clipAudi(aude).map (_audi) -> (div {key:_audi}, _audi)

    mainStation = util.mainStationPath(window.urb.user)
    type = if mainStation in aude then 'private' else 'public'

    if(_.filter(bouquet, ["comment"]).length > 0)
      comment = true
      for k,v of speech.mor
        if v.fat
          url = v.fat.taf.url.txt
          txt = v.fat.tor.text
        if v.app then path = v.app.txt.replace "comment on ", ""
      audi = (a {href:url}, path)
      speech = {com:{txt,url}}

    className = clas 'gram',
      (if @props.sameAs then "same" else "first"),
      (if delivery.indexOf("received") isnt -1 then "received" else "pending"),
      {'new': @props.unseen}
      {comment}
      @classesInSpeech speech

    style =
      height: if @_isUnfurl(@props.thought.statement.speech) then @props.height * 3.5 else @props.height
      marginTop: @props.marginTop
    (div {className, 'data-index':@props.index, key:"message", style},
        (div {className:"meta",key:"meta"},
          label {className:"type #{type}","data-glyph":(@props.glyph || "*")}
          (h2 {className:'author planet',onClick:@_handlePm,key:"member"},
           (React.createElement Member,{ship:@props.ship,glyph:@props.glyph,key:"member"})
          )
          h3 {className:"path",onClick:@_handleAudi,key:"audi"}, audi
          h3 {className:"time",key:"time"}, @convTime thought.statement.date
        )
        (div {className:"speech",key:"speech"},
          @renderSpeech speech,bouquet
    ))
