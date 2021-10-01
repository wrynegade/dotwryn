function SETUP__AWS() {
	STATUS 'starting aws setup'
	"$DOTWRYN_PATH/bin/aws/configure"

	STATUS 'getting media from s3'
	"$DOTWRYN_PATH/bin/aws/s3/sync-media" pull
}
