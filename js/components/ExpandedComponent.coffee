recl = React.createClass
{img,div,pre,a,label,h2,h3} = React.DOM

imgurUtil = require '../imgurUtil.coffee'

class Expanded extends React.Component
  constructor: (props) -> 
    super props
    console.log(props)
    @_handleImgurJson = @_handleImgurJson.bind(@)
    @state =
      url: props.url
    if props.type == 'imgur' then imgurUtil.getData(props.url, @_handleImgurJson)

  _handleImgurJson: (json) ->
    console.log("callback json")
    console.log(json)
    if json.status > 400
      console.log("calling error")
      #leave it
    if json.data.images
      console.log("its a gallery")
      console.log("first image", json.data.images[0].link)
      @setState({url: json.data.images[0].link})
    else
      console.log("its a image")
      @setState({url: json.data.link})

  render: ->
    (div {className: "imgCont", style: {height: @props.height}}, 
      (a {href: @state.url}, 
        (img {src: @state.url, style: {height: '100%'}})
      )
    )

module.exports = Expanded
