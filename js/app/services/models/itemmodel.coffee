###

ownCloud - News

@author Bernhard Posselt
@copyright 2012 Bernhard Posselt nukeawhale@gmail.com

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU AFFERO GENERAL PUBLIC LICENSE
License as published by the Free Software Foundation; either
version 3 of the License, or any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU AFFERO GENERAL PUBLIC LICENSE for more details.

You should have received a copy of the GNU Affero General Public
License along with this library.  If not, see <http://www.gnu.org/licenses/>.

###

angular.module('News').factory '_ItemModel',
['_Model', '_MaximumQuery', '_MinimumQuery',
(_Model, _MaximumQuery, _MinimumQuery) ->

	class ItemModel extends _Model


		constructor: ->
			@_guidFeedIdHash = {}
			super()


		clear: ->
			@_guidFeedIdHash = {}
			super()


		# items have two unique fields: feed_id and guidhash
		# in case we get updated items with the same two fields we 
		# also need to update the field
		add: (data, clearCache=true) ->
			hash = data.feedId + '_' + data.guidHash
			entry = @_guidFeedIdHash[hash]

			# update entry if exists with same feedid and guidhash
			if angular.isDefined(entry)

				# first update id that could have changed
				delete @_dataMap[entry.id]
				@_dataMap[data.id] = entry
				
				# now copy over the elements data attrs
				for key, value of data
					if key == 'feedId' or key == 'guidHash'
						continue
					else
						entry[key] = value
			
			else
				@_guidFeedIdHash[hash] = data
				super(data, clearCache)


		getHighestId: ->
			query = new _MaximumQuery('id')
			highestId = @get(query)
			
			if angular.isDefined(highestId)
				return highestId.id
			else
				return 0


	return ItemModel
]