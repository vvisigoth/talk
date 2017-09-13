clas = require 'classnames'

recl = React.createClass
{img,div,pre,a,label,h2,h3,iframe} = React.DOM

module.exports = recl
  displayName: "Unfurled"
  #render: ->

  setInitialStore: -> {}

  _measureSelf: ({target:img}) ->
    @setState {imgHeight: img.offsetHeight}
    @setState {imgWidth: img.offsetWidth}

  componentDidUpdate: ->
    if @state?
      if not @state.totalWidth?
        b = @refs.unfurl.getBoundingClientRect()
        @setState {totalWidth: b.width}

  render: ->
    style =
      width: if @state? and @state.totalWidth? then (@state.totalWidth - @state.imgWidth - 20) else '100%'
      height: @props.height * 2.5

    dstyle =
      width: if @state? and @state.totalWidth? then @state.totalWidth else '100%'
      #width: '100%'

    vstyle =
      #width: if @state? and @state.totalWidth? then (@state.totalWidth - ((@props.pw * @props.height * 2.5)/ @props.ph) - 20) else '40%'
      width: if @state? and @state.totalWidth? then @state.totalWidth else '40%'

    console.log(vstyle)
    console.log(@props.title)
    console.log('vstyle')

    if @props.player isnt ""
      (div {className: "unfurled", ref: "unfurl"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "imageCont", style: {height: @props.height * 2.5}},
          (iframe {src: @props.player, height: @props.height * 2.5, width: ((@props.pw * @props.height * 2.5)/ @props.ph)})
        )
        (div {className: "description", style: vstyle}, @props.description)
      )
    else if @props.image isnt ""
      (div {className: "unfurled", ref: "unfurl"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "imageCont", style: {height: @props.height * 2.5}},
          (a {src: if @props.url is "" then @props.image else @props.url},
          (img {src: @props.image, onLoad: @_measureSelf})
          )
        )
        (div {className: "description", style}, @props.description)
      )
    else
      (div {className: "unfurled"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "onlyDescription", style}, @props.description)
      )

