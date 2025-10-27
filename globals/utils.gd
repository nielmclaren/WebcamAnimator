extends Node

func duplicate_texture(texture: Texture2D) -> Texture2D:
	var image: Image = texture.get_image().duplicate()
	return ImageTexture.create_from_image(image)


func get_feed_position_string(value: CameraFeed.FeedPosition) -> String:
	match value:
		CameraFeed.FeedPosition.FEED_FRONT:
			return "FEED_FRONT"
		CameraFeed.FeedPosition.FEED_BACK:
			return "FEED_BACK"
		_:
			push_warning("Got unknown feed position.")
			return "FEED_UNKNOWN"


func get_feed_data_type_string(value: CameraFeed.FeedDataType) -> String:
	match value:
		CameraFeed.FeedDataType.FEED_NOIMAGE:
			return "FEED_NOIMAGE No image set for the feed."
		CameraFeed.FeedDataType.FEED_RGB:
			return "FEED_RGB Feed supplies RGB images."
		CameraFeed.FeedDataType.FEED_YCBCR:
			return "FEED_YCBCR Feed supplies YCbCr images that need to be converted to RGB."
		CameraFeed.FeedDataType.FEED_YCBCR_SEP:
			return "FEED_YCBCR_SEP Feed supplies separate Y and CbCr images that need to be combined and converted to RGB."
		CameraFeed.FeedDataType.FEED_EXTERNAL:
			return "FEED_EXTERNAL"
		_:
			push_warning("Got unknown feed data type.")
			return "FEED_UNKNOWN"