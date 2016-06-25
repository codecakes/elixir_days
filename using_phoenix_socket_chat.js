let 
	socket = new Phoenix.Socket('/ws'),
	channel = socket.channel('chat:auction_id');
	
	
socket.connect();

channel.on('user_enter', function (msg) {
	// do something
});

channel.on('new_msg', function (msg) {
	// do something
});

channel.on('user_leave', function (msg) {
	// do something
});

channel.join();
