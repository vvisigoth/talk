recl = React.createClass
{img,div,pre,a,label,h2,h3} = React.DOM

imgurUtil = require '../imgurUtil.coffee'

class Expanded extends React.Component
  constructor: (props) -> 
    super props
    @_handleImgurJson = @_handleImgurJson.bind(@)
    @state =
      url: props.url
      expanded: true
    if props.type == 'imgur' then imgurUtil.getData(props.url, @_handleImgurJson)

  _handleImgurJson: (json) ->
    if json.status > 400
      @props.toggleExpand()
      @setState({expanded: false})
    if json.data.images
      @setState({url: json.data.images[0].link})
    else
      @setState({url: json.data.link})

  render: ->
    if @state.expanded
      (div {className: "imgCont", style: {height: @props.height}}, 
        (a {href: @state.url}, 
          (img {src: @state.url, style: {height: '100%'}})
        )
      )
    else
      (a {href:@state.url,target:"_blank",key:"speech"}, @state.url)


module.exports = Expanded
