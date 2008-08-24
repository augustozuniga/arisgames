var rowID = 0;
var message;
var currentChar = 0;
var intervalObject;
var messageContainer;
var messageQueue = Array();
var messageNumber = -1;
var npcID;
var initialOptions = '';

function getMessageQueue(queueId) {
	// Note the queueId is analagous to the nodeId
	var request = new XMLHttpRequest();
	request.open('GET', wwwBase + '/index.php?site=' + site + '&module=IMNode&controller=JSON&nodeID='
		+ queueId + '&npcID=' + npcID, true);
	request.setRequestHeader('Content-Type', 'application/x-javascript;');        	
	request.onreadystatechange = function() {
		if (request.readyState == 4 && request.status == 200) {
			// Extract the JSON object
			var data = eval('(' + request.responseText + ')');
			callback_getMessageQueue(data);
		}
	}
    request.send();
}

function callback_getMessageQueue(queue) {
    messageQueue = queue;
    messageNumber = -1;
    processCurrentMessage();
}

function processCurrentMessage() {
    messageNumber++;
    
    if (messageNumber < messageQueue['phrases'].length) {
        message = messageQueue['phrases'][messageNumber];
        if (message['isNPC']) setNPCMessage();
        else setTimeout(printPlayerMessage, message['delay']);
    } else if (messageQueue['options'].length > 0) {
        setTimeout(makeOptions, messageQueue['optionDelay']);
    }
}

function prepOptions(id, text) {
	initialOptions = initialOptions + '<a href="#" onclick="parent.selectOption(' + "'" + id + "'" + ')">' + text + '</a><br/>';
		
	var opt = new Array();
	opt['queueId'] = id;
	opt['phrase'] = text;
	messageQueue['options'].push(opt);
}

function startOptions() {
	makeRow('left', initialOptions, messageQueue['player_icon']);
}

function makeOptions() {
    var msg = '';
    for (var i = 0; i < messageQueue['options'].length; i++) {
        option = messageQueue['options'][i];
        msg = msg + '<a href="#" onclick="parent.selectOption(' + "'" + option['queueId'] + "'" + ')">' + option['phrase'] + '</a><br/>';
    }
    makeRow('left', msg, messageQueue['player_icon']);
}    

function selectOption(queueId) {
    for (var i = 0; i < messageQueue['options'].length; i++) {
        if (queueId == messageQueue['options'][i]['queueId']) {
            setRowMessage('left', messageQueue['options'][i]['phrase'], messageQueue['player_icon']);
            break;
        }
    }
    getMessageQueue(queueId);
}

function setNPCMessage() {
    makeRow('right', '...', messageQueue['npc_icon']);
	setTimeout(writeNPCMessage, message['delay']);
}

function writeNPCMessage() {
    setRowMessage('right', message['phrase'], messageQueue['npc_icon']);
    processCurrentMessage();
}

function printPlayerMessage() {
	messageContainer = document.getElementById("message");
	intervalObject = setInterval(typeMessage, 75);
	currentChar = 0;
	document.getElementById("rawMessage").innerHTML = message['phrase'];
	message['phrase'] = message['phrase'].replace(/(<([^>]+)>)/ig, "");
}

function typeMessage() {
    if (currentChar < message['phrase'].length) {
		messageContainer.innerHTML = messageContainer.innerHTML + message['phrase'].charAt(currentChar++);
	} else {
	    clearInterval(intervalObject);
        var button = document.getElementById("playerMessageSendButton");
        button.disabled = false;
	}
}

function postPlayerMessage() {
    var button = document.getElementById("playerMessageSendButton");
    button.disabled = true;
    makeRow('left', message['phrase'], messageQueue['player_icon']);
    messageContainer.innerHTML = "&nbsp;";
    processCurrentMessage();
}

function makeRow(alignment, msg, icon_url) {
    rowID++;
    var container = frames[0].document.getElementById("dialog");
	container.innerHTML = container.innerHTML +  '<tr><td align="' + alignment + '" id="r' + rowID + '">' + createIcon(alignment, icon_url) + msg + '</td></tr>';
    frames[0].scrollToBottom();
}

function setRowMessage(alignment, msg, icon_url) {
	var row = frames[0].document.getElementById("r" + rowID);
	row.innerHTML = createIcon(alignment, icon_url) + msg;
    frames[0].scrollToBottom();
}    

function createIcon(alignment, icon_url) {
    if (alignment == 'left') {
        padding = "right";
    } else {
        padding = "left";
    }
    return '<img alt="icon" width="48" src="' + icon_url +'" style="float:' + alignment +';padding-' + padding + ':5px;"/>';
}