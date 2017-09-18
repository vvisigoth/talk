clas = require 'classnames'

recl = React.createClass
{img,div,pre,a,label,h2,h3,iframe} = React.DOM

module.exports = recl
  displayName: "Unfurled"

  setInitialStore: -> {}

  _measureSelf: ({target:img}) ->
    @setState {imgHeight: img.offsetHeight}
    @setState {imgWidth: img.offsetWidth}

  render: ->
    style =
      width: if @state? and @props.width? then (@props.width - @state.imgWidth - 20) else '100%'
      height: @props.height * 2.5

    dstyle =
      width: if @state? and @props.width? then @props.width else '100%'

    vstyle =
      width: if @state? and @props.width? then @props.width else '40%'

    if @props.player isnt ""
      (div {className: "unfurled", ref: "unfurl"},
        (div {className: "title", style: dstyle}, @props.title)
        (div {className: "imageCont", style: {height: @props.height * 2.5}},
          (iframe {src: @props.player, allowfullscreen: true, height: @props.height * 2.5, width: ((@props.pw * @props.height * 2.5)/ @props.ph)})
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

