package ws

func (m *Manager) setupEventHandlers() {
	m.Handlers[TypeSendMessage] = m.EventRepository.SendMessageHandler
	m.Handlers[TypeSendMessage] = m.EventRepository.NotifyOnlineStatusChange
	// m.handlers[EventChangeRoom] = ChatRoomHandler
}
