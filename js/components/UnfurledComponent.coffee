clas = require 'classnames'

recl = React.createClass
{img,div,pre,a,label,h2,h3,iframe} = React.DOM

module.exports = recl
  displayName: "Unfurled"

  setInitialStore: -> {}

  _imageStyle: (type) ->
    if type is 'wide'
      if @state? and @state.measured then {position: 'inherit', height: '100%'} else {position: 'absolute', left: -10000}
    else
      #what to do if tall?
      if @state? and @state.measured 
        wprime = if @props.width < @state.imgWidth then @props.width else @state.imgWidth
        console.log(wprime)
        {position: 'inherit', width: '100%', 'margin-top': -((wprime * @state.imgHeight ) / @state.imgWidth - @props.height * 3.2) / 2} 
      else 
        {position: 'absolute', left: -10000}

  _measureSelf: ({target:img}) ->
      @setState {imgHeight: img.offsetHeight}
      @setState {imgWidth: img.offsetWidth}
      @setState {measured: true}

  componentDidUpdate: ->
    console.log(@state)

  render: ->

    style =
      width: if @state? and @props.width? and @state.imgHeight? then (@props.width - ((@props.height * 3.2 * @state.imgWidth) / @state.imgHeight) - 20) else '100%'
      height: @props.height * 3.2

    dstyle =
      width: if @state? and @props.width? then @props.width else '100%'

    vstyle =
      width: if @state? and @props.width? then @props.width else '40%'

    if @props.player isnt ""
      (div {className: "unfurled", ref: "unfurl"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "imageCont", style: if @props.type is 'wide' then {height: @props.height * 3.2} else {height: @props.height * 3.2, overflow:'hidden'}},
          (iframe {src: @props.player, allowfullscreen: true, height: @props.height * 3.2, width: ((@props.pw * @props.height * 3.2)/ @props.ph)})
        )
        (div {className: "description", style: if @props.type is 'wide' then vstyle else {display: 'none'}}, @props.description)
      )
    else if @props.image isnt ""
      (div {className: "unfurled", ref: "unfurl"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "imageCont", style: if @props.type is 'wide' then {height: @props.height * 3.2} else {height: @props.height * 3.2, overflow:'hidden'}},
          (a {target: "_blank", href: if @props.url is "" then @props.image else @props.url},
          (img {src: @props.image, onLoad: @_measureSelf, style: @_imageStyle(@props.type)})
          )
        )
        (div {className: "description", style: if @props.type is 'wide' then style else {display: 'none'}}, @props.description)
      )
    else
      (div {className: "unfurled"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "onlyDescription", style}, @props.description)
      )

