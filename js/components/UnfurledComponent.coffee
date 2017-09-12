clas = require 'classnames'

recl = React.createClass
{img,div,pre,a,label,h2,h3} = React.DOM

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

    if @props.image?
      (div {className: "unfurled", ref: "unfurl"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "imageCont", style: {height: @props.height * 2.5}},
          (img {src: @props.image, onLoad: @_measureSelf})
        )
        (div {className: "description", style}, @props.description)
      )
    else
      (div {className: "unfurled"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "onlyDescription", style}, @props.description)
      )

