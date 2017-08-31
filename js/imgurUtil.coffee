imgur = require 'imgur'

{img,div,pre,a,label,h2,h3} = React.DOM

module.exports = imgurUtil =
  saveClientId: (id) ->
    imgur.saveClientId(id)
 
  getImageInfo: (id, cb) ->
    imgur.getInfo(id)
    .then (json) ->
      cb(json)
    .catch (err) -> 
      # Handle error
      console.log('error')
      cb(err)

  getAlbumInfo: (id, cb) ->
    imgur.getAlbumInfo(id)
    .then (json) ->
      cb(json)
    .catch (err) -> 
      # Handle error
      console.log('error')
      cb(err)

  getData: (url, cb) ->
    r = /imgur\.com\/(gallery|image)\/([a-zA-Z0-9]+)/    
    test = r.exec(url)
    if test
      if test[1] == 'image'
        @getImageInfo(test[2], cb)
      else
        @getAlbumInfo(test[2], cb)
    else
      return url
      

