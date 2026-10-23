import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// notification daemon (replaces xfce4-notifyd for the hyprland session)
Scope {
	id: notifications

	readonly property int defaultTimeout: 5000

	NotificationServer {
		id: server

		keepOnReload: true
		bodySupported: true
		bodyMarkupSupported: true
		actionsSupported: true
		imageSupported: true

		onNotification: notification => notification.tracked = true
	}

	PanelWindow {
		visible: server.trackedNotifications.values.length > 0

		anchors {
			top: true
			right: true
		}
		margins {
			top: 8
			right: 8
		}

		exclusiveZone: 0
		implicitWidth: 380
		implicitHeight: stack.implicitHeight
		color: "transparent"

		Column {
			id: stack

			width: parent.width
			spacing: 8

			Repeater {
				model: server.trackedNotifications

				Rectangle {
					id: card

					required property Notification modelData
					readonly property bool critical: modelData.urgency === NotificationUrgency.Critical

					width: stack.width
					implicitHeight: content.implicitHeight + 20
					color: Colors.background
					border.width: 2
					border.color: critical ? Colors.alert : Colors.secondary

					Timer {
						running: !card.critical && card.modelData.expireTimeout !== 0
						interval: card.modelData.expireTimeout > 0
							? card.modelData.expireTimeout * 1000
							: notifications.defaultTimeout
						onTriggered: card.modelData.expire()
					}

					Column {
						id: content

						anchors {
							left: parent.left
							right: parent.right
							top: parent.top
							margins: 10
						}
						spacing: 4

						Text {
							width: parent.width
							text: card.modelData.summary
							color: card.critical ? Colors.alert : Colors.foreground
							font.family: Colors.font
							font.pointSize: Colors.fontSize
							font.bold: true
							elide: Text.ElideRight
						}

						Text {
							width: parent.width
							visible: text !== ""
							text: card.modelData.body
							textFormat: Text.StyledText
							color: Colors.foreground
							font.family: Colors.font
							font.pointSize: Colors.fontSize - 1
							wrapMode: Text.Wrap
							maximumLineCount: 6
							elide: Text.ElideRight
						}

						Row {
							visible: card.modelData.actions.length > 0
							spacing: 8

							Repeater {
								model: card.modelData.actions

								Rectangle {
									required property NotificationAction modelData

									implicitWidth: actionLabel.implicitWidth + 16
									implicitHeight: actionLabel.implicitHeight + 8
									color: Colors.backgroundAlt

									Text {
										id: actionLabel
										anchors.centerIn: parent
										text: parent.modelData.text
										color: Colors.foregroundAlt
										font.family: Colors.font
										font.pointSize: Colors.fontSize - 1
									}

									MouseArea {
										anchors.fill: parent
										cursorShape: Qt.PointingHandCursor
										onClicked: parent.modelData.invoke()
									}
								}
							}
						}
					}

					MouseArea {  // click anywhere else on the card to dismiss
						anchors.fill: parent
						z: -1
						onClicked: card.modelData.dismiss()
					}
				}
			}
		}
	}
}
